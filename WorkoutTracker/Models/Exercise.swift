//
//  Exercise.swift
//  WorkoutTracker
//
//  Created by Timmy Nguyen on 7/26/23.
//

import Foundation

struct Exercise {
    var name: String
    var sets: Int
    var reps: Int
    var weight: Int
}

extension Exercise: Codable { }
