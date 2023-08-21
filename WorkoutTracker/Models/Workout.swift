//
//  Workout.swift
//  WorkoutTracker
//
//  Created by Timmy Nguyen on 7/26/23.
//

import Foundation
import UIKit

struct Workout {
    var id: UUID = UUID()
    var name: String
    var exercises: [Exercise]
    var icon: UIImage? {
        return UIImage(systemName: "\(name.first?.lowercased() ?? "p").circle.fill")
    }
    
    var startTime: Date?
    var endTime: Date?
    
    var dayOfWeek: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        return dateFormatter.string(from: startTime ?? Date())
    }
    
    // Path to datastore
    // /Documents/
    static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    // /Documents/workouts.plist
    static let archiveURL = documentsDirectory.appending(path: "workouts").appendingPathExtension("plist")

    static func loadWorkouts() -> [Workout]? {
        guard let workouts = try? Data(contentsOf: archiveURL) else { return nil }
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(Array<Workout>.self, from: workouts)
    }
    
    static func saveWorkouts(_ workouts: [Workout]) {
        let propertyListEncoder = PropertyListEncoder()
        let codedToDos = try? propertyListEncoder.encode(workouts)
        try? codedToDos?.write(to: archiveURL, options: .noFileProtection)
    }
}

extension Workout: Codable { }

extension Workout: Equatable {
    static func == (lhs: Workout, rhs: Workout) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Workout {
    static let sampleWorkouts = [
        Workout(
            name: "Leg day",
            exercises: Exercise.sampleExercises
        ),
        
    ]
}
