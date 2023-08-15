//
//  ProgressDetailView.swift
//  WorkoutTracker
//
//  Created by Timmy Nguyen on 8/8/23.
//

import SwiftUI
import Charts

enum TimeRange: String, CaseIterable, Identifiable {
    case all = "all"
    case week
    case month
    case sixMonth = "6M"
    case year
    var id: Self { self }
}

struct ProgressDetailView: View {
    @ObservedObject var data: ProgressData
    @State private var selectedTimeRange: TimeRange = .all
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Picker("Time", selection: $selectedTimeRange) {
                    ForEach(TimeRange.allCases) { time in
                        Text(time.rawValue.capitalized)
                    }
                }
                .pickerStyle(.segmented)
                
                
                Text("Personal Record".uppercased())
                    .foregroundColor(.secondary)
                    .font(.subheadline)
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text("\(data.data.max { $0.weight < $1.weight }?.weight ?? "0")")
                        .font(.title)
                    Text("lbs")
                        .foregroundColor(.secondary)
                }
                
                Text("\(formatDate(data.data.first?.date ?? Date())) - \(formatDate(data.data.last?.date ?? Date()))")
                    .foregroundColor(.secondary)
                    .font(.subheadline)
                
                Chart(data.data) { exercise in
                    LineMark(x: .value("Time", exercise.date ?? Date()),
                             y: .value("Beats Per Minute", Int(exercise.weight)!))
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
                    
                    Text("\(data.data.count) Workouts".uppercased())
                }
                .foregroundColor(.secondary)
                .font(.subheadline)
                
                ForEach(data.data.indices) { i in
                    
                    Divider()
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(data.data[i].weight) lbs")
                                .font(.headline)
                            
                            //"60lbs 3x5 Sep 20, 2023"
                            Text("\(data.data[i].sets)x\(data.data[i].reps) \(data.data[i].name) at \(formatDate(data.data[i].date!))")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        
                        // last element case
                        if i == data.data.count - 1 {
                            Text("-")
                                .foregroundColor(.secondary)
                        } else {
                            let weight = Int(data.data[i].weight)!
                            let previousWeight = Int(data.data[i + 1].weight)!
                            let difference = weight - previousWeight
                            if difference > 0 {
                                // More weight
                                Text("+\(difference) lbs")
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 2)
                                    .overlay(Color.green.opacity(0.15))
                                    .clipShape(RoundedRectangle(cornerRadius: 4))
                            } else if difference < 0 {
                                // Less weight
                                Text("\(difference) lbs")
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
        }
        .onAppear {
            print(data.data.map { formatDate($0.date!) } )
        }
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
