//
//  CategoryTableViewController.swift
//  Budget Tracker
//
//  Created by Tyler Brandt on 7/10/21.
//

import UIKit

class CategoryTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var transactions = [Transaction]()
    var total = "Category Total: $0.00"
    @IBOutlet weak var categoryTransactionsTable: UITableView!
    @IBOutlet weak var totalLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryTransactionsTable.delegate = self
        categoryTransactionsTable.dataSource = self
        totalLabel.text = total
    }
    
    func numberOfSections(in categoryTable: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ categoryTable: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ categoryTable: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CategoryTransactionsCell"
        guard let cell = self.categoryTransactionsTable.dequeueReusableCell(withIdentifier: cellIdentifier,
                        for: indexPath) as? TransactionTableViewCell else {
            fatalError()
        }
        let transaction = transactions[indexPath.row]
        cell.name.text = transaction.name
        cell.category.text = transaction.category
        cell.price.text = String(format: "$%.2f", transaction.price)
        cell.date.text = transaction.date
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch (segue.identifier ?? "") {
        case "deleteCatConfirmation":
            guard let deleteView = segue.destination as? DeletionViewController else {return}
            deleteView.warningText = "WARNING: This will delete the category and all transactions within it. Proceed?"
            deleteView.categorical = true
            deleteView.itemTitle = title!
        case "viewCategoryTransaction":
            guard let transactionView = segue.destination as? TransactionViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let selectedTransactionCell = sender as? TransactionTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            guard let indexPath = categoryTransactionsTable.indexPath(for: selectedTransactionCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            let selectedTransaction = transactions[indexPath.row]
            transactionView.title = selectedTransaction.name
            transactionView.transaction = selectedTransaction
        default:
            return
        }
    }

}
