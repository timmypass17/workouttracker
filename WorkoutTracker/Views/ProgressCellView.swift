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
                ExerciseTitleView(title: data.first!.name, time: Date())
                HighestWeightView(
                    highestWeight: data.max { $0.weight < $1.weight }?.weight ?? "0",
                    recentExercise: data.max(by: { $0.date! < $1.date! })!
                )
            }
            
            Spacer(minLength: 20)
            ExerciseChartView(exercises: data)
                .padding(8)
        }
        .frame(height: 90)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        return formatter.string(from: date)
    }
}

struct ExerciseTitleView: View {
    var title: String
    var time: Date
    
    var body: some View {
        HStack {
            Image(systemName: "dumbbell.fill")
                .foregroundColor(.accentColor)
            Text(title)
        }
        .font(.system(.headline, weight: .bold))
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        return formatter.string(from: date)
    }
}

struct HighestWeightView: View {
    var highestWeight: String
    var recentExercise: Exercise
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Best: \(highestWeight) lbs")
                .font(.subheadline)
                .padding(.horizontal, 8)
                .padding(.vertical, 2)
                .overlay(Color.secondary.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 4))
            
            HStack(alignment: .firstTextBaseline) {
                Text("Latest: \(recentExercise.weight) lbs")
                    .foregroundColor(.secondary)
                    .font(.caption)
            }
            
            Text("Updated: \(formatDate(recentExercise.date!))")
                .foregroundColor(.secondary)
                .font(.caption2)

        }
    }
    
    func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.string(from: date)
    }
}

struct ExerciseChartView: View {
    var exercises: [Exercise]
    
    var body: some View {
        Chart(exercises) { exercise in
            LineMark(x: .value("Time", exercise.date ?? Date()),
                     y: .value("Beats Per Minute", Float(exercise.weight)!))
            .symbol(Circle().strokeBorder(lineWidth: 2))
            .symbolSize(CGSize(width: 6, height: 6))
//            .foregroundStyle(.pink)
        }
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
        .chartYScale(domain: .automatic(includesZero: false))
        .padding(.vertical, 8)
    }
}
    

let oneWeek: TimeInterval = 7 * 24 * 60 * 60
struct ExerciseProgressCellView_Previews: PreviewProvider {
    static let sampleData = [
        Exercise(name: "Bench Press", sets: "5", reps: "5", weight: "45", date: Date()),
        Exercise(name: "Bench Press", sets: "5", reps: "5", weight: "55", date: Date().addingTimeInterval(oneWeek)),
        Exercise(name: "Bench Press", sets: "5", reps: "5", weight: "50", date: Date().addingTimeInterval(oneWeek * 2)),
        Exercise(name: "Bench Press", sets: "5", reps: "5", weight: "65", date: Date().addingTimeInterval(oneWeek * 3)),
        Exercise(name: "Bench Press", sets: "5", reps: "5", weight: "60", date: Date().addingTimeInterval(oneWeek * 4))
    ]
    
    static var previews: some View {
        List {
            ExerciseProgressCellView(data: sampleData)
        }
    }
}
