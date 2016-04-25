//
//  NewsFeedTableViewCell.swift
//  eXchange
//
//  Created by James Almeida on 4/7/16.
//  Copyright © 2016 Emanuel Castaneda. All rights reserved.
//

import UIKit

class NewsFeedTableViewCell: UITableViewCell {
    //var row = 0
    @IBOutlet weak var clubImage: UIImageView!
    @IBOutlet weak var newsLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likesLabel: UILabel!
    
    
    var counter: Int = 0
    var hasTapped: Bool = false
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.likesLabel.text = "\u{e022}"
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
    }
    
}


           // let newsRoot = dataBaseRoot.childByAppendingPath("newsfeed/" + String(row) + "/Likes")
         //   var currlikes = ""
            //newsRoot.observeEventType(.Value, withBlock: { snapshot in
                //currlikes = String(snapshot.value)
               // print(currlikes)
                //let likes = Int(currlikes)!+1
                //print(likes)
                //let dict = ["Likes" : String(likes)]
                //newsRoot.updateChildValues(dict)
             //   }, withCancelBlock: { error in
           // })
            
            /* let newEntry: Dictionary<String, String> = ["Date": allMeals[indexPath.row].date, "Guest": allMeals[indexPath.row].guest.netid, "Host": allMeals[indexPath.row].host.netid, "Likes": allMeals[indexPath.row].likes, "Type": allMeals[indexPath.row].type]
             */
            
            //updateChildValues is exactly like setValue except it doesn't delete the old data
           //print("BREAK")
            //print(currlikes)
            //let likes = Int(currlikes[0])
            //print(likes)
            //var dict = ["Likes" : String(likes!+1)]
            //newsRoot.updateChildValues(dict)

 