//
//  TransactionViewController.swift
//  Budget Tracker
//
//  Created by Tyler Brandt on 8/18/21.
//

import UIKit

class TransactionViewController: UIViewController {
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    var transaction = Transaction(name: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        costLabel.text = String(format: "Cost:\t\t\t$%.2f", transaction!.price)
        dateLabel.text = "Date:\t\t\t" + transaction!.date
        categoryLabel.text = "Category:\t" + transaction!.category
        descriptionLabel.text = "Description:\t" + transaction!.desc
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
        case "deleteTransaction":
            guard let deleteView = segue.destination as? DeletionViewController else {return}
            deleteView.warningText = "WARNING: This will delete the transaction. Proceed?"
            deleteView.transactional = true
            deleteView.itemTitle = transaction!.name
        default:
            return
        }
    }

}
