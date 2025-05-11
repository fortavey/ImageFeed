//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Main on 02.03.2025.
//

import UIKit
import Kingfisher

public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    func updateProfileDetails(profile: Profile)
    func configure(_ presenter: ProfilePresenterProtocol)
    func updateAvatar(url: URL)
}

final class ProfileViewController: UIViewController & ProfileViewControllerProtocol {
    var presenter: ProfilePresenterProtocol?
    
    private var profileImageView: UIImageView = UIImageView()
    private var logOutButtonView: UIButton = UIButton()
    private var fioLabelView: UILabel = UILabel()
    private var nicknameLabelView: UILabel = UILabel()
    private var descriptionLabelView: UILabel = UILabel()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        logOutButtonView.accessibilityIdentifier = "logoutButton"
        
        if let presenter {
            presenter.viewDidLoad()
            presenter.updateProfileDetails()
        }
       
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
    
    func configure(_ presenter: ProfilePresenterProtocol) {
        self.presenter = presenter
        guard var selfPresenter = self.presenter else { return }
        selfPresenter.view = self
    }
    
    func updateAvatar(url: URL) {
        let processor = RoundCornerImageProcessor(cornerRadius: 35, targetSize: CGSize(width: 70, height: 70), backgroundColor: .clear)
        profileImageView.kf.setImage(with: url, placeholder: UIImage(resource: .photo), options: [.processor(processor)])
    }
    
    func updateProfileDetails(profile: Profile) {
        self.fioLabelView.text = profile.name
        self.nicknameLabelView.text = profile.loginName
        self.descriptionLabelView.text = profile.bio
    }

    private func renderProfileImage() {
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
        logOutButtonView.addTarget(self, action: #selector(clickLogoutButton), for: .touchUpInside)
    }
    
    private func renderLabelViews(currentLabelView: UILabel, topOffsetView: UIView, fontColor: UIColor, fontSize: CGFloat, fontWeight: UIFont.Weight = .regular){
        currentLabelView.font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        currentLabelView.textColor = fontColor
        view.addSubview(currentLabelView)
        currentLabelView.translatesAutoresizingMaskIntoConstraints = false
        currentLabelView.topAnchor.constraint(equalTo: topOffsetView.bottomAnchor, constant: 8).isActive = true
        currentLabelView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
    }
    
    @objc private func clickLogoutButton() {
        showLogoutAlert()
    }
    
    private func showLogoutAlert() {
        let alert = UIAlertController(title: "Пока, пока!", message: "Вы уверены, что хотите выйти?", preferredStyle: .alert)
        let logoutAction = UIAlertAction(title: "Да", style: .destructive) { [weak self] _ in
            guard let self, let presenter = self.presenter else { return }
            presenter.logout()
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        alert.addAction(logoutAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
}

extension ProfileViewController: ProfileLogoutServiceDelegate {
    func navigateAfterLogout() {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.first else { return }
            window.rootViewController = SplashViewController()
            window.makeKeyAndVisible()
        }
    }
}
