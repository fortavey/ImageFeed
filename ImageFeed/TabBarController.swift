//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Main on 05.05.2025.
//

import UIKit

final class TabBarController: UITabBarController {
   override func awakeFromNib() {
       super.awakeFromNib()
       let storyboard = UIStoryboard(name: "Main", bundle: .main)
       let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController")
       let profileViewController = ProfileViewController()
       profileViewController.tabBarItem = UITabBarItem(
           title: "",
           image: UIImage(systemName: "person.circle.fill"),
           selectedImage: nil
       )
       self.viewControllers = [imagesListViewController, profileViewController]
   }
}
