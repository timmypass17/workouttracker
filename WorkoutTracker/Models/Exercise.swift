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
    var sets: String
    var reps: String
    var weight: String // Note: Weight is always stored in lbs. String is easier to work with empty placeholders for textfields.
    var date: Date?
    
    // Cell properties
    var isComplete: Bool = false
    var isEditing: Bool = false
    
    func getWeightString(includeUnits: Bool = false) -> String {
        func formatWeight(_ weight: Float) -> String {
            // e.g. 44.232582 -> 44.2
            let formatter = NumberFormatter()
            formatter.maximumFractionDigits = 1
            formatter.minimumFractionDigits = 0
            
            return formatter.string(from: NSNumber(value: weight)) ?? ""
        }
        
        let weightValue = Float(weight) ?? 0.0
        switch Settings.shared.weightUnit {
        case .lbs:
            return includeUnits ? "\(formatWeight(weightValue)) lbs" : "\(formatWeight(weightValue))"
        case .kg:
            // Convert weight to kg if necessary
            let weightInKg = weightValue * 0.45359237
            return includeUnits ? "\(formatWeight(weightInKg)) kg" : "\(formatWeight(weightInKg))"

        }
    }
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
