//
//  UserTableViewCell.swift
//  eXchange
//
//  Created by James Almeida on 4/1/16.
//  Copyright © 2016 Emanuel Castaneda. All rights reserved.
//

import UIKit

class MyMealsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var studentImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var meal1Label: UILabel!
    @IBOutlet weak var meal2Label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
