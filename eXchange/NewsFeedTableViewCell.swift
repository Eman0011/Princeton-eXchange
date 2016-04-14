//
//  NewsFeedTableViewCell.swift
//  eXchange
//
//  Created by James Almeida on 4/7/16.
//  Copyright © 2016 Emanuel Castaneda. All rights reserved.
//

import UIKit

class NewsFeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var clubImage: UIImageView!
    @IBOutlet weak var newsLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likesLabel: UILabel!
    
    
    var counter: Int = 0
    var hasTapped: Bool = false

    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.likesLabel.text = "\u{e022}"
        print("curr cell num")
       print(currCellNum)        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func tapLikeButton(sender: UIButton) {
        if hasTapped {
            counter--
            hasTapped = false
            //mealLiked[currCellNum] = true
            self.likeButton.setTitle("Like", forState: .Normal)
            self.likeButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        }
        else {
            counter++
            hasTapped = true
            //mealLiked[currCellNum] = false
            self.likeButton.setTitle("Unlike", forState: .Normal)
            self.likeButton.setTitleColor(UIColor.orangeColor(), forState: .Normal)

        }
        if counter == 0 {
            self.likesLabel.text = "\u{e022}"
        }
        else {
            self.likesLabel.text = "\u{e022} " + String(counter)
        }
    }

}
