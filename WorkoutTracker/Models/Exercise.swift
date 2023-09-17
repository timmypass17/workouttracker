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
    
    var weight: String // always in lbs
    var weightFormatted: String {
        switch Settings.shared.weightUnit {
        case .lbs:
            return "\(getWeightString())lbs"
        case .kg:
            return "\(getWeightString())kg"
        }
    }
    
    var date: Date?
    
    // Cell properties
    var isComplete: Bool = false
    var isEditing: Bool = false
    
    mutating func setWeight(weight: String) {
        switch Settings.shared.weightUnit {
        case .lbs:
            self.weight = weight
        case .kg:
            // Convert to lb
            self.weight = String((Float(weight) ?? 0) * 2.20462)
        }
    }
    
    func getWeightString(includeUnits: Bool = false) -> String {
        func formatWeight(_ weight: Float) -> String {
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
            let weightInKg = weightValue * 0.45359237
//            return String(format: includeUnits ? "%.2f kg" : "%.2f", weightInKg)
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
