//
//  ExerciseTableViewCell.swift
//  WorkoutTracker
//
//  Created by Timmy Nguyen on 7/29/23.
//

import UIKit

protocol ExerciseTableViewCellDelegate: AnyObject {
    func exerciseCell(_ cell: ExerciseTableViewCell, didUpdateExercise exercise: Exercise)
    
    func checkmarkTapped(sender: ExerciseTableViewCell)
}

class ExerciseTableViewCell: UITableViewCell {

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var setsTextField: UITextField!
    @IBOutlet var repsTextField: UITextField!
    @IBOutlet var weightTextField: UITextField!
    @IBOutlet var isCompleteButton: UIButton!
    
    weak var delegate: ExerciseTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func textEditingChanged(_ sender: Any) {
        // Update the exercise with the new values
        let name = nameTextField.text ?? ""
        let sets = setsTextField.text ?? ""
        let reps = repsTextField.text ?? ""
        let weight = weightTextField.text ?? ""
        let isComplete = isCompleteButton.isSelected
        var exercise = Exercise(name: name, sets: sets, reps: reps, weight: "", isComplete: isComplete)
        exercise.setWeight(weight: weight)
        
        // Notify the delegate that the exercise was updated
        delegate?.exerciseCell(self, didUpdateExercise: exercise)
    }
    
    @IBAction func completeButtonTapped(_ sender: UIButton) {
        delegate?.checkmarkTapped(sender: self)
    }
    
    func update(with exercise: Exercise) {
        nameTextField.text = exercise.name
        setsTextField.text = "\(exercise.sets)"
        repsTextField.text = "\(exercise.reps)"
        weightTextField.text = "\(exercise.getWeightString())"
        selectionStyle = .none
        showsReorderControl = true
        
        isCompleteButton.isEnabled = !exercise.isEditing  // Enable or disable the button based on the isEditing property
    }

}
