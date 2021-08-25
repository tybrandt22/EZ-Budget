//
//  CategoryViewController.swift
//  Budget Tracker
//
//  Created by Tyler Brandt on 2/25/21.
//

import UIKit

class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var categories = [Category]()
    var transactions = [Transaction]()
    @IBOutlet weak var categoryTable: UITableView!
    @IBOutlet weak var totalLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let savedCategories = loadCategories() {
            categories += savedCategories
            var total = 0.0
            for category in categories {
                total += category.price
            }
            totalLabel.text = String(format: "Total: $%.2f", total)
        }
        if let savedTransactions = loadTransactions() {
            transactions += savedTransactions
        }
        categoryTable.delegate = self
        categoryTable.dataSource = self
    }
    
    @IBAction func addTransaction(_ sender: UIButton) {
        performSegue(withIdentifier: "addTransaction", sender: self)
    }
    
    @IBAction func viewTransactions(_ sender: UIButton) {
        performSegue(withIdentifier: "showTransactions", sender: self)
    }
    
    @IBAction func confirmDelete(_ sender: UIButton) {
        performSegue(withIdentifier: "confirmDelete", sender: self)
    }
    
    @IBAction func displayData(sender: UIStoryboardSegue) {
        if let sourceView = sender.source as? AddTransactionViewController {
            categories = sourceView.categories
            transactions = sourceView.transactions
            saveData()
            categoryTable.reloadData()
            var total = 0.0
            for category in categories {
                total += category.price
            }
            totalLabel.text = String(format: "Total: $%.2f", total)
        }
    }
    
    @IBAction func deleteData(sender: UIStoryboardSegue) {
        if let sourceView = sender.source as? DeletionViewController {
            if sourceView.confirmed && !sourceView.categorical && !sourceView.transactional {
                categories = [Category]()
                transactions = [Transaction]()
                saveData()
                categoryTable.reloadData()
                totalLabel.text = "Total: $0.00"
            } else if sourceView.confirmed && !sourceView.transactional {
                var i = 0
                for transaction in transactions {
                    if transaction.category == sourceView.itemTitle {
                        transactions.remove(at: i)
                        i -= 1
                    }
                    i += 1
                }
                i = 0
                for category in categories {
                    if category.name == sourceView.itemTitle {
                        categories.remove(at: i)
                        break
                    }
                    i += 1
                }
                saveData()
                categoryTable.reloadData()
                var total = 0.0
                for category in categories {
                    total += category.price
                }
                totalLabel.text = String(format: "Total: $%.2f", total)
            } else if sourceView.confirmed {
                var i = 0
                for transaction in transactions {
                    if transaction.name == sourceView.itemTitle {
                        for category in categories {
                            if category.name == sourceView.tranCategory {
                                category.price -= transaction.price
                            }
                        }
                        transactions.remove(at: i)
                        break
                    }
                    i += 1
                }
                saveData()
                categoryTable.reloadData()
                var total = 0.0
                for category in categories {
                    total += category.price
                }
                totalLabel.text = String(format: "Total: $%.2f", total)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch (segue.identifier ?? "") {
        case "addTransaction":
            guard let addViewNav = segue.destination as? UINavigationController else {return}
            guard let addView = addViewNav.viewControllers.first as? AddTransactionViewController else {return}
            addView.categories = categories
            addView.transactions = transactions
        case "showTransactions":
            guard let showView = segue.destination as? TransactionTableViewController else {return}
            showView.transactions = transactions
            showView.categories = categories
        case "showCategory":
            guard let categoryTransactionTableViewController = segue.destination
                    as? CategoryTableViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let selectedCategoryCell = sender as? CategoryTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            guard let indexPath = categoryTable.indexPath(for: selectedCategoryCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            let selectedCategory = categories[indexPath.row]
            categoryTransactionTableViewController.title = selectedCategory.name
            var total = 0.0
            for transaction in transactions {
                if transaction.category == selectedCategory.name {
                    categoryTransactionTableViewController.transactions.append(transaction)
                    total += transaction.price
                }
            }
            categoryTransactionTableViewController.total = String(format: "Category Total: $%.2f", total)
        default:
            return
        }
    }
    
    func numberOfSections(in categoryTable: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ categoryTable: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ categoryTable: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CategoryTableViewCell"
        guard let cell = self.categoryTable.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as?
                CategoryTableViewCell else {
            fatalError()
        }
        let category = categories[indexPath.row]
        cell.name.text = category.name
        cell.price.text = String(format: "$%.2f", category.price)
        return cell
    }
 
    private func saveData() {
        do {
            let transactionData = try NSKeyedArchiver.archivedData(withRootObject: transactions,
                                                                   requiringSecureCoding: false)
            try transactionData.write(to: Transaction.ArchiveURL)
            let categoryData = try NSKeyedArchiver.archivedData(withRootObject: categories,
                                                        requiringSecureCoding: false)
            try categoryData.write(to: Category.ArchiveURL)
        } catch {
            print("failed with error: \(error)")
        }
    }
    
    private func loadCategories() -> [Category]? {
        do {
            return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(
                Data(contentsOf: Category.ArchiveURL)) as? [Category]
        } catch {
            print("failed with error: \(error)")
            return nil
        }
    }
    
    private func loadTransactions() -> [Transaction]? {
        do {
            return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(Data(contentsOf: Transaction.ArchiveURL))
                as? [Transaction]
        } catch {
            print("failed with error: \(error)")
            return nil
        }
    }
    
}
