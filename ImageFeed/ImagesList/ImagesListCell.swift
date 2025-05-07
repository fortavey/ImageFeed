//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Main on 21.02.2025.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var gradientView: UIView!
    
    var photo: Photo?
    var vc: ImagesListViewController?
    
    static let reuseIdentifier = "ImagesListCell"
    private let gradientLayer = CAGradientLayer()
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        likeButton.setTitle("", for: .normal) // У кнопки непонятно откуда появляется дефолтный текст
        addGradient()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = CGRect(x: 0,
                                     y: 0,
                                     width: self.frame.width - 32,
                                     height: self.gradientView.frame.height)
    }
    
    func configCell(){
        guard let photo else { return }
        print(photo)
        let photoImageURL = photo.thumbImageURL
        guard let url = URL(string: photoImageURL) else { return }
        setImage(with: url)
        likeButton.tintColor = photo.isLiked ? .systemRed : .systemGray
        guard let createdAt = photo.createdAt else { return }
        if let vc {
            dateLabel.text = vc.dateFormatter.string(from: createdAt)
        }
    }
    
    private func addGradient(){
        gradientLayer.colors = [
            UIColor.black.withAlphaComponent(0.0).cgColor,
            UIColor(named: "YPBlack")?.withAlphaComponent(1.0).cgColor ?? UIColor.black.withAlphaComponent(1.0).cgColor
        ]
        gradientLayer.shouldRasterize = true
        gradientView.layer.insertSublayer(gradientLayer, at:0)
    }
    
    func setImage(with url: URL?) {
        cellImage.kf.setImage(
            with: url,
            placeholder: UIImage(resource: .stub),
            options: [.transition(.fade(0.3))]
        )
    }
    
    func setIsLiked() {
        guard let photo else { return }
        likeButton.tintColor = photo.isLiked ? .systemRed : .systemGray
    }
    
    func updatePhoto(){
        guard let photo else { return }
        if let index = ImagesListService.shared.photos.firstIndex(where: { $0.id == photo.id }) {
            let photo = ImagesListService.shared.photos[index]
            
            self.photo = photo
        }
    }
    
    @IBAction func clickLike(_ sender: Any) {
        UIBlockingProgressHUD.show()
        guard let photo else { return }
        ImagesListService.shared.changeLike(photoId: photo.id, isLike: photo.isLiked) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let photo):
                DispatchQueue.main.async {
                    self.photo = photo
                    UIBlockingProgressHUD.dismiss()
                    self.setIsLiked()
                }
            case .failure(let error):
                print("[ImagesListCell]", "Ошибка сетевого запроса", error)
                DispatchQueue.main.async {
                    UIBlockingProgressHUD.dismiss()
                }
            }
            
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }
}
