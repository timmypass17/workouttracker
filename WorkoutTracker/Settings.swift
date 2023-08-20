//
//  Settings.swift
//  WorkoutTracker
//
//  Created by Timmy Nguyen on 8/6/23.
//

import Foundation

enum SortBy: Codable {
    case alphabetically, weight, recent
}

struct Settings {
    static let logBadge = "logBadge"
    static let sortPreference = "sortPreference"
    static let weightUnit = "weightUnit"
    static let theme = "theme"
    
    static var shared = Settings()
    
    private let defaults = UserDefaults.standard
    
    private func archiveJSON<T: Encodable>(value: T, key: String) {
        let data = try! JSONEncoder().encode(value)
        let string = String(data: data, encoding: .utf8)
        defaults.set(string, forKey: key)
    }
    
    private func unarchiveJSON<T: Decodable>(key: String) -> T? {
        guard let string = defaults.string(forKey: key),
              let data = string.data(using: .utf8) else {
            return nil
        }
        
        return try! JSONDecoder().decode(T.self, from: data)
    }
    
    var logBadgeValue: Int {
        get {
            return unarchiveJSON(key: Settings.logBadge) ?? 0
        }
        set {
            archiveJSON(value: newValue, key: Settings.logBadge)
        }
    }

    var sortingPreference: SortBy {
        get {
            return unarchiveJSON(key: Settings.sortPreference) ?? .alphabetically
        }
        set {
            archiveJSON(value: newValue, key: Settings.sortPreference)
        }
    }
    
    var weightUnit: WeightType {
        get {
            return unarchiveJSON(key: Settings.weightUnit) ?? .lbs
        }
        set {
            archiveJSON(value: newValue, key: Settings.weightUnit)
        }
    }
    
    var theme: Theme {
        get {
            return unarchiveJSON(key: Settings.theme) ?? .automatic
        }
        set {
            archiveJSON(value: newValue, key: Settings.theme)
        }
    }
}
