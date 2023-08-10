//
//  Settings.swift
//  WorkoutTracker
//
//  Created by Timmy Nguyen on 8/6/23.
//

import Foundation


enum Setting {
    static let logBadge = "logBadge"
}

struct Settings {
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
            return unarchiveJSON(key: Setting.logBadge) ?? 0
        }
        set {
            archiveJSON(value: newValue, key: Setting.logBadge)
        }
    }
}
