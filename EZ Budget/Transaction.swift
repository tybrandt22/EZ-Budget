//
//  Transaction.swift
//  Budget Tracker
//
//  Created by Tyler Brandt on 3/19/21.
//

import UIKit

class Transaction: NSObject, NSCoding {
    var name: String
    var category: String
    var price: Double
    var date: String
    var desc: String
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("transactions")
    
    struct PropertyKey {
        static let name = "name"
        static let category = "category"
        static let price = "price"
        static let date = "date"
        static let desc = "desc"
    }
    
    init?(name: String, category: String, price: Double, date: String, desc: String) {
        self.name = name
        self.category = category
        self.price = price
        self.date = date
        self.desc = desc
    }
    
    init?(name: String) {
        self.name = name
        self.category = ""
        self.price = -1.0
        self.date = ""
        self.desc = "No Description"
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: PropertyKey.name)
        coder.encode(category, forKey: PropertyKey.category)
        coder.encode(price, forKey: PropertyKey.price)
        coder.encode(date, forKey: PropertyKey.date)
        coder.encode(desc, forKey: PropertyKey.desc)
    }
    
    required convenience init?(coder: NSCoder) {
        guard let name = coder.decodeObject(forKey: PropertyKey.name) as? String else {return nil}
        guard let category = coder.decodeObject(forKey: PropertyKey.category) as? String else {return nil}
        let price = coder.decodeDouble(forKey: PropertyKey.price)
        guard let date = coder.decodeObject(forKey: PropertyKey.date) as? String else {return nil}
        guard let desc = coder.decodeObject(forKey: PropertyKey.desc) as? String else {return nil}
        self.init(name: name, category: category, price: price, date: date, desc: desc)
    }
    
}
