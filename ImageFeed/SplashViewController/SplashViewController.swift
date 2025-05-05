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
    
    private let oauth2TokenStorage = OAuth2TokenStorage()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let token = oauth2TokenStorage.token {
            fetchProfile(token)
        } else {
            performSegue(withIdentifier: showAuthenticationScreenSegueIdentifier, sender: nil)
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
            guard let self else { return }
            UIBlockingProgressHUD.dismiss()
            switch result {
            case .success(let token):
                oauth2TokenStorage.token = token
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
            }
        }
        
    }
}
