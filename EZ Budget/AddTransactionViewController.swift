//
//  AddTransactionViewController.swift
//  Budget Tracker
//
//  Created by Tyler Brandt on 2/25/21.
//

import UIKit

class AddTransactionViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var costTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    var doneButton: UIBarButtonItem!
    var categories = [Category]()
    var transactions = [Transaction]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isModalInPresentation = true
        addButton.isEnabled = false
        categoryTextField.delegate = self
        nameTextField.delegate = self
        costTextField.delegate = self
        descriptionTextField.delegate = self
        addDoneButtonToKeyboard(myAction: #selector(costTextField.resignFirstResponder))
        NotificationCenter.default.addObserver(self,
                    selector: #selector(AddTransactionViewController.keyboardWillShow),
                    name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                    selector: #selector(AddTransactionViewController.keyboardWillHide),
                    name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        addButton.isEnabled = false
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let text = costTextField.text ?? ""
        if text.isEmpty {
            doneButton.isEnabled = false
        } else {
            doneButton.isEnabled = true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateAddButtonStatus()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        categoryTextField.resignFirstResponder()
        nameTextField.resignFirstResponder()
        descriptionTextField.resignFirstResponder()
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let button = sender as? UIBarButtonItem, button === addButton else {return}
        let price = Double(costTextField.text ?? "0.0")
        let dateObject = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy h:mm a z"
        let date = dateFormatter.string(from: dateObject)
        var desc = descriptionTextField.text ?? "No Description"
        if desc.isEmpty {
            desc = "No Description"
        }
        let transaction = Transaction(name: nameTextField.text ?? "", category: categoryTextField.text ?? "",
                                      price: price ?? 0.0, date: date, desc: desc)
        transactions.insert(transaction!, at: 0)
        for category in categories {
            if categoryTextField.text == category.name {
                category.addToTotal(price: price ?? 0.0)
                return
            }
        }
        let category = Category(name: categoryTextField.text ?? "", price: price ?? 0.0)
        var i = 0
        for categoryI in categories {
            if categoryI.name > categoryTextField.text! {
                categories.insert(category!, at: i)
                return
            }
            i += 1
        }
        categories.append(category!)
    }
    
    private func updateAddButtonStatus() {
        var text = categoryTextField.text ?? ""
        if text.isEmpty {
            addButton.isEnabled = false
            return
        }
        text = nameTextField.text ?? ""
        if text.isEmpty {
            addButton.isEnabled = false
            return
        }
        text = costTextField.text ?? ""
        if text.isEmpty {
            addButton.isEnabled = false
            return
        }
        if Double(text) == 0.0 {
            addButton.isEnabled = false
            return
        }
        addButton.isEnabled = true
    }
    
    private func addDoneButtonToKeyboard(myAction:Selector?){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
        doneToolbar.barStyle = UIBarStyle.default
        let flexSpace = UIBarButtonItem(barButtonSystemItem:
                                        UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        doneButton = UIBarButtonItem(
            title: "Done", style: UIBarButtonItem.Style.done, target: costTextField, action: myAction)
        doneButton.isEnabled = false
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(doneButton)
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        costTextField.inputAccessoryView = doneToolbar
     }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue
        if costTextField.isEditing && costTextField.frame.origin.y + costTextField.frame.height
            > self.view.frame.height - keyboardFrame.height {
            self.view.frame.origin.y = -costTextField.frame.origin.y - costTextField.frame.height
                                            + self.view.frame.height - keyboardFrame.height - 20
        } else if descriptionTextField.isEditing && descriptionTextField.frame.origin.y
                    + descriptionTextField.frame.height > self.view.frame.height - keyboardFrame.height {
            self.view.frame.origin.y = -descriptionTextField.frame.origin.y - descriptionTextField.frame.height
                                            + self.view.frame.height - keyboardFrame.height - 20
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
}
