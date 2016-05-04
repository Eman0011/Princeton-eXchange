//
//  ExchangeTableViewCell.swift
//  Exchange
//
//  Created by Emanuel Castaneda on 3/11/16.
//  Copyright © 2016 Emanuel Castaneda. All rights reserved.
//

import UIKit


class eXchangeTableViewCell: UITableViewCell {

    @IBOutlet var emoji: UILabel!
    @IBOutlet var clubLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var studentImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
