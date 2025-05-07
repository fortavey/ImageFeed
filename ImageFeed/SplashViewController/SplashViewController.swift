//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Main on 24.04.2025.
//

import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
        
    private var logoImageView: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        
        logoImageRender()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let token = OAuth2TokenStorage.shared.token {
            fetchProfile(token)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: .main)
            let viewController = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController
            guard let authViewController = viewController else { return }
            authViewController.delegate = self
            authViewController.modalPresentationStyle = .fullScreen
            self.present(authViewController, animated: true)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
    
    private func logoImageRender() {
        let logoImage = UIImage(named: "splash_screen_logo")
        logoImageView = UIImageView(image: logoImage)
        guard let logoImageView else { return }
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(logoImageView)
        NSLayoutConstraint.activate([
            logoImageView.heightAnchor.constraint(equalToConstant: 78),
            logoImageView.widthAnchor.constraint(equalToConstant: 75),
            logoImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
}

extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthenticationScreenSegueIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else { fatalError("Failed to prepare for \(showAuthenticationScreenSegueIdentifier)") }
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        self.fetchOAuthToken(code, vc: vc)
    }

    private func fetchOAuthToken(_ code: String, vc: AuthViewController) {
        UIBlockingProgressHUD.show()
        OAuth2Service.shared.fetchOAuthToken(code: code) { [weak self] result in
            DispatchQueue.main.async {
                UIBlockingProgressHUD.dismiss()
            }
            guard let self else { return }
            switch result {
            case .success(let token):
                OAuth2TokenStorage.shared.token = token
                DispatchQueue.main.async {
                    OAuth2Service.shared.networkClient.task = nil
                    OAuth2Service.shared.lastCode = nil
                    self.fetchProfile(token)
                    vc.dismiss(animated: true)
                }
            case .failure(let error):
                let alert = UIAlertController(title: "Что-то пошло не так",
                                              message: "Не удалось войти в систему",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ок", style: .default))
                vc.present(alert, animated: true)
                print(error)
            }
        }
    }
    
    private func fetchProfile(_ token: String) {
        ProfileService.shared.fetchProfile(token) { [weak self] user in
            guard let self else { return }
            
            switch user {
            case .success(let user):
                DispatchQueue.main.async {
                    ProfileService.shared.networkClient.task = nil
                    ProfileImageService.shared.fetchProfileImageURL(username: user.username) { result in
                        switch result {
                        case .success(let smallProfileImage):
                            print(smallProfileImage)
                        case .failure(let error):
                            print("[SplashViewController] - \(error.localizedDescription)")
                        }
                    }
                    self.switchToTabBarController()
                }
            case .failure(let error):
                print(error)
                let alert = UIAlertController(title: "Что-то пошло не так",
                                              message: error.localizedDescription,
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ок", style: .default))
                
                DispatchQueue.main.async {
                    self.present(alert, animated: true)
                }
            }
        }
        
    }
}
