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
        let encodedWorkouts = try? propertyListEncoder.encode(workouts)
        try? encodedWorkouts?.write(to: archiveURL, options: .noFileProtection)
    }
}

extension Workout: Codable { }

extension Workout: Equatable {
    static func == (lhs: Workout, rhs: Workout) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Workout {
    
    static let sampleWorkouts: [Workout] = [
        Workout(
            name: "Push Day",
            exercises: [
                Exercise(name: "Bench Press", sets: "4", reps: "5", weight: "45"),
                Exercise(name: "Overhead Press", sets: "3", reps: "12", weight: "45"),
                Exercise(name: "Incline Bench Press", sets: "3", reps: "12", weight: "20"),
                Exercise(name: "Triceps Push Down", sets: "3", reps: "12", weight: "20"),
                Exercise(name: "Lateral Raises", sets: "3", reps: "12", weight: "15")
            ]
        ),
        Workout(
            name: "Pull Day",
            exercises: [
                Exercise(name: "Deadlifts", sets: "4", reps: "5", weight: "65"),
                Exercise(name: "Pullups", sets: "3", reps: "12", weight: "135"),
                Exercise(name: "Seated Cable Rows", sets: "3", reps: "12", weight: "30"),
                Exercise(name: "Face Pulls", sets: "5", reps: "20", weight: "15"),
                Exercise(name: "Hammer Curls", sets: "4", reps: "12", weight: "15"),
                Exercise(name: "Dumbbell Curls", sets: "4", reps: "12", weight: "15")
            ]
        ),
        Workout(
            name: "Leg day",
            exercises: [
                Exercise(name: "Squat (Barbell)", sets: "3", reps: "5", weight: "45"),
                Exercise(name: "Front Squat (Barbell)", sets: "3", reps: "5", weight: "45"),
                Exercise(name: "Lunges", sets: "4", reps: "12", weight: "20"),
                Exercise(name: "Goblet Squat (Dumbell)", sets: "4", reps: "12", weight: "20")
            ]
        )
    ]
    
//    static let fakeWorkoutData: [String: [Workout]] = {
//        let pushDay = completeSampleWorkouts[0]
//        let pullDay = completeSampleWorkouts[1]
//        let legDay = completeSampleWorkouts[2]
//
//        let day: TimeInterval = 24 * 60 * 60
//
//        var pushDay1 = pushDay
//        pushDay1.startTime = Date()
//        for i in pushDay1.exercises.indices {
//            pushDay1.exercises[i].date = Date()
//        }
//
//        var pullDay1 = pullDay
//        pullDay1.startTime = Date().addingTimeInterval(day * -2)
//        for i in pullDay1.exercises.indices {
//            pullDay1.exercises[i].date = Date().addingTimeInterval(day * -2)
//        }
//
//        var legDay1 = legDay
//        legDay1.startTime = Date().addingTimeInterval(day * -4)
//        for i in legDay1.exercises.indices {
//            legDay1.exercises[i].date = Date().addingTimeInterval(day * -4)
//        }
//
//        var pushDay2 = pushDay
//        pushDay2.startTime = Date().addingTimeInterval(day * -15)
//        for i in pushDay2.exercises.indices {
//            pushDay2.exercises[i].date = Date().addingTimeInterval(day * -15)
//        }
//
//        var pullDay2 = pullDay
//        pullDay2.startTime = Date().addingTimeInterval(day * -17)
//        for i in pullDay2.exercises.indices {
//            pullDay2.exercises[i].date = Date().addingTimeInterval(day * -17)
//        }
//
//        var legDay2 = legDay
//        legDay2.startTime = Date().addingTimeInterval(day * -19)
//        for i in legDay2.exercises.indices {
//            legDay2.exercises[i].date = Date().addingTimeInterval(day * -19)
//        }
//
//        var pushDay3 = pushDay
//        pushDay3.startTime = Date().addingTimeInterval(day * -21)
//        for i in pushDay3.exercises.indices {
//            pushDay3.exercises[i].date = Date().addingTimeInterval(day * -21)
//        }
//
//        var pullDay3 = pullDay
//        pullDay3.startTime = Date().addingTimeInterval(day * -23)
//        for i in pullDay3.exercises.indices {
//            pullDay3.exercises[i].date = Date().addingTimeInterval(day * -23)
//        }
//
//        var legDay3 = legDay
//        legDay3.startTime = Date().addingTimeInterval(day * -25)
//        for i in legDay3.exercises.indices {
//            legDay3.exercises[i].date = legDay3.startTime
//        }
//
//        // Create a dictionary to group workouts by month and year
//        var groupedWorkouts: [String: [Workout]] = [
//            "September 2023": [pushDay1, pullDay1, legDay1],
//            "August 2023": [pushDay2, pullDay2, legDay2, pushDay3, pullDay3, legDay3]
//        ]
//
//        return groupedWorkouts
//    }()
}
