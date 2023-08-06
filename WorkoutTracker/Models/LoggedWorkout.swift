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

    var loggedWorkouts: [Workout] = loadWorkoutLogs() ?? []
        
    static func loadWorkoutLogs() -> [Workout]? {
        print("loading workout")
        guard let workouts = try? Data(contentsOf: LoggedWorkout.archiveURL) else { return nil }
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(Array<Workout>.self, from: workouts)
    }
    
    static func saveWorkoutLogs(_ workouts: [Workout]) {
        print("Save workouts")
        let propertyListEncoder = PropertyListEncoder()
        let codedToDos = try? propertyListEncoder.encode(workouts)
        try? codedToDos?.write(to: LoggedWorkout.archiveURL, options: .noFileProtection)
    }
}
