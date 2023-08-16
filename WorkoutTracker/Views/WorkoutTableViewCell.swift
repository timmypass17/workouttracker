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
//        descriptionLabel.text = workout.exercises
//            .map { "\($0.sets)x\($0.reps) \($0.name) - \($0.weight)lbs" }.joined(separator: "\n")
        descriptionLabel.text = workout.exercises.map { $0.name }.joined(separator: ", ")
//        descriptionLabel.text = workout.exercises.map { "\($0.sets)x\($0.reps) \($0.name)" }.joined(separator: "\n")
        iconImage.image = workout.icon
    }
}
