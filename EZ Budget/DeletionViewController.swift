//
//  DeletionViewController.swift
//  Budget Tracker
//
//  Created by Tyler Brandt on 4/1/21.
//

import UIKit

class DeletionViewController: UIViewController {
    var confirmed = false
    var categorical = false
    var transactional = false
    var itemTitle = "No Category"
    var warningText = "WARNING: This will delete all transactions. Proceed?"
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var messageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var confirmButtonTop: NSLayoutConstraint!
    @IBOutlet weak var cancelButtonTop: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isModalInPresentation = true
        warningLabel.text = warningText
        if warningText.contains("category") {
            messageViewHeight.constant += 10
            confirmButtonTop.constant += 20
            cancelButtonTop.constant += 20
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let button = sender as? UIButton, button === confirmButton else {return}
        confirmed = true
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
