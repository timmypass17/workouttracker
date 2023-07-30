//
//  WorkoutTableViewCell.swift
//  WorkoutTracker
//
//  Created by Timmy Nguyen on 7/26/23.
//

import UIKit

class WorkoutTableViewCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var iconImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func update(with workout: Workout) {
        nameLabel.text = workout.name
        var descriptionLabelText = ""
//        for (index, exercise) in workout.exercises.enumerated() {
//            descriptionLabelText += "\(exercise.sets.count)x\(exercise.sets[index].reps) \(exercise.name)\n"
//        }
        descriptionLabel.text = descriptionLabelText
        iconImage.image = workout.icon
    }
}
