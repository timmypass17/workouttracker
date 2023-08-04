//
//  WorkoutLog.swift
//  WorkoutTracker
//
//  Created by Timmy Nguyen on 8/3/23.
//

import Foundation

struct WorkoutLog {
    var workouts: [Workout]
}

extension WorkoutLog: Codable { }
