//
//  SceneDelegate.swift
//  UIDynamicsSample
//
//  Created by Gabriela Bezerra on 04/09/20.
//  Copyright © 2020 Gabriela Bezerra. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = FieldBehaviorViewController()
            self.window = window
            window.makeKeyAndVisible()
        }
    }

}

