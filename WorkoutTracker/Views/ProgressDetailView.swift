//
//  ProgressDetailView.swift
//  WorkoutTracker
//
//  Created by Timmy Nguyen on 8/8/23.
//

import SwiftUI
import Charts

enum SelectedFilter: String, CaseIterable, Identifiable {
    case all = "all"
    case week
    case month
    case sixMonth = "6M"
    case year
    var id: Self { self }
}

struct ProgressDetailView: View {
    @ObservedObject var data: ProgressData
    @State private var selectedFilter: SelectedFilter = .all
    @State private var animate = false

    var filteredData: [Exercise] {
        switch selectedFilter {
        case .all:
            return data.data
        case .week:
            let oneWeekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
            return data.data.filter { $0.date! >= oneWeekAgo }
        case .month:
            let oneMonthAgo = Calendar.current.date(byAdding: .month, value: -1, to: Date())!
            return data.data.filter { $0.date! >= oneMonthAgo }
        case .sixMonth:
            let sixMonthsAgo = Calendar.current.date(byAdding: .month, value: -6, to: Date())!
            return data.data.filter { $0.date! >= sixMonthsAgo }
        case .year:
            let oneYearAgo = Calendar.current.date(byAdding: .year, value: -1, to: Date())!
            return data.data.filter { $0.date! >= oneYearAgo }
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Picker("Time", selection: $selectedFilter) {
                    ForEach(SelectedFilter.allCases) { time in
                        Text(time.rawValue.capitalized)
                    }
                }
                .pickerStyle(.segmented)
                
                
                Text("Personal Record".uppercased())
                    .foregroundColor(.secondary)
                    .font(.subheadline)
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text("\(filteredData.max { $0.weight < $1.weight }?.weight ?? "0")")
                        .font(.title)
                    Text("lbs")
                        .foregroundColor(.secondary)
                }
                
                Text("\(formatDate(filteredData.last?.date ?? Date())) - \(formatDate(filteredData.first?.date ?? Date()))")
                    .foregroundColor(.secondary)
                    .font(.subheadline)
                
                Chart(filteredData) { exercise in
                    LineMark(x: .value("Time", exercise.date ?? Date()),
                             y: .value("Beats Per Minute", Float(exercise.weight)!))
                    .symbol(Circle().strokeBorder(lineWidth: 2))
                    .symbolSize(CGSize(width: 6, height: 6))
        //            .foregroundStyle(.pink)
                }
                .chartYScale(domain: .automatic(includesZero: false))
                .frame(height: 300)
                
                Divider()
                    .padding(.vertical, 4)
                
                HStack {
                    Text("History".uppercased())
                    
                    Spacer()
                    
                    Text("\(filteredData.count) Workouts".uppercased())
                }
                .foregroundColor(.secondary)
                .font(.subheadline)
                
                ForEach(Array(filteredData.enumerated()), id: \.offset) { i, exercise in
                    
                    Divider()
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(exercise.weight) lbs")
                                .font(.headline)
                            
                            //"60lbs 3x5 Sep 20, 2023"
                            Text("\(filteredData[i].sets)x\(filteredData[i].reps) \(filteredData[i].name) at \(formatDate(filteredData[i].date!))")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        
                        // last element case
                        if i == filteredData.count - 1 {
                            Text("-")
                                .foregroundColor(.secondary)
                        } else {
                            let weight = Float(filteredData[i].weight)!
                            let previousWeight = Float(filteredData[i + 1].weight)!
                            let difference = weight - previousWeight
                            if difference > 0 {
                                // More weight
                                Text("+\(formatFloat(difference)) lbs")
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 2)
//                                    .frame(width: 70, height: 25)
                                    .overlay(Color.green.opacity(0.15))
                                    .clipShape(RoundedRectangle(cornerRadius: 4))
                            } else if difference < 0 {
                                // Less weight
                                Text("\(formatFloat(difference)) lbs")
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 2)
                                    .overlay(Color.red.opacity(0.15))
                                    .clipShape(RoundedRectangle(cornerRadius: 4))
                            } else {
                                // No weight gain
                                Text("-")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding(8)
                }
            }
            .padding()
            .animation(.default, value: filteredData.count) // animation trigger when value changes

        }
    }
    
    func formatFloat(_ floatValue: Float) -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2 // You can adjust this as needed
        
        return formatter.string(from: NSNumber(value: floatValue)) ?? "\(floatValue)"
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }
}

//Calendar.current.date(byAdding: .weekOfYear, value: 1, to: Date())
struct ProgressDetailView_Previews: PreviewProvider {
    static let sampleData = ProgressData(
        name: "Squat",
        data: [
            Exercise(name: "Squat", sets: "3", reps: "5", weight: "45", date: Date()),
            Exercise(name: "Squat", sets: "3", reps: "5", weight: "65", date: Calendar.current.date(byAdding: .weekOfYear, value: 1, to: Date())),
            Exercise(name: "Squat", sets: "3", reps: "5", weight: "50", date: Calendar.current.date(byAdding: .weekOfYear, value: 2, to: Date())),
            Exercise(name: "Squat", sets: "3", reps: "5", weight: "55", date: Calendar.current.date(byAdding: .weekOfYear, value: 3, to: Date())),
            Exercise(name: "Squat", sets: "3", reps: "5", weight: "60", date: Calendar.current.date(byAdding: .weekOfYear, value: 4, to: Date())),
            Exercise(name: "Squat", sets: "3", reps: "5", weight: "60", date: Calendar.current.date(byAdding: .weekOfYear, value: 5, to: Date())),
            Exercise(name: "Squat", sets: "3", reps: "5", weight: "65", date: Calendar.current.date(byAdding: .weekOfYear, value: 6, to: Date()))
        ].reversed()
    )
    
    static var previews: some View {
        ProgressDetailView(data: sampleData)
    }
}
