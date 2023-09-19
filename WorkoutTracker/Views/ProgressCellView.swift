//
//  ProgressCellView.swift
//  WorkoutTracker
//
//  Created by Timmy Nguyen on 8/7/23.
//

import SwiftUI
import Charts

struct ExerciseProgressCellView: View {
    var data: [Exercise]
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 4) {
                ExerciseTitleView(title: data.first!.name)
                HighestWeightView(
                    highestWeight: data
                        .max { Float($0.weight) ?? 0.0 < Float($1.weight) ?? 0.0 }?
                        .getWeightString(includeUnits: true) ?? "0",
                    recentExercise: data.max(by: { $0.date! < $1.date! })!
                )
            }
            
            Spacer(minLength: 20)
            ExerciseChartView(exercises: data)
                .padding(8)
        }
        .frame(height: 90)
    }
}

struct ExerciseTitleView: View {
    var title: String
    
    var body: some View {
        HStack {
            Image(systemName: "dumbbell.fill")
                .foregroundColor(.accentColor)
            Text(title)
        }
        .font(.system(.headline, weight: .bold))
    }
}

struct HighestWeightView: View {
    var highestWeight: String
    var recentExercise: Exercise
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Best: \(highestWeight)")
                .font(.subheadline)
                .padding(.horizontal, 8)
                .padding(.vertical, 2)
                .background(.secondary.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 4))
            
            HStack(alignment: .firstTextBaseline) {
                Text("Latest: \(recentExercise.getWeightString(includeUnits: true))")
                    .foregroundColor(.secondary)
                    .font(.caption)
            }
            
            Text("Updated: \(formatDateMonthDayYear((recentExercise.date!)))")
                .foregroundColor(.secondary)
                .font(.caption2)

        }
    }
}

struct ExerciseChartView: View {
    var exercises: [Exercise]
    
    var body: some View {
        // Show only 7 recent exercises (graph looks funny with 100s of plots)
        Chart(exercises.prefix(7)) { exercise in
            LineMark(x: .value("Time", exercise.date ?? Date()),
                     y: .value("Beats Per Minute", Float(exercise.weight)!))
            .symbol(Circle().strokeBorder(lineWidth: 2))
            .symbolSize(CGSize(width: 6, height: 6))
        }
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
        .chartYScale(domain: .automatic(includesZero: false))
        .padding(.vertical, 8)
    }
}
    

struct ExerciseProgressCellView_Previews: PreviewProvider {
    static let sampleData = [
        Exercise(name: "Bench Press", sets: "5", reps: "5", weight: "45", date: Date()),
        Exercise(name: "Bench Press", sets: "5", reps: "5", weight: "55", date: Date().addingTimeInterval(oneWeek)),
        Exercise(name: "Bench Press", sets: "5", reps: "5", weight: "50", date: Date().addingTimeInterval(oneWeek * 2)),
        Exercise(name: "Bench Press", sets: "5", reps: "5", weight: "65", date: Date().addingTimeInterval(oneWeek * 3)),
        Exercise(name: "Bench Press", sets: "5", reps: "5", weight: "60", date: Date().addingTimeInterval(oneWeek * 4)),
    ]
    
    static var previews: some View {
        List {
            ExerciseProgressCellView(data: sampleData)
        }
    }
}
