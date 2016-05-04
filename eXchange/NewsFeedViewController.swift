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
var princetonButtonSelected = true
var mealLiked = [Bool]()

class NewsFeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var eXchangeBanner: UIImageView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var princetonButton: UIButton!
    @IBOutlet var myClubButton: UIButton!
    
    var currentUser: Student? = nil
    var allMeals: [Meal] = []
    
    var filteredMeals: [Meal] = []
    
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
        
        
<<<<<<< HEAD
        let delay = 1 * Double(NSEC_PER_SEC)
=======
        let delay = 0.1 * Double(NSEC_PER_SEC)
>>>>>>> b95b5dbb983bb8b080b45707b4cef8814a9f58f3
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {
            var temp = [Meal]()
            for (var i = self.allMeals.count-1; i>=0; i=i-1){
                temp.append(self.allMeals[i])
            }
            print("next line is temp")
            print(temp)
            
            self.allMeals = temp
            ready = true
            for meal in self.allMeals {
                mealLiked.append(false)
                if NSUserDefaults.standardUserDefaults().objectForKey("array") != nil
                {
                    mealLiked = NSUserDefaults.standardUserDefaults().objectForKey("array") as! [Bool]
                }
                if (meal.host.club == self.currentUser!.club) {
                    self.filteredMeals.append(meal)
                }
                
<<<<<<< HEAD
            }
            self.tableView.reloadData()
=======
           }
           self.tableView.reloadData()
>>>>>>> b95b5dbb983bb8b080b45707b4cef8814a9f58f3
        }
        
    }
    
    func loadMeals() {
        
        let mealsRoot = dataBaseRoot.childByAppendingPath("newsfeed/")
        mealsRoot.observeEventType(.ChildAdded, withBlock: { snapshot in
            let dict: Dictionary<String, String> = snapshot.value as! Dictionary<String, String>
            let meal: Meal = self.getMealFromDictionary(dict)
            self.allMeals.append(meal)
<<<<<<< HEAD
            // self.tableView.reloadData()
=======
           // self.tableView.reloadData()
>>>>>>> b95b5dbb983bb8b080b45707b4cef8814a9f58f3
        })
        print(allMeals)
        
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
            return self.allMeals.count
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
            cell.row2 = indexPath.row
            cell.newsLabel?.numberOfLines = 0
            meal = allMeals[indexPath.row]
            cell.clubImage?.image = UIImage(named: meal.host.club)
            var numLikes = "-1"
            newsfeedRoot.observeSingleEventOfType(.Value, withBlock: { snapshot in
                var dict = snapshot.value as! Dictionary<String, String>
                numLikes = dict["Likes"]!
                print(numLikes)
                cell.likesLabel.text = String(numLikes) + " \u{e022}"
            })
            
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
            cell.row2 = indexPath.row
            for ind in 0...allMeals.count-1{
                let meal1 = allMeals[ind]
                let meal2 = filteredMeals[currCellNum]
                if (meal1.date == meal2.date && meal1.type == meal2.type && meal1.guest.netid == meal2.guest.netid && meal1.host.netid == meal2.host.netid) {
                    cell.row = ind
                    break
                }
                
            }
            cell.newsLabel?.numberOfLines = 0
            meal = filteredMeals[indexPath.row]
            cell.clubImage?.image = UIImage(named: meal.host.club + ".jpg")
            
            var numLikes = "-1"
            let newsfeedRoot = dataBaseRoot.childByAppendingPath("newsfeed/" + String(cell.row))
            newsfeedRoot.observeSingleEventOfType(.Value, withBlock: { snapshot in
                var dict = snapshot.value as! Dictionary<String, String>
                numLikes = dict["Likes"]!
                cell.likesLabel.text = String(numLikes) + " \u{e022}"
            })
            
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