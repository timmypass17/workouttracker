//
//  WorkoutTitleTableViewCell.swift
//  WorkoutTracker
//
//  Created by Timmy Nguyen on 7/29/23.
//

import UIKit

protocol WorkoutTitleTableViewCellDelegate: AnyObject {
    func workoutTitleTableViewCell(_ cell: WorkoutTitleTableViewCell, didUpdateTitle title: String)
}


class WorkoutTitleTableViewCell: UITableViewCell {

    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var letterImageView: UIImageView!
    
    weak var delegate: WorkoutTitleTableViewCellDelegate?

    var toolbar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(
            title: "Done",
            style: .plain,
            target: self,
            action: #selector(doneButtonTapped)
        )
        
        toolbar.items = [.flexibleSpace(), doneButton]
        return toolbar
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleTextField.inputAccessoryView = toolbar
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func titleEditingChanged(_ sender: Any) {
        updateIcon()
        delegate?.workoutTitleTableViewCell(self, didUpdateTitle: titleTextField.text ?? "")
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

    
    @objc func doneButtonTapped(){
        titleTextField.resignFirstResponder()
    }

}
