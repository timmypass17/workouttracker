//
//  Workout.swift
//  WorkoutTracker
//
//  Created by Timmy Nguyen on 7/26/23.
//

import Foundation
import UIKit

struct Workout {
    var name: String
    var exercises: [Exercise]
    var icon: UIImage? {
        return UIImage(systemName: "\(name.first!.lowercased()).circle.fill")
    }
}

extension Workout: Codable { }

extension Workout {
    static let sampleWorkouts = [
        Workout(
            name: "Leg day",
            exercises: [
                Exercise(name: "Squat (Barbell)", sets: 3, reps: 5, weight: 135),
                Exercise(name: "Front Squat (Barbell)", sets: 3, reps: 5, weight: 135),
                Exercise(name: "Lunges", sets: 4, reps: 12, weight: 135),
                Exercise(name: "Goblet Squat (Dumbell)", sets: 4, reps: 12, weight: 135)
            ]
        )
    ]
}
