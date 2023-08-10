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
        VStack(alignment: .leading) {
            ExerciseTitleView(title: data.first!.name, time: Date())
            HStack(alignment: .bottom) {
                HighestWeightView(weight: data.max { $0.weight < $1.weight }?.weight ?? "0")
                Spacer(minLength: 60)
                ExerciseChartView(exercises: data)
            }
        }
        .padding(.vertical, 8)
        .frame(height: 60)
    }
}

struct ExerciseTitleView: View {
    var title: String
    var time: Date
    
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Label(title, systemImage: "dumbbell.fill")
//                .foregroundStyle(.pink)
                .font(.system(.subheadline, weight: .bold))
                .layoutPriority(1)
            Spacer()
            Text(formatDate(time))
                .foregroundStyle(.secondary)
                .font(.footnote)
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        return formatter.string(from: date)
    }
}

struct HighestWeightView: View {
    var weight: String
    
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(weight)
                .foregroundStyle(.primary)
                .font(.system(.title2, weight: .semibold))
            Text("LBS")
                .foregroundStyle(.secondary)
                .font(.system(.subheadline, weight: .bold))
        }
    }
}

struct ExerciseChartView: View {
    var exercises: [Exercise]
    
    var body: some View {
        Chart(exercises) { exercise in
            LineMark(x: .value("Time", exercise.date ?? Date()),
                     y: .value("Beats Per Minute", Int(exercise.weight)!))
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
