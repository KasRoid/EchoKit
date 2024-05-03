//
//  SceneDelegate.swift
//  EchoKit-Demo
//
//  Created by Lukas on 4/19/24.
//

import EchoKit
import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        Console.start()
    }
}
