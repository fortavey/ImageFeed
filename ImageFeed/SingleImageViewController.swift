//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Main on 02.03.2025.
//

import UIKit
import ProgressHUD

final class SingleImageViewController: UIViewController {
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var shareButtonView: UIButton!
    
    var photo: Photo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIBlockingProgressHUD.show()
        self.shareButtonView.setTitle("", for: .normal)
        
        if let photo {
            let photoImageURL = photo.largeImageURL
            guard let url = URL(string: photoImageURL) else { return }
            imageView.kf.setImage(
                with: url,
//                placeholder: UIImage(resource: .stub),
                options: [.transition(.fade(0.3))]
            ) {_ in 
                UIBlockingProgressHUD.dismiss()
            }
            imageView.frame.size = photo.size
            rescaleAndCenterImageInScrollView(photo: photo)
        }
       
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        
    }
    
    private func rescaleAndCenterImageInScrollView(photo: Photo) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = photo.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    

    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func didTapShareButton(_ sender: Any) {
        guard let photo else { return }
        let share = UIActivityViewController(
            activityItems: [photo],
            applicationActivities: nil
        )
        present(share, animated: true, completion: nil)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
