//
//  SceneDelegate.swift
//  WorkoutTracker
//
//  Created by Timmy Nguyen on 7/25/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var logTabBarItem: UITabBarItem!
    
    // @objc to use as selector
//    @objc func incrementOrderBadge() {
//        print("Incrementing badge")
//        Settings.shared.logBadgeValue += 1
//        logTabBarItem.badgeValue = Settings.shared.logBadgeValue > 0 ? String(Settings.shared.logBadgeValue) : nil
//    }
//
//    @objc func decrementOrderBadge() {
//        print("Decrementing badge")
//        Settings.shared.logBadgeValue = max(Settings.shared.logBadgeValue - 1, 0)
//        logTabBarItem.badgeValue = Settings.shared.logBadgeValue > 0 ? String(Settings.shared.logBadgeValue) : nil
//    }
    
    @objc func updateOrderBadge() {
//        Settings.shared.logBadgeValue = max(Settings.shared.logBadgeValue - 1, 0)
        let count = Settings.shared.logBadgeValue
        logTabBarItem.badgeValue = count > 0 ? String(count) : nil
    }
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateOrderBadge),
                                               name: LoggedWorkout.logUpdatedNotification,
                                               object: nil)
        
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(incrementOrderBadge),
//                                               name: LoggedWorkout.logAddedNotification,
//                                               object: nil)
//
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(decrementOrderBadge),
//                                               name: LoggedWorkout.logRemovedNotification,
//                                               object: nil)
//
        logTabBarItem = (window?.rootViewController as? UITabBarController)?.viewControllers?[1].tabBarItem
        logTabBarItem.badgeValue = Settings.shared.logBadgeValue > 0 ? String(Settings.shared.logBadgeValue) : nil
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

