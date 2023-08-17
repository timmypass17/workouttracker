//
//  WeightUnitType.swift
//  WorkoutTracker
//
//  Created by Timmy Nguyen on 8/16/23.
//

import Foundation

enum WeightType: CaseIterable, Codable {
    case lbs, kg
    
    var name: String {
        switch self {
        case .lbs:
            return "US/Imperial (lbs)"
        case .kg:
            return "Metric (kg)"
        }
    }
}
