//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Main on 02.03.2025.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    private var profileImageView: UIImageView = UIImageView()
    private var logOutButtonView: UIButton = UIButton()
    private var fioLabelView: UILabel = UILabel()
    private var nicknameLabelView: UILabel = UILabel()
    private var descriptionLabelView: UILabel = UILabel()
    
    private var profileImageServiceObserver: NSObjectProtocol?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
        updateAvatar()
       
        if let profile = ProfileService.shared.profile {
            updateProfileDetails(profile: profile)
        }
        
        renderProfileImage()
        renderLogOutButtonView()
        renderLabelViews(
            currentLabelView: fioLabelView,
            topOffsetView: profileImageView,
            fontColor: .white,
            fontSize: 23,
            fontWeight: .bold
        )
        renderLabelViews(
            currentLabelView: nicknameLabelView,
            topOffsetView: fioLabelView,
            fontColor: .ypGrey,
            fontSize: 13
        )
        renderLabelViews(
            currentLabelView: descriptionLabelView,
            topOffsetView: nicknameLabelView,
            fontColor: .white,
            fontSize: 13
        )
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        let processor = RoundCornerImageProcessor(cornerRadius: 20)
        profileImageView.kf.setImage(with: url,
                                     placeholder: UIImage(resource: .photo),
                              options: [.processor(processor)])
    }
    
    private func updateProfileDetails(profile: Profile) {
        self.fioLabelView.text = profile.name
        self.nicknameLabelView.text = profile.loginName
        self.descriptionLabelView.text = profile.bio
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
        
        logOutButtonView.addTarget(self, action: #selector(didTapLogoutButton), for: .touchUpInside)
    }
    
    private func renderLabelViews(currentLabelView: UILabel, topOffsetView: UIView, fontColor: UIColor, fontSize: CGFloat, fontWeight: UIFont.Weight = .regular){
        currentLabelView.font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        currentLabelView.textColor = fontColor
        view.addSubview(currentLabelView)
        
        currentLabelView.translatesAutoresizingMaskIntoConstraints = false
        
        currentLabelView.topAnchor.constraint(equalTo: topOffsetView.bottomAnchor, constant: 8).isActive = true
        currentLabelView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
    }
    
    @objc private func didTapLogoutButton() {
        ProfileLogoutService.shared.logout()
    }
}
