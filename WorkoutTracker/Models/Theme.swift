//
//  Theme.swift
//  WorkoutTracker
//
//  Created by Timmy Nguyen on 8/16/23.
//

import Foundation

enum Theme: String, CaseIterable, Codable {
    case automatic, light, dark
    
    var name: String {
        return rawValue.capitalized
    }
    
    static let themeUpdatedNotification = Notification.Name("Theme.themeUpdatedNotification")
}


