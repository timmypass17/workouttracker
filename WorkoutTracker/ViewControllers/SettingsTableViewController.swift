//
//  SettingsTableViewController.swift
//  WorkoutTracker
//
//  Created by Timmy Nguyen on 8/16/23.
//

import UIKit
import SafariServices
import MessageUI

class SettingsTableViewController: UITableViewController, WeightUnitTableViewControllerDelegate, ThemeTableViewControllerDelegate, MFMailComposeViewControllerDelegate {
    
    @IBOutlet var weightTypeLabel: UILabel!
    @IBOutlet var themeLabel: UILabel!
    
    let contactUsIndexPath = IndexPath(row: 0, section: 2)
    let bugReportIndexPath = IndexPath(row: 1, section: 2)

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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath == contactUsIndexPath {
            guard MFMailComposeViewController.canSendMail() else {
                // Disable button or show error message
                print("Can not send mail")
                return
            }
            
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            mailComposer.setToRecipients(["timmypass17@gmail.com"]) // change to support email
            mailComposer.setSubject("Contact Us")
            
            present(mailComposer, animated: true)
        } else if indexPath == bugReportIndexPath {
            guard MFMailComposeViewController.canSendMail() else {
                return
            }
            
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            
            mailComposer.setToRecipients(["timmypass17@gmail.com"]) // change to support email
            mailComposer.setSubject("Bug Report")
            
            present(mailComposer, animated: true)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true)
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }
}
