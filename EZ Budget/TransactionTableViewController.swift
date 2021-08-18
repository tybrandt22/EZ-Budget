//
//  TransactionTableViewController.swift
//  Budget Tracker
//
//  Created by Tyler Brandt on 3/19/21.
//

import UIKit

class TransactionTableViewController: UITableViewController {
    var transactions = [Transaction]()
    var categories = [Category]()
    var deletedTransaction = false

    override func viewDidLoad() {
        super.viewDidLoad()
        if transactions.isEmpty {
            let transaction = Transaction(name: "No Transactions")
            transactions.append(transaction!)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "allTransactions"
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as?
                TransactionTableViewCell else {
            fatalError()
        }
        let transaction = transactions[indexPath.row]
        cell.name.text = transaction.name
        cell.category.text = transaction.category
        if transaction.price < 0 {
            cell.price.text = ""
        } else {
            cell.price.text = String(format: "$%.2f", transaction.price)
        }
        cell.date.text = transaction.date
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch (segue.identifier ?? "") {
        case "viewTransaction":
            guard let transactionView = segue.destination as? TransactionViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let selectedTransactionCell = sender as? TransactionTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            guard let indexPath = tableView.indexPath(for: selectedTransactionCell) else {
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
