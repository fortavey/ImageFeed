//
//  ViewController.swift
//  ImageFeed
//
//  Created by Main on 20.02.2025.
//

import UIKit
import Kingfisher
import ProgressHUD

public protocol ImageListViewControllerProtocol: AnyObject {
    var presenter: ImageListPresenterProtocol? { get set }
    var photos: [Photo] { get set }
    func updateLikeUISuccess(cell: ImagesListCell, photo: Photo)
    func updateLikeUIFailure()
    func updateTableViewAnimated()
}

final class ImagesListViewController: UIViewController & ImageListViewControllerProtocol {
    var presenter: ImageListPresenterProtocol?
    
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    var photos: [Photo] = []
    private var isLoad: Bool = true

    @IBOutlet private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isLoad {
            UIBlockingProgressHUD.show()
        }
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        if let presenter {
            presenter.viewDidLoad()
        }
    }
    
    func configure(_ presenter: ImageListPresenterProtocol) {
        self.presenter = presenter
        presenter.view = self
    }
    
    func updateTableViewAnimated() {
        let oldCount = tableView.numberOfRows(inSection: 0)
        let newCount = photos.count
        
        guard newCount > oldCount else { return }
        
        let newIndexPaths = (oldCount..<newCount).map { IndexPath(row: $0, section: 0) }
        
        tableView.performBatchUpdates({
            tableView.insertRows(at: newIndexPaths, with: .automatic)
        }, completion: nil)
        
        if isLoad {
            UIBlockingProgressHUD.dismiss()
            isLoad = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            else {
                assertionFailure("Invalid segue destination")
                return
            }
            
            let photo = photos[indexPath.row]
            viewController.photo = photo
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        cell.delegate = self
        let photo = photos[indexPath.row]
        cell.photo = photo
        cell.configCell()
    }
    
    func updatePhotosAfterLike(likedPhoto: Photo) {
        if let index = self.photos.firstIndex(where: { $0.id == likedPhoto.id }) {
            self.photos[index] = likedPhoto
        }
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
    
    
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let photo = photos[indexPath.row]
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = photo.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = photo.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(
      _ tableView: UITableView,
      willDisplay cell: UITableViewCell,
      forRowAt indexPath: IndexPath
    ) {
        if indexPath.row == photos.count - 1, let presenter {
            presenter.fetchPhotosNextPage()
        }
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func getDateFormated(createdAt: Date) -> String {
        guard let presenter else { return "" }
        return presenter.dateFormatter.string(from: createdAt)
    }
    
    func updateLikeUISuccess(cell: ImagesListCell, photo: Photo){
        DispatchQueue.main.async {
            cell.photo = photo
            cell.setIsLikedUI()
            self.updatePhotosAfterLike(likedPhoto: photo)
            UIBlockingProgressHUD.dismiss()
            cell.setIsLikedUI()
        }
    }
    
    func updateLikeUIFailure(){
        DispatchQueue.main.async {
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    
    func imageListCellClickLike(_ cell: ImagesListCell) {
        UIBlockingProgressHUD.show()
        presenter?.imageListCellClickLike(cell)
    }
}
