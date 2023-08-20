//
//  WeightUnitTableViewController.swift
//  WorkoutTracker
//
//  Created by Timmy Nguyen on 8/16/23.
//

import UIKit

protocol WeightUnitTableViewControllerDelegate: AnyObject {
    func weightUnitTableViewController(_ controller: WeightUnitTableViewController, didSelect weightType: WeightType)
}

class WeightUnitTableViewController: UITableViewController {

    weak var delegate: WeightUnitTableViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WeightType.allCases.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeightTypeCell", for: indexPath)
        let weightType = WeightType.allCases[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = weightType.name
        cell.contentConfiguration = content
        
        if weightType == Settings.shared.weightUnit {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let weightType = WeightType.allCases[indexPath.row]
        Settings.shared.weightUnit = weightType
        delegate?.weightUnitTableViewController(self, didSelect: weightType) // pass parameters to Settings...
        NotificationCenter.default.post(name: WeightType.weightUnitUpdatedNotification, object: nil)
        tableView.reloadData()
    }
}
