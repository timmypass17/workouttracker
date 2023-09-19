//
//  Theme.swift
//  WorkoutTracker
//
//  Created by Timmy Nguyen on 8/16/23.
//

import Foundation

enum Theme: String, CaseIterable, Codable {
    case automatic, light, dark
    
    static let themeUpdatedNotification = Notification.Name("Theme.themeUpdatedNotification")
    
    var name: String {
        return rawValue.capitalized
    }
    
}


