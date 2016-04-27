//
//  UserViewController.swift
//  eXchange
//
//  Created by Emanuel Castaneda on 3/20/16.
//  Copyright © 2016 Emanuel Castaneda. All rights reserved.
//

import UIKit
import Firebase
var row = 0
class UserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var eXchangeBanner: UIImageView!
    @IBOutlet var historyButton: UIButton!
    @IBOutlet var unfinishedButton: UIButton!
    @IBOutlet var upcomingButton: UIButton!
    
    var historyData: [eXchange] = []
    var unfinishedData: [eXchange] = []
    var upcomingData: [eXchange] = []
    var studentsData: [Student] = []
    
    var selectedUser: Student = Student(name: "", netid: "", club: "", proxNumber: "")
    var currentUser: Student = Student(name: "", netid: "", club: "", proxNumber: "")
    var historySelected = true
    var unfinishedSelected = false
    var upcomingSelected = false
    let formatter = NSDateFormatter()
    var daysLeft = 0
    var dataBaseRoot = Firebase(url:"https://princeton-exchange.firebaseIO.com")
    var userNetID: String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eXchangeBanner.image = UIImage(named:"exchange_banner")!
        self.tableView.rowHeight = 100.0
        
        historyButton.layer.cornerRadius = 5
        historyButton.backgroundColor = UIColor.orangeColor()
        unfinishedButton.layer.cornerRadius = 5
        unfinishedButton.backgroundColor = UIColor.blackColor()
        upcomingButton.layer.cornerRadius = 5
        upcomingButton.backgroundColor = UIColor.blackColor()
        
        formatter.dateFormat = "MM-dd-yyyy, hh:mm a"
        formatter.AMSymbol = "am"
        formatter.PMSymbol = "pm"
        
        daysLeft = getDaysLeft()
        let tbc = self.tabBarController as! eXchangeTabBarController
        self.studentsData = tbc.studentsData
        self.userNetID = tbc.userNetID
        self.currentUser = tbc.currentUser
        
        self.loadHistory()
        self.loadUnfinished()
        self.loadUpcoming()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }
    
    func loadHistory() {
        let path = "complete-exchange/" + userNetID
        let historyRoot = dataBaseRoot.childByAppendingPath(path)
        
        historyRoot.observeEventType(.ChildAdded, withBlock: { snapshot in
            let dict: Dictionary<String, String> = snapshot.value as! Dictionary<String, String>
            let exchange: eXchange = self.getCompleteFromDictionary(dict)
            self.historyData.append(exchange)
            self.tableView.reloadData()
        })
    }
    
    func loadUnfinished() {
        let path = "incomplete-exchange/" + userNetID
        let unfinishedRoot = dataBaseRoot.childByAppendingPath(path)
        
        unfinishedRoot.observeEventType(.ChildAdded, withBlock: { snapshot in
            let dict: Dictionary<String, String> = snapshot.value as! Dictionary<String, String>
            let exchange: eXchange = self.getIncompleteOrUpcomingFromDictionary(dict)
            self.unfinishedData.append(exchange)
            self.tableView.reloadData()
        })
    }
    
    func loadUpcoming() {
        let path = "upcoming/" + userNetID
        let upcomingRoot = dataBaseRoot.childByAppendingPath(path)
        
        upcomingRoot.observeEventType(.ChildAdded, withBlock: { snapshot in
            let dict: Dictionary<String, String> = snapshot.value as! Dictionary<String, String>
            let exchange: eXchange = self.getIncompleteOrUpcomingFromDictionary(dict)
           // print(exchange.meal1.date)
            self.upcomingData.append(exchange)
            self.tableView.reloadData()
        })
    }
    
    
    func getCompleteFromDictionary(dictionary: Dictionary<String, String>) -> eXchange {
        let netID2 = dictionary["Student"]
        var student1: Student? = nil
        var student2: Student? = nil
        
        for student in studentsData {
            if (student.netid == userNetID) {
                student1 = student
            }
            if (student.netid == netID2) {
                student2 = student
            }
        }
        
        let exchange = eXchange(host: student1!, guest: student2!, type: dictionary["Type"]!)
        
        return exchange
    }
    
    func getIncompleteOrUpcomingFromDictionary(dictionary: Dictionary<String, String>) -> eXchange {
        let hostID = dictionary["Host"]
        let guestID = dictionary["Guest"]
        var host: Student? = nil
        var guest: Student? = nil

        
        for student in studentsData {
            if (student.netid == hostID) {
                host = student
            }
            if (student.netid == guestID) {
                guest = student
            }
        }
        
        let exchange = eXchange(host: host!, guest: guest!, type: dictionary["Type"]!)
        let meal = Meal(date: dictionary["Date"]!, type: dictionary["Type"]!, host: host!, guest: guest!)
        exchange.meal1 = meal
        
        return exchange
    }
    
