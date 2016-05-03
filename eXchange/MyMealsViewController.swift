//
//  UserViewController.swift
//  eXchange
//
//  Created by Emanuel Castaneda on 3/20/16.
//  Copyright © 2016 Emanuel Castaneda. All rights reserved.
//

import UIKit
import Firebase

var daysLeft = 0


class MyMealsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var eXchangeBanner: UIImageView!
    @IBOutlet var historyButton: UIButton!
    @IBOutlet var unfinishedButton: UIButton!
    @IBOutlet var upcomingButton: UIButton!
    
    var historyData: [eXchange] = []
    var unfinishedData: [eXchange] = []
    var upcomingData: [eXchange] = []
    var studentsData: [Student] = []
    

    var selectedUser: Student = Student(name: "", netid: "", club: "", proxNumber: "", image: "")
    var currentUser: Student = Student(name: "", netid: "", club: "", proxNumber: "", image: "")
    var historySelected = false
    var unfinishedSelected = true
    var upcomingSelected = false
    let formatter = NSDateFormatter()
    var dataBaseRoot = Firebase(url:"https://princeton-exchange.firebaseIO.com")
    var userNetID: String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eXchangeBanner.image = UIImage(named:"exchange_banner")!
        self.tableView.rowHeight = 100.0
        
        unfinishedButton.layer.cornerRadius = 5
        unfinishedButton.backgroundColor = UIColor.orangeColor()
        upcomingButton.layer.cornerRadius = 5
        upcomingButton.backgroundColor = UIColor.blackColor()
        historyButton.layer.cornerRadius = 5
        historyButton.backgroundColor = UIColor.blackColor()
        
        formatter.dateFormat = "MM-dd-yyyy"
        formatter.AMSymbol = "am"
        formatter.PMSymbol = "pm"
        
        daysLeft = getDaysLeft()
        let tbc = self.tabBarController as! eXchangeTabBarController
        self.studentsData = tbc.studentsData
        self.userNetID = tbc.userNetID
        self.currentUser = tbc.currentUser
        
        self.loadUnfinished()
        self.loadUpcoming()
        self.loadHistory()
        
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
            let todayDate = NSDate()
            let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
            let todayComponents = myCalendar.components([.Month], fromDate: todayDate)
            let exchangeComponents = myCalendar.components([.Month], fromDate: self.formatter.dateFromString(exchange.meal1.date)!)
            
            if (todayComponents.month == exchangeComponents.month) {
                self.unfinishedData.append(exchange)
                self.tableView.reloadData()
            }
        })
    }
    
    func loadUpcoming() {
        let path = "upcoming/" + userNetID
        let upcomingRoot = dataBaseRoot.childByAppendingPath(path)
        
        upcomingRoot.observeEventType(.ChildAdded, withBlock: { snapshot in
            let dict: Dictionary<String, String> = snapshot.value as! Dictionary<String, String>
            let exchange: eXchange = self.getIncompleteOrUpcomingFromDictionary(dict)
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
        let mealNum1 = Meal(date: dictionary["Date1"]!, type: dictionary["Type"]!, host: student1!, guest: student2!)
        exchange.meal1 = mealNum1
        let mealNum2 = Meal(date: dictionary["Date2"]!, type: dictionary["Type"]!, host: student2!, guest: student1!)
        exchange.meal2 = mealNum2
        
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
        let cell = tableView.dequeueReusableCellWithIdentifier("userCell", forIndexPath: indexPath) as! MyMealsTableViewCell
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
            cell.meal1Label.text = "Meal 1: \(exchange.meal1.date)"
            cell.meal2Label.text = "Meal 2: " + meal2String
        }
            
        else if unfinishedSelected {
            historySelected = false
            upcomingSelected = false
            let exchange = unfinishedData[indexPath.row]
            if (currentUser.netid == exchange.host.netid) {
                student = exchange.guest
            }
            else {
                student = exchange.host
            }
            cell.nameLabel.text = "Meal eXchange with " + student.name + "."
            cell.meal1Label.text = "\(daysLeft) days left to complete!"
            cell.meal2Label.text = ""
            

            
        }
        else {
            historySelected = false
            unfinishedSelected = false
            let exchange = upcomingData[indexPath.row]
            
            if (self.upcomingData[indexPath.row].host.netid == userNetID) {
                student = exchange.guest
            } else {
                student = exchange.host
            }
            
            cell.nameLabel.text = "\(exchange.meal1.type) with \(student.name)"
            self.currentUser = exchange.host
            self.selectedUser = exchange.guest
            cell.meal1Label.text = "\(exchange.host.club) on \(exchange.meal1.date)"
            cell.meal2Label.text = ""

            
            
        }
        if (student.image != "") {
            let decodedData = NSData(base64EncodedString: student.image, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
            cell.studentImage.image = UIImage(data: decodedData!)!
        } else {
            cell.studentImage.image = UIImage(named: "princetonTiger.png")
        }
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
            newViewController.selectedUser = self.unfinishedData[indexPath!.row].guest
            newViewController.setType = self.unfinishedData[indexPath!.row].meal1.type
            newViewController.setClub = self.unfinishedData[indexPath!.row].meal1.guest.club
        }
    }
}