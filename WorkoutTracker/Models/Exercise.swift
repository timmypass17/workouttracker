//
//  Exercise.swift
//  WorkoutTracker
//
//  Created by Timmy Nguyen on 7/26/23.
//

import Foundation

struct Exercise: Identifiable {
    var id = UUID()
    var name: String
    var sets: String    // easier to make string to show empty placeholders for textfields
    var reps: String
    var weight: String
    
    var date: Date?
    
    // Cell properties
    var isComplete: Bool = false
    var isEditing: Bool = false
}

extension Exercise: Codable { }

extension Exercise {
    static let sampleExercises = [
        Exercise(name: "Squat (Barbell)", sets: "3", reps: "5", weight: "135"),
        Exercise(name: "Front Squat (Barbell)", sets: "3", reps: "5", weight: "135"),
        Exercise(name: "Lunges", sets: "4", reps: "12", weight: "45"),
        Exercise(name: "Goblet Squat (Dumbell)", sets: "4", reps: "12", weight: "55")
    ]
}
