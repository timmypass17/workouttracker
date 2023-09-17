//
//  Log.swift
//  WorkoutTracker
//
//  Created by Timmy Nguyen on 8/5/23.
//

import Foundation

struct LoggedWorkout {
    static var shared = LoggedWorkout() // make this static so that we can easily update logged workout from another unrelated screen such as workout details
    static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let archiveURL = documentsDirectory.appending(path: "logs").appendingPathExtension("plist")
    static let logUpdatedNotification = Notification.Name("LoggedWorkout.logUpdated")
    static let logAddedNotification = Notification.Name("LoggedWorkout.logAdded")
    static let logRemovedNotification = Notification.Name("LoggedWorkout.logRemoved")

    
    var loggedWorkoutsBySection: [String: [Workout]] = loadWorkoutLogs() ?? [:]
        
    
    // TODO: Maybe make these methods generic
    static func loadWorkoutLogs() -> [String: [Workout]]? {
        guard let workouts = try? Data(contentsOf: LoggedWorkout.archiveURL) else { return nil }
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode([String: [Workout]].self, from: workouts)
    }
    
    static func saveWorkoutLogs(_ workouts: [String: [Workout]]) {
        let propertyListEncoder = PropertyListEncoder()
        let encodedWorkoutLogs = try? propertyListEncoder.encode(workouts)
        try? encodedWorkoutLogs?.write(to: LoggedWorkout.archiveURL, options: .noFileProtection)
    }
}
