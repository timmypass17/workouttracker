//
//  Exercise.swift
//  WorkoutTracker
//
//  Created by Timmy Nguyen on 7/26/23.
//

import Foundation

struct Exercise {
    var name: String
    var sets: String    // easier to make string to show empty placeholders for textfields
    var reps: String
    var weight: String
    
    // Cell properties
    var isComplete: Bool = false
    var isEditing: Bool = false
}

extension Exercise: Codable { }
