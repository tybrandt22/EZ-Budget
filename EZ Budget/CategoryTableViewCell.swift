//
//  CategoryTableViewCell.swift
//  Budget Tracker
//
//  Created by Tyler Brandt on 3/11/21.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