//    func loadMockData() {
//        let Emanuel = Student(name: "Emanuel Castaneda", netid: "emanuelc", club: "Cannon", proxNumber: "960755555")
//        let Danielle = Student(name: "Danielle Pintz", netid: "", club: "Independent", proxNumber: "")
//        let Meaghan = Student(name: "Meaghan O'Neill", netid: "", club: "Ivy", proxNumber: "")
//        let Sumer = Student(name: "Sumer Parikh", netid: "", club: "Cap & Gown", proxNumber: "")
//        let James = Student(name: "James Almeida", netid: "", club: "Cap & Gown", proxNumber: "")
//        
//        let today = NSDate()
//        print(formatter.stringFromDate(today))
//        
//        
//        let x1 = eXchange(host: Emanuel, guest: Sumer,  type: "Lunch")
//        x1.meal1.date = formatter.dateFromString("3-7-2016, 1:30 pm")!
//        let m1 = Meal(date: NSDate(), type: "Lunch", host: Sumer, guest: Emanuel)
//        x1.meal2 = m1
//        x1.meal2?.date = formatter.dateFromString("3-22-2016, 12:00 pm")!
//        historyData.append(x1)
//        
//        let x2 = eXchange(host: Emanuel, guest: Meaghan, type:  "Lunch")
//        x2.meal1.date = formatter.dateFromString("3-12-2016, 1:30 pm")!
//        let m2 = Meal(date: NSDate(), type: "Lunch", host: Meaghan, guest: Emanuel)
//        x2.meal2 = m2
//        x2.meal2?.date = formatter.dateFromString("3-16-2016, 12:30 pm")!
//        historyData.append(x2)
//        
//        
//        let x3 = eXchange(host: Emanuel, guest: Danielle, type:  "Dinner")
//        x3.meal1.date = formatter.dateFromString("3-14-2016, 6:30 pm")!
//        unfinishedXData.append(x3)
//        
//        let x4 = eXchange(host: Emanuel, guest: James, type:  "Dinner")
//        x4.meal1.date = formatter.dateFromString("4-20-2016, 6:30 pm")!
//        upcomingData.append(x4)
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Button Actions
    
    @IBAction func upcomingButtonPressed(sender: AnyObject) {
        historySelected = false
        unfinishedSelected = false
        upcomingSelected = true
        upcomingButton.backgroundColor = UIColor.orangeColor()
        historyButton.backgroundColor = UIColor.blackColor()
        unfinishedButton.backgroundColor = UIColor.blackColor()
        tableView.reloadData()
    }
    @IBAction func historyButtonPressed(sender: AnyObject) {
        historySelected = true
        unfinishedSelected = false
        upcomingSelected = false
        historyButton.backgroundColor = UIColor.orangeColor()
        unfinishedButton.backgroundColor = UIColor.blackColor()
        upcomingButton.backgroundColor = UIColor.blackColor()
        tableView.reloadData()
    }
    
    @IBAction func unfinishedButtonPressed(sender: AnyObject) {
        historySelected = false
        unfinishedSelected = true
        upcomingSelected = false
        unfinishedButton.backgroundColor = UIColor.orangeColor()
        historyButton.backgroundColor = UIColor.blackColor()
        upcomingButton.backgroundColor = UIColor.blackColor()
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
        if historySelected {
            return historyData.count
        }
        else if unfinishedSelected {
            return unfinishedData.count
        }
        else {
            return upcomingData.count
        }
    }
    
    
    /* NOTE: uses the eXchangeTableViewCell layout for simplicity. nameLabel serves as description label, and clubLabel serves as information label */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("userCell", forIndexPath: indexPath) as! UserTableViewCell
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        var student: Student
        if historySelected {
            unfinishedSelected = false
            upcomingSelected = false
            let exchange = historyData[indexPath.row]
            student = exchange.guest
            cell.nameLabel.text = exchange.guest.name
            let meal2String: String
            if (exchange.meal2 == nil) {
                meal2String = "MEAL WAS NOT INITIALIZED"
            } else {
                meal2String = exchange.meal2!.date
            }
            cell.meal1Label.text = "Meal 1: " + exchange.meal1.date
            cell.meal2Label.text = "Meal 2: " + meal2String
        }
            
        else if unfinishedSelected {
            historySelected = false
            upcomingSelected = false
            let exchange = unfinishedData[indexPath.row]
            student = exchange.guest
            cell.nameLabel.text = "Meal eXchange with " + exchange.guest.name + "."
            cell.meal1Label.text = "\(daysLeft) days left to complete!"
            cell.meal2Label.text = ""
            

            
        }
        else {
            historySelected = false
            unfinishedSelected = false
            let exchange = upcomingData[indexPath.row]
            student = exchange.guest
            cell.nameLabel.text = "You have scheduled a meal eXchange with " + exchange.guest.name + "."
            self.currentUser = exchange.host
            self.selectedUser = exchange.guest
            cell.meal1Label.text = ""
            cell.meal2Label.text = "For " + exchange.meal1.type + " on " + exchange.meal1.date
            
            
        }
        cell.studentImage.image = UIImage(named: student.imageName)
        return cell
    }
    
    /* calculate the number of days left to complete meal eXchange */
    func getDaysLeft() -> Int {
        let today = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day], fromDate: today)
        let xStart = components.day
        let range = calendar.rangeOfUnit(.Day, inUnit: .Month, forDate: today)
        let xEnd = range.length
        return xEnd - xStart
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    override func shouldPerformSegueWithIdentifier(identifier: String,sender: AnyObject?) -> Bool {
        
        if (unfinishedSelected) {
        return true
        }
        else {
            return false
        }
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (unfinishedSelected) {
            let newViewController:CompleteUnfinishedViewController = segue.destinationViewController as! CompleteUnfinishedViewController
            newViewController.currentUser = self.currentUser
            newViewController.selectedUser = self.selectedUser
            let indexPath = self.tableView.indexPathForSelectedRow
            row = indexPath!.row
            newViewController.selectedUser = self.unfinishedData[indexPath!.row].guest
            
        }
    }
}