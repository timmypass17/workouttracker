//
//  SettingsTableViewController.swift
//  WorkoutTracker
//
//  Created by Timmy Nguyen on 8/16/23.
//

import UIKit

class SettingsTableViewController: UITableViewController, WeightUnitTableViewControllerDelegate, ThemeTableViewControllerDelegate {
    
    @IBOutlet var weightTypeLabel: UILabel!
    @IBOutlet var themeLabel: UILabel!
    
    enum Section: Int, CaseIterable {
        case units
        case appearance
        case help
        case legal
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: Load weight type from user defaults
        
        updateView()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionCase = Section(rawValue: section) else { return 0 }
        
        switch sectionCase {
        case .units:
            return 1
        case .appearance, .help, .legal:
            return 2
        }
    }
    
    @IBSegueAction func showWeightUnit(_ coder: NSCoder, sender: Any?) -> WeightUnitTableViewController? {
        let weightUnitTableViewController = WeightUnitTableViewController(coder: coder)
        weightUnitTableViewController?.delegate = self
        return weightUnitTableViewController
    }
    
    @IBSegueAction func showTheme(_ coder: NSCoder, sender: Any?) -> ThemeTableViewController? {
        let themeTableViewController = ThemeTableViewController(coder: coder)
        themeTableViewController?.delegate = self
        return themeTableViewController
    }
    
    func updateView() {
        weightTypeLabel.text = Settings.shared.weightUnit.name
        themeLabel.text = Settings.shared.theme.name
    }
    
    func weightUnitTableViewController(_ controller: WeightUnitTableViewController, didSelect weightType: WeightType) {
        updateView()
    }
    
    func themeTableViewController(_ controller: ThemeTableViewController, didSelect themeType: Theme) {
        updateView()
    }
}
