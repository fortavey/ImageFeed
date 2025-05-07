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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }
}
