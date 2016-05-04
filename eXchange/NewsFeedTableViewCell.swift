//
//  NewsFeedTableViewCell.swift
//  eXchange
//
//  Created by James Almeida on 4/7/16.
//  Copyright © 2016 Emanuel Castaneda. All rights reserved.
//

import UIKit
import Firebase

var ready = false

class NewsFeedTableViewCell: UITableViewCell {
    var row = 0
    var row2 = 0
    @IBOutlet weak var clubImage: UIImageView!
    @IBOutlet weak var newsLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likesLabel: UILabel!
    var dataBaseRoot = Firebase(url:"https://princeton-exchange.firebaseIO.com")
    var hasTapped: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.likesLabel.text = "\u{e022}"
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        if NSUserDefaults.standardUserDefaults().objectForKey("array") != nil
        {
            mealLiked = NSUserDefaults.standardUserDefaults().objectForKey("array") as! [Bool]
        }
        if (ready) {
            if (mealLiked[row]) {
            hasTapped = true
            likeButton.setTitle("Unlike", forState: .Normal)
            likeButton.setTitleColor(UIColor.orangeColor(), forState: .Normal)
        }
        else {
            hasTapped = false
            likeButton.setTitle("Like", forState: .Normal)
            likeButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        }
        }
    }
    
    @IBAction func tapLikeButton(sender: UIButton) {
        if hasTapped {
            hasTapped = false
            mealLiked[row] = false
            NSUserDefaults.standardUserDefaults().setObject(mealLiked, forKey: "array")
            self.likeButton.setTitle("Like", forState: .Normal)
            self.likeButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
            let newsRoot = dataBaseRoot.childByAppendingPath("newsfeed/" + String(row) + "/Likes")
            let otherRoot = dataBaseRoot.childByAppendingPath("newsfeed/" + String(row))
            var likes = 0
            newsRoot.observeSingleEventOfType(.Value, withBlock: { snapshot in
                let currlikes = String(snapshot.value)
                likes = Int(currlikes)!-1
                self.likesLabel.text = String(likes) + " \u{e022}"
                let dict = ["Likes" : String(likes)]
                otherRoot.updateChildValues(dict)
                }, withCancelBlock: { error in
            })
        }
        else {
            hasTapped = true
            mealLiked[row] = true
            NSUserDefaults.standardUserDefaults().setObject(mealLiked, forKey: "array")
            self.likeButton.setTitle("Unlike", forState: .Normal)
            self.likeButton.setTitleColor(UIColor.orangeColor(), forState: .Normal)
            let newsRoot = dataBaseRoot.childByAppendingPath("newsfeed/" + String(row) + "/Likes")
            let otherRoot = dataBaseRoot.childByAppendingPath("newsfeed/" + String(row))
            var likes = 0
            newsRoot.observeSingleEventOfType(.Value, withBlock: { snapshot in
                let currlikes = String(snapshot.value)
                likes = Int(currlikes)!+1
                self.likesLabel.text = String(likes) + " \u{e022}"
                let dict = ["Likes" : String(likes)]
                otherRoot.updateChildValues(dict)
                }, withCancelBlock: { error in
            })
        }
    }
    
}

