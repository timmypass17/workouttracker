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
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        // Init app with user's preferences
        updateTheme()
        updateAccentColor()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateOrderBadge),
                                               name: LoggedWorkout.logUpdatedNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateTheme),
                                               name: Theme.themeUpdatedNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateAccentColor),
                                               name: AccentColor.accentColorUpdatedNotification,
                                               object: nil)

        logTabBarItem = (window?.rootViewController as? UITabBarController)?.viewControllers?[1].tabBarItem
        logTabBarItem.badgeValue = Settings.shared.logBadgeValue > 0 ? String(Settings.shared.logBadgeValue) : nil
    }
    
    @objc func updateOrderBadge() {
        let count = Settings.shared.logBadgeValue
        logTabBarItem.badgeValue = count > 0 ? String(count) : nil
    }
    
    @objc func updateTheme() {
        let theme = Settings.shared.theme
        
        switch theme {
        case .automatic:
            self.window?.overrideUserInterfaceStyle = .unspecified
        case .light:
            self.window?.overrideUserInterfaceStyle = .light
        case .dark:
            self.window?.overrideUserInterfaceStyle = .dark
        }
    }
    
    @objc func updateAccentColor() {
        window?.tintColor = Settings.shared.accentColor.color
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

