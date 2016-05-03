//
//  NewsFeedViewController.swift
//  eXchange
//
//  Created by Emanuel Castaneda on 3/21/16.
//  Copyright © 2016 Emanuel Castaneda. All rights reserved.
//

import UIKit
import Firebase
var currCellNum = 0
var mealLiked = [Bool]()

class NewsFeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var eXchangeBanner: UIImageView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var princetonButton: UIButton!
    @IBOutlet var myClubButton: UIButton!
    
    var currentUser: Student? = nil
    
    var allMeals: [Meal] = []
    var filteredMeals: [Meal] = []
    var princetonButtonSelected = true
    
    var dataBaseRoot = Firebase(url:"https://princeton-exchange.firebaseIO.com")
    var studentsData: [Student] = []
    
    var userNetID: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        eXchangeBanner.image = UIImage(named:"exchange_banner")!
        self.tableView.rowHeight = 100.0
        
        princetonButton.layer.cornerRadius = 5
        princetonButton.backgroundColor = UIColor.orangeColor()
        myClubButton.layer.cornerRadius = 5
        myClubButton.backgroundColor = UIColor.blackColor()
        
        
        self.loadMeals()
        let tbc = self.tabBarController as! eXchangeTabBarController
        self.studentsData = tbc.studentsData
        self.userNetID = tbc.userNetID
        self.currentUser = tbc.currentUser
        
        let delay = 1 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {
            
            for meal in self.allMeals {
                if (meal.host.club == self.currentUser!.club) {
                    self.filteredMeals.append(meal)
                    mealLiked.append(false)
                }
            }
        }
        
    }
    
    
    // basically copy/pasted from Eman's exchange code
    func loadMeals() {
        
        let mealsRoot = dataBaseRoot.childByAppendingPath("newsfeed/")
        mealsRoot.observeEventType(.ChildAdded, withBlock: { snapshot in
            let dict: Dictionary<String, String> = snapshot.value as! Dictionary<String, String>
            let meal: Meal = self.getMealFromDictionary(dict)
            self.allMeals.append(meal)
            self.tableView.reloadData()
        })
    }
    
    
    func getMealFromDictionary(dictionary: Dictionary<String, String>) -> Meal {
        let netID1 = dictionary["Host"]!
        let netID2 = dictionary["Guest"]!
        var host: Student? = nil
        var guest: Student? = nil
        for student in studentsData {
            if (student.netid == netID1) {
                host = student
            }
            if (student.netid == netID2) {
                guest = student
            }
        }
        let meal = Meal(date: dictionary["Date"]!, type: dictionary["Type"]!, host: host!, guest: guest!)
        meal.likes = Int(dictionary["Likes"]!)!
        return meal
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Button Actions
    @IBAction func princetonButtonPressed(sender: AnyObject) {
        princetonButtonSelected = true
        princetonButton.backgroundColor = UIColor.orangeColor()
        myClubButton.backgroundColor = UIColor.blackColor()
        tableView.reloadData()
    }
    
    @IBAction func myClubButtonPressed(sender: AnyObject) {
        princetonButtonSelected = false
        myClubButton.backgroundColor = UIColor.orangeColor()
        princetonButton.backgroundColor = UIColor.blackColor()
        tableView.reloadData()
    }

    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if princetonButtonSelected {
            return allMeals.count
        }
        else {
            return filteredMeals.count
        }
    }
    
    /* NOTE: uses the eXchangeTableViewCell layout for simplicity. nameLabel serves as description label, and clubLabel serves as information label */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var meal: Meal
        let attrs1 = [NSFontAttributeName : UIFont.boldSystemFontOfSize(17), NSForegroundColorAttributeName: UIColor.orangeColor()]
        let attrs2 = [NSFontAttributeName : UIFont.boldSystemFontOfSize(17), NSForegroundColorAttributeName: UIColor.blackColor()]
        let attrs3 = [NSFontAttributeName : UIFont.boldSystemFontOfSize(15), NSForegroundColorAttributeName: UIColor.blackColor()]
        
        if princetonButtonSelected {
            currCellNum = indexPath.row
            let newsfeedRoot = dataBaseRoot.childByAppendingPath("newsfeed/" + String(currCellNum))
            let cell = tableView.dequeueReusableCellWithIdentifier("newsfeedCell", forIndexPath: indexPath) as! NewsFeedTableViewCell
            cell.row = indexPath.row
            cell.newsLabel?.numberOfLines = 0
            meal = allMeals[indexPath.row]
            cell.clubImage?.image = UIImage(named: meal.host.club + ".jpg")
            var numLikes = "-1"

            cell.likesLabel.text = String(meal.likes) + " \u{e022}"
           newsfeedRoot.observeEventType(.Value, withBlock: { snapshot in
                var dict = snapshot.value as! Dictionary<String, String>
                print(dict)
                numLikes = dict["Likes"]!
                cell.likesLabel.text = String(numLikes) + " \u{e022}"
               
           })
            let delay = 2 * Double(NSEC_PER_SEC)
            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            dispatch_after(time, dispatch_get_main_queue()) {
                cell.likesLabel.text = String(numLikes) + " \u{e022}"
            }
                       let boldName1 = NSMutableAttributedString(string:meal.host.name, attributes:attrs1)
            let boldName2 = NSMutableAttributedString(string:meal.guest.name, attributes:attrs2)
            let boldMeal = NSMutableAttributedString(string:meal.type, attributes:attrs3)
            

            let newsText: NSMutableAttributedString = boldName1
            
            newsText.appendAttributedString(NSMutableAttributedString(string: " and "))
            newsText.appendAttributedString(boldName2)
            newsText.appendAttributedString(NSMutableAttributedString(string: " eXchanged for "))
            newsText.appendAttributedString(boldMeal)

            cell.newsLabel!.attributedText = newsText
            return cell
        }
        else {
            currCellNum = indexPath.row

        let cell = tableView.dequeueReusableCellWithIdentifier("newsfeedCell", forIndexPath: indexPath) as! NewsFeedTableViewCell
            cell.row = indexPath.row
            cell.newsLabel?.numberOfLines = 0
            meal = filteredMeals[indexPath.row]
            cell.clubImage?.image = UIImage(named: meal.host.club + ".jpg")
            
            let boldName1 = NSMutableAttributedString(string:meal.host.name, attributes:attrs1)
            let boldName2 = NSMutableAttributedString(string:meal.guest.name, attributes:attrs2)
            let boldMeal = NSMutableAttributedString(string:meal.type, attributes:attrs3)
            
            let newsText: NSMutableAttributedString = boldName1
            
            newsText.appendAttributedString(NSMutableAttributedString(string: " and "))
            newsText.appendAttributedString(boldName2)
            newsText.appendAttributedString(NSMutableAttributedString(string: " eXchanged for "))
            newsText.appendAttributedString(boldMeal)
           
            cell.newsLabel!.attributedText = newsText
            
            return cell
        }
    }

    
}