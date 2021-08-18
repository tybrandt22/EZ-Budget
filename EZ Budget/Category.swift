//
//  Category.swift
//  Budget Tracker
//
//  Created by Tyler Brandt on 3/11/21.
//

import UIKit

class Category: NSObject, NSCoding {
    var name: String
    var price: Double
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("categories")
    
    struct PropertyKey {
        static let name = "name"
        static let price = "price"
    }
    
    init?(name: String, price: Double) {
        guard !name.isEmpty else {return nil}
        guard price > 0 else {return nil}
        self.name = name
        self.price = price
    }
    
    func addToTotal(price: Double) {
        self.price += price
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: PropertyKey.name)
        coder.encode(price, forKey: PropertyKey.price)
    }
    
    required convenience init?(coder: NSCoder) {
        guard let name = coder.decodeObject(forKey: PropertyKey.name) as? String else {return nil}
        let price = coder.decodeDouble(forKey: PropertyKey.price)
        self.init(name: name, price: price)
    }
    
}
