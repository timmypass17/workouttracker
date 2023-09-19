//
//  Log.swift
//  WorkoutTracker
//
//  Created by Timmy Nguyen on 8/5/23.
//

import Foundation

struct LoggedWorkout {
    // make this static so that we can easily update logged workout from another unrelated screen such as workout details
    static var shared = LoggedWorkout()
    
    var loggedWorkoutsBySection: [String: [Workout]] = loadWorkoutLogs() ?? [:]
    
    static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let archiveURL = documentsDirectory.appending(path: "logs").appendingPathExtension("plist")
    static let logUpdatedNotification = Notification.Name("LoggedWorkout.logUpdated")
    
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
