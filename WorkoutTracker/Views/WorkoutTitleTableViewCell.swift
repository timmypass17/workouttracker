//
//  WorkoutTitleTableViewCell.swift
//  WorkoutTracker
//
//  Created by Timmy Nguyen on 7/29/23.
//

import UIKit

class WorkoutTitleTableViewCell: UITableViewCell {

    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var letterImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func titleEditingChanged(_ sender: Any) {
        updateIcon()
    }
    
    func update(with workout: Workout) {
        titleTextField.text = workout.name
        letterImageView.image = UIImage(systemName: "\(workout.name.first?.lowercased() ?? "b").circle.fill")
        selectionStyle = .none
    }
    
    func updateIcon() {
        if let title = titleTextField.text,
           let inital = title.first?.lowercased() {
            // Update icon
            letterImageView.image = UIImage(systemName: "\(inital).circle.fill")
        } else {
            letterImageView.image = UIImage(systemName: "p.circle.fill")
        }
    }

}
