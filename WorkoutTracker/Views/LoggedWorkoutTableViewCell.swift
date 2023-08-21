//
//  LoggedWorkoutTableViewCell.swift
//  WorkoutTracker
//
//  Created by Timmy Nguyen on 8/5/23.
//

import UIKit

class LoggedWorkoutTableViewCell: UITableViewCell {

    @IBOutlet var weekdayLabel: UILabel!
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var workoutLabel: UILabel!
    @IBOutlet var exercisesLabel: UILabel!
    @IBOutlet var barView: UIView!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(with workout: Workout) {
        weekdayLabel.text = workout.dayOfWeek
        dayLabel.text = "\(Calendar.current.component(.day, from: workout.startTime!))"
        workoutLabel.text = workout.name
        exercisesLabel.text = workout.exercises
            .map { "\($0.sets)x\($0.reps) \($0.name) - \($0.getWeightString(includeUnits: true))" }.joined(separator: "\n")
        barView.isHidden = !Calendar.current.isDate(workout.startTime!, inSameDayAs: Date())
        barView.backgroundColor = Settings.shared.accentColor.color
    }
}
