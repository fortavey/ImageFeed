//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Main on 02.03.2025.
//

import UIKit

final class ProfileViewController: UIViewController {
    var profileImageView: UIImageView = UIImageView()
    var logOutButtonView: UIButton = UIButton()
    var fioLabelView: UILabel = UILabel()
    var nicknameLabelView: UILabel = UILabel()
    var descriptionLabelView: UILabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        renderProfileImage()
        renderLogOutButtonView()
        renderLabelViews(
            currentLabelView: fioLabelView,
            labelText: "Екатерина Новикова",
            topOffsetView: profileImageView,
            fontColor: .white,
            fontSize: 23,
            fontWeight: .bold
        )
        renderLabelViews(
            currentLabelView: nicknameLabelView,
            labelText: "@ekaterina_nov",
            topOffsetView: fioLabelView,
            fontColor: .ypGrey,
            fontSize: 13
        )
        renderLabelViews(
            currentLabelView: descriptionLabelView,
            labelText: "Hello, world!",
            topOffsetView: nicknameLabelView,
            fontColor: .white,
            fontSize: 13
        )
    }

    private func renderProfileImage() {
        let image = UIImage(named: "Photo") ?? UIImage(systemName: "person.crop.circle.fill")
        profileImageView.image = image
                
        view.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
    
    private func renderLogOutButtonView(){
        logOutButtonView.setImage(UIImage(systemName: "ipad.and.arrow.forward"), for: .normal)
        logOutButtonView.tintColor = .ypRed
        
        view.addSubview(logOutButtonView)
        logOutButtonView.translatesAutoresizingMaskIntoConstraints = false
        
        logOutButtonView.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        logOutButtonView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        logOutButtonView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        logOutButtonView.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    private func renderLabelViews(currentLabelView: UILabel, labelText: String, topOffsetView: UIView, fontColor: UIColor, fontSize: CGFloat, fontWeight: UIFont.Weight = .regular){
        currentLabelView.text = labelText
        currentLabelView.font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        currentLabelView.textColor = fontColor
        view.addSubview(currentLabelView)
        
        currentLabelView.translatesAutoresizingMaskIntoConstraints = false
        
        currentLabelView.topAnchor.constraint(equalTo: topOffsetView.bottomAnchor, constant: 8).isActive = true
        currentLabelView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
    }
}
