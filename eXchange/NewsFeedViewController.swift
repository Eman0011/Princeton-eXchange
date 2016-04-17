//
//  NewsFeedViewController.swift
//  eXchange
//
//  Created by Emanuel Castaneda on 3/21/16.
//  Copyright © 2016 Emanuel Castaneda. All rights reserved.
//

import UIKit
import Firebase

class NewsFeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var eXchangeBanner: UIImageView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var princetonButton: UIButton!
    @IBOutlet var myClubButton: UIButton!
    
    var currentUser: Student = Student(name: "Sumer Parikh", netid: "", club: "Cap & Gown", proxNumber: "")
    
    var princetonButtonSelected = true
    var mealLiked = [Bool]()
    var currCellNum = 0
    
    //var mockMeals: [Meal] = []
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
        
        //loadMockData()
        
        self.loadMeals()
        let tbc = self.tabBarController as! eXchangeTabBarController
        self.studentsData = tbc.studentsData
        self.userNetID = tbc.userNetID
        
        for meal in allMeals {
            if (meal.host.club == currentUser.club) {
                filteredMeals.append(meal)
            }
        }
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }
    
    
    // basically copy/pasted from Eman's exchange code
    func loadMeals() {
        
        let mealsRoot = dataBaseRoot.childByAppendingPath("newsfeed")
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
    
//    func getStudentFromDictionary(dictionary: Dictionary<String, String>) -> Student {
//        print(dictionary)
//        let student = Student(name: dictionary["name"]!, netid: dictionary["netID"]!, club: dictionary["club"]!, proxNumber: dictionary["proxNumber"]!)
//        return student
//    }
    
//    func loadMockData() {
//        let Emanuel = Student(name: "Emanuel Castaneda", netid: "emanuelc", club: "Cannon", proxNumber: "960755555")
//        let Danielle = Student(name: "Danielle Pintz", netid: "", club: "Independent", proxNumber: "")
//        let Meaghan = Student(name: "Meaghan O'Neill", netid: "", club: "Ivy", proxNumber: "")
//        let Sumer = Student(name: "Sumer Parikh", netid: "", club: "Cap & Gown", proxNumber: "")
//        //        let James = Student(name: "James Almeida", netid: "", club: "", proxNumber: "")
//        
//        let formatter = NSDateFormatter()
//        formatter.dateFormat = "MM-dd-yyyy, hh:mm a"
//        formatter.AMSymbol = "am"
//        formatter.PMSymbol = "pm"
//        
//        let today = NSDate()
//        print(formatter.stringFromDate(today))
//        
//        let x1 = eXchange(host: Emanuel, guest: Sumer,  type: "Lunch")
//        x1.meal1.date = formatter.dateFromString("3-7-2016, 1:30 pm")!
//        x1.completeExchange(formatter.dateFromString("3-22-2016, 12:00 pm")!, type: "Lunch", host: Sumer, guest: Emanuel)
//        x1.meal2?.date = formatter.dateFromString("3-22-2016, 12:00 pm")!
//        mockMeals.append(x1.meal1)
//        mockMeals.append(x1.meal2!)
//        
//        let x2 = eXchange(host: Emanuel, guest: Meaghan, type: "Dinner")
//        x2.meal1.date = formatter.dateFromString("3-12-2016, 7:30 pm")!
//        x2.completeExchange(formatter.dateFromString("3-16-2016, 6:30 pm")!, type: "Dinner", host: Meaghan, guest: Emanuel)
//        mockMeals.append(x2.meal1)
//        mockMeals.append(x2.meal2!)
//        
//        let x3 = eXchange(host: Emanuel, guest: Danielle, type: "Lunch")
//        x3.meal1.date = formatter.dateFromString("3-14-2016, 1:30 pm")!
//        mockMeals.append(x3.meal1)
//    }
    
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
            let cell = tableView.dequeueReusableCellWithIdentifier("newsfeedCell", forIndexPath: indexPath) as! NewsFeedTableViewCell
            cell.newsLabel?.numberOfLines = 0
            meal = allMeals[indexPath.row]
            cell.clubImage?.image = UIImage(named: meal.host.club + ".jpg")
            
            // like button no longer works because we're accessing from database
            cell.likesLabel.text = String(meal.likes + cell.counter)
            
            
            // old way of setting text:
            // cell.newsLabel!.text = "\(meal.host.name) and \(meal.guest.name) eXchanged for \(meal.type) at \(meal.host.club)"
            
            let boldName1 = NSMutableAttributedString(string:meal.host.name, attributes:attrs1)
            let boldName2 = NSMutableAttributedString(string:meal.guest.name, attributes:attrs2)
            let boldMeal = NSMutableAttributedString(string:meal.type, attributes:attrs3)
            //let boldClub = NSMutableAttributedString(string:meal.host.club, attributes:attrs1)
            

            // + " and " + boldName1 + " eXchanged for " + boldMeal + " at " + boldClub
            let newsText: NSMutableAttributedString = boldName1
            
            newsText.appendAttributedString(NSMutableAttributedString(string: " and "))
            newsText.appendAttributedString(boldName2)
            newsText.appendAttributedString(NSMutableAttributedString(string: " eXchanged for "))
            newsText.appendAttributedString(boldMeal)
//            newsText.appendAttributedString(NSMutableAttributedString(string: " at "))
//            newsText.appendAttributedString(boldClub)
            
            cell.newsLabel!.attributedText = newsText
            
            return cell
        }
        else {
            currCellNum = indexPath.row
            let cell = tableView.dequeueReusableCellWithIdentifier("newsfeedCell", forIndexPath: indexPath) as! NewsFeedTableViewCell
            cell.newsLabel?.numberOfLines = 0
            meal = filteredMeals[indexPath.row]
            cell.clubImage?.image = UIImage(named: meal.host.club + ".jpg")
            //cell.newsLabel!.text = "\(meal.host.name) and \(meal.guest.name) eXchanged for \(meal.type) at \(meal.host.club)"
            
            let boldName1 = NSMutableAttributedString(string:meal.host.name, attributes:attrs1)
            let boldName2 = NSMutableAttributedString(string:meal.guest.name, attributes:attrs2)
            let boldMeal = NSMutableAttributedString(string:meal.type, attributes:attrs3)
            //let boldClub = NSMutableAttributedString(string:meal.host.club, attributes:attrs1)
            
            
            // + " and " + boldName1 + " eXchanged for " + boldMeal + " at " + boldClub
            let newsText: NSMutableAttributedString = boldName1
            
            newsText.appendAttributedString(NSMutableAttributedString(string: " and "))
            newsText.appendAttributedString(boldName2)
            newsText.appendAttributedString(NSMutableAttributedString(string: " eXchanged for "))
            newsText.appendAttributedString(boldMeal)
            //            newsText.appendAttributedString(NSMutableAttributedString(string: " at "))
            //            newsText.appendAttributedString(boldClub)
            
            cell.newsLabel!.attributedText = newsText
            
            return cell
        }
    }

    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}