//
//  SceneDelegate.swift
//  OnTheMap
//
//  Created by Oladipupo Oluwatobi on 28/03/2020.
//  Copyright © 2020 Oladipupo Oluwatobi. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let nvc = UINavigationController(rootViewController: LoginViewController())
        window?.rootViewController = nvc
        window?.makeKeyAndVisible()
    }
}

