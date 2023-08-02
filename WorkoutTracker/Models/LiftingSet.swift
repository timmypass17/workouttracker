//
//  LiftingSet.swift
//  WorkoutTracker
//
//  Created by Timmy Nguyen on 8/1/23.
//

import Foundation

struct LiftingSet {
    var number: Int
    var previous: Int
    var weight: Int
    var reps: Int
}

extension LiftingSet: Codable { }
