//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Main on 21.02.2025.
//

import UIKit

class ImagesListCell: UITableViewCell {
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var gradientView: UIView!
    
    static let reuseIdentifier = "ImagesListCell"
    
    func addGradient(){
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: self.frame.width - 32, height: self.gradientView.frame.height)
        gradientLayer.colors = [
            UIColor.black.withAlphaComponent(0.0).cgColor,
            UIColor(named: "YPBlack")?.withAlphaComponent(1.0).cgColor ?? UIColor.black.withAlphaComponent(1.0).cgColor
        ]
        gradientLayer.shouldRasterize = true
        self.gradientView.layer.insertSublayer(gradientLayer, at:0)
    }
}
