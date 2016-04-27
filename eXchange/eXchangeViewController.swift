//
//  eXchangeViewController.swift
//  Exchange
//
//  Created by Emanuel Castaneda on 3/18/16.
//  Copyright © 2016 Emanuel Castaneda. All rights reserved.
//

import UIKit
import Firebase

class eXchangeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {

    // MARK: View Controller Outlets
    
    @IBOutlet var eXchangeBanner: UIImageView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var requestButton: UIButton!
    @IBOutlet var pendingButton: UIButton!
    
    
    // MARK: Global variable initialization
    
    var studentsData: [Student] = []
    var searchData: [Student] = []
    var pendingData: [Meal] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    var requestSelected = true
    var rescheduleDoneButtonHit: Bool = false
    var path = -1

    var userNetID: String = ""
    var currentUser: Student = Student(name: "", netid: "", club: "", proxNumber: "")
    var rescheduledate: String = ""
    var rescheduletype: String = ""
    var rescheduleclub: String = ""
    var rescheduleselecteduser: String = ""
    
    var dataBaseRoot = Firebase(url:"https://princeton-exchange.firebaseIO.com")
    
    
    // MARK: Initializing functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tbc = self.tabBarController as! eXchangeTabBarController
        self.userNetID = tbc.userNetID;
        print("Current user: " + userNetID)
        print("waiting\n")
        
        let delay = 2 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.studentsData = tbc.studentsData
            self.currentUser = tbc.currentUser
            print("testing " + self.currentUser.netid)
            print("testing2 " + self.currentUser.club)
            print(self.studentsData)
            self.loadPending()
        
            print("\ndone waiting\n")

            
            self.tableView.reloadData()
        }
        self.self.eXchangeBanner.image = UIImage(named:"exchange_banner")!
        self.tableView.rowHeight = 100.0
        self.requestButton.layer.cornerRadius = 5
        self.requestButton.backgroundColor = UIColor.orangeColor()
        self.pendingButton.layer.cornerRadius = 5
        self.pendingButton.backgroundColor = UIColor.blackColor()
        
        
        // setup search bar
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        self.definesPresentationContext = true
        self.tableView.tableHeaderView = self.searchController.searchBar
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }
    
    func loadStudents() {
        let studentsRoot = dataBaseRoot.childByAppendingPath("students")
        studentsRoot.observeEventType(.ChildAdded, withBlock:  { snapshot in
            let student = self.getStudentFromDictionary(snapshot.value as! Dictionary<String, String>)
            print(student.netid)
            self.studentsData.append(student)
            //self.tableView.reloadData()
            //self.didLoad = true
            }, withCancelBlock:  { error in
        })
    }
    
    func loadPending() {
        let pendingPath = "pending/" + userNetID
        let pendingRoot = dataBaseRoot.childByAppendingPath(pendingPath)
        pendingRoot.observeEventType(.ChildAdded, withBlock:  { snapshot in
            let dict: Dictionary<String, String> = snapshot.value as! Dictionary<String, String>
            let meal: Meal = self.getPendingFromDictionary(dict)
            self.pendingData.append(meal)
            self.tableView.reloadData()
            }, withCancelBlock:  { error in
        })
    }
    
    func getDictionary(student: Student) -> Dictionary<String, String> {
        var dictionary: Dictionary<String, String> = Dictionary<String, String>()
        dictionary["netID"] = student.netid
        dictionary["name"] = student.name
        dictionary["club"] = student.club
        dictionary["proxNumber"] = student.proxNumber
        return dictionary
    }
    
    func getStudentFromDictionary(dictionary: Dictionary<String, String>) -> Student {
        let student = Student(name: dictionary["name"]!, netid: dictionary["netID"]!, club: dictionary["club"]!, proxNumber: dictionary["proxNumber"]!)
        return student
    }
    
    func getPendingFromDictionary(dictionary: Dictionary<String, String>) -> Meal {
        let netID1 = dictionary["Host"]
        let netID2 = dictionary["Guest"]
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
        return Meal(date: dictionary["Date"]!, type: dictionary["Type"]!, host: host!, guest: guest!)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Button Actions
    
    @IBAction func requestButtonPressed(sender: AnyObject) {
        requestSelected = true
        requestButton.backgroundColor = UIColor.orangeColor()
        pendingButton.backgroundColor = UIColor.blackColor()
        
        tableView.tableHeaderView = searchController.searchBar
        tableView.reloadData()

    }
    
    @IBAction func pendingButtonPressed(sender: AnyObject) {
        requestSelected = false
        pendingButton.backgroundColor = UIColor.orangeColor()
        requestButton.backgroundColor = UIColor.blackColor()
        
        self.searchController.searchBar.text = ""
        self.searchController.searchBar.endEditing(true)
        self.searchController.active = false
        
        tableView.tableHeaderView = nil
        tableView.reloadData()
    }
    
    
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return searchData.count
        }
        if requestSelected {
            return studentsData.count
        } else {
            return pendingData.count
        }
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("exchangeCell", forIndexPath: indexPath) as! eXchangeTableViewCell
        var student: Student
        
        // If the user has searched for another student, populate cells with matching users
        if searchController.active && searchController.searchBar.text != "" {
            student = searchData[indexPath.row]
            if requestSelected {
                cell.nameLabel.text = student.name
                cell.clubLabel.text = student.club
            }
//            else {
//                if student.name != "" {
//                    cell.nameLabel.text = student.name + " wants to get a meal!"
//                    cell.clubLabel.text = student.club
//                }
//            }
        }
        
        // If the user is not searching, just populate cells with all appropriate groups of users
        else {
            if requestSelected {
                student = studentsData[indexPath.row]
                cell.nameLabel.text = student.name
                cell.clubLabel.text = student.club
            } else {
                if (self.pendingData[indexPath.row].host.netid == userNetID) {
                    student = pendingData[indexPath.row].guest
                }
                else {
                    student = pendingData[indexPath.row].host
                }

                if student.name != "" {
                    let string1 = student.name + " wants to get " + pendingData[indexPath.row].type + " at " + pendingData[indexPath.row].host.club
                    let string2 = " on " + self.getDayOfWeekString(pendingData[indexPath.row].date)!

                    cell.nameLabel.text = string1 + string2
                    cell.clubLabel.text = ""
                }
            }
        }

        cell.studentImage.image = UIImage(named: student.imageName)
        return cell
    }
    
    func getDayOfWeekString(today:String)->String? {
        let formatter  = NSDateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        if let todayDate = formatter.dateFromString(today) {
            let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
            let myComponents = myCalendar.components([.Weekday, .Month , .Day], fromDate: todayDate)
            let month = myComponents.month

            let date = myComponents.day
            let weekDay = myComponents.weekday
            var stringDay = ""
            var stringMonth = ""
            switch weekDay {
            case 1:
                stringDay = "Sunday, "
            case 2:
                stringDay = "Monday, "
            case 3:
                stringDay = "Tuesday, "
            case 4:
                stringDay = "Wednesday, "
            case 5:
                stringDay = "Thursday, "
            case 6:
                stringDay = "Friday, "
            case 7:
                stringDay = "Saturday, "
            default:
                print("Error fetching days")
                stringDay = "Day"
            }
            
            switch month {
            case 1:
                stringMonth = "January "
            case 2:
                stringMonth = "February "
            case 3:
                stringMonth = "March "
            case 4:
                stringMonth = "April "
            case 5:
                stringMonth = "May "
            case 6:
                stringMonth = "June "
            case 7:
                stringMonth = "July "
            case 8:
                stringMonth = "August "
            case 9:
                stringMonth = "September "
            case 10:
                stringMonth = "October "
            case 11:
                stringMonth = "November "
            case 12:
                stringMonth = "December "

            default:
                print("Error fetching month")
                stringDay = "Month"
            }
            return stringDay + stringMonth + String(date)
        } else {
            return nil
        }
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let cell = tableView.dequeueReusableCellWithIdentifier("exchangeCell", forIndexPath: indexPath) as! eXchangeTableViewCell
        
        // If the user taps on a cell in the request a meal tab, then segue to the create request view controller
        if requestSelected {
            performSegueWithIdentifier("createRequestSegue", sender: nil)
        }
        
        // If the user taps on a cell in the pending meals tab, then popup an alert allowing them to accept, reschedule, decline, or cancel the action
        else {
            
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Accept", style: .Default, handler:{ action in self.executeAction(action, indexPath:indexPath)}))
            alert.addAction(UIAlertAction(title: "Reschedule", style: .Default, handler:{ action in self.executeAction(action, indexPath:indexPath)}))
            alert.addAction(UIAlertAction(title: "Decline", style: .Default, handler:{ action in self.executeAction(action, indexPath:indexPath)}))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // Define special actions for accept, reschedule, and decline options
    func executeAction(alert: UIAlertAction!, indexPath: NSIndexPath){
        let response = alert.title!
        print(response)
        print("indexPath.row: " + String(indexPath.row) + "\n")
        path = indexPath.row
        
        
        if (response == "Accept") {
            //send the exchange to the database
            let upcomingString1 = "upcoming/" + pendingData[indexPath.row].host.netid
            let upcomingString2 = "upcoming/" + pendingData[indexPath.row].guest.netid

            let upcomingRoot1 = dataBaseRoot.childByAppendingPath(upcomingString1)
            let upcomingRoot2 = dataBaseRoot.childByAppendingPath(upcomingString2)

            var endRoot1 = -1
            var endRoot2 = -1
            
            upcomingRoot1.observeEventType(.Value, withBlock: { snapshot in
                var num: Int = 0
                let children = snapshot.children
                let count = snapshot.childrenCount
                
                while let child = children.nextObject() as? FDataSnapshot {
                    if (num != Int(child.key)) {
                        endRoot1 = num
                        break
                    }
                    else {
                        num+=1
                    }
                }
                if (endRoot1 == -1) {
                    endRoot1 = Int(count)
                }
            });
            
            upcomingRoot2.observeEventType(.Value, withBlock: { snapshot in
                var num: Int = 0
                let children = snapshot.children
                let count = snapshot.childrenCount
                
                while let child = children.nextObject() as? FDataSnapshot {
                    if (num != Int(child.key)) {
                        endRoot2 = num
                        break
                    }
                    else {
                        num+=1
                    }
                }
                if (endRoot2 == -1) {
                    endRoot2 = Int(count)
                }
            });
            
            
            
            let formatter = NSDateFormatter()
            formatter.dateFormat = "MM-dd-yyyy"
            
            let newEntry: Dictionary<String, String> = ["Date": pendingData[indexPath.row].date, "Guest": pendingData[indexPath.row].guest.netid, "Host": pendingData[indexPath.row].host.netid, "Type": "Lunch", "Club": pendingData[indexPath.row].host.club]
            
            let pendingString1 = "pending/" + self.currentUser.netid + "/"
            
            let pendingRootToUpdate = self.dataBaseRoot.childByAppendingPath(pendingString1)
            
            pendingRootToUpdate.observeEventType(.Value, withBlock: { snapshot in
                let children = snapshot.children
                while let child = children.nextObject() as? FDataSnapshot {
                    let clubString = (child.value["Club"] as! NSString) as String
                    let guestString = (child.value["Guest"] as! NSString) as String
                    let hostString = (child.value["Host"] as! NSString) as String
                    let dateString = (child.value["Date"] as! NSString) as String
                    let typeString = (child.value["Type"] as! NSString) as String
                    
                    if(clubString == self.pendingData[indexPath.row].host.club &&
                        guestString == self.pendingData[indexPath.row].guest.netid &&
                        hostString == self.pendingData[indexPath.row].host.netid &&
                        dateString == self.pendingData[indexPath.row].date &&
                        typeString == self.pendingData[indexPath.row].type) {
                        let pendingString2 = pendingString1 + String(child.key)
                        let pendingRootToRemove = self.dataBaseRoot.childByAppendingPath(pendingString2)
                        pendingRootToRemove.removeValue()
                    }
                }
            });
            
            
            let delay = 1 * Double(NSEC_PER_SEC)
            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            dispatch_after(time, dispatch_get_main_queue()) {
                let newUpcomingRoot1 = self.dataBaseRoot.childByAppendingPath(upcomingString1 + "/" + String(endRoot1))
                let newUpcomingRoot2 = self.dataBaseRoot.childByAppendingPath(upcomingString2 + "/" + String(endRoot2))

                
                //updateChildValues is exactly like setValue except it doesn't delete the old data
                newUpcomingRoot1.updateChildValues(newEntry)
                newUpcomingRoot2.updateChildValues(newEntry)

                self.dismissViewControllerAnimated(true, completion: {});
                print("SENT DATA")
            
                
                //remove the request from pending requests
                self.pendingData.removeAtIndex(indexPath.row)
                self.tableView.reloadData()
            }
            
        }
        else if (response == "Reschedule") {
            //prompt the user to create a new exchange
            
            performSegueWithIdentifier("rescheduleRequestSegue", sender: nil)
            //let tempStudent: Student = pendingData[indexPath.row]

           if rescheduleDoneButtonHit {
//                //if user hits done, create the new exchange and delete the old one
//                pendingData.removeAtIndex(indexPath.row)
//                print("removed")
            
          //  let newEntry: Dictionary<String, String> = ["Date": rescheduledate, "Guest": rescheduleselecteduser, "Host": currentUser, "Type": rescheduletype]

            //let pendingString = "pending/" + rescheduleselecteduser
            //let newPendingRoot = self.dataBaseRoot.childByAppendingPath(pendingString + "/")
            //updateChildValues is exactly like setValue except it doesn't delete the old data
            //newPendingRoot.updateChildValues(newEntry)
            

       }
            

            
            tableView.reloadData()
        }
        
        else if (response == "Decline") {
            let pendingString1 = "pending/" + self.currentUser.netid + "/"
            
            let pendingRootToUpdate = self.dataBaseRoot.childByAppendingPath(pendingString1)
            pendingRootToUpdate.observeEventType(.Value, withBlock: { snapshot in
                let children = snapshot.children
                while let child = children.nextObject() as? FDataSnapshot {
                    let clubString = (child.value["Club"] as! NSString) as String
                    let guestString = (child.value["Guest"] as! NSString) as String
                    let hostString = (child.value["Host"] as! NSString) as String
                    let dateString = (child.value["Date"] as! NSString) as String
                    let typeString = (child.value["Type"] as! NSString) as String
                    print("here : " + String(indexPath.row))
                    if(clubString == self.pendingData[indexPath.row].host.club &&
                        guestString == self.pendingData[indexPath.row].guest.netid &&
                        hostString == self.pendingData[indexPath.row].host.netid &&
                        dateString == self.pendingData[indexPath.row].date &&
                        typeString == self.pendingData[indexPath.row].type) {
                        let pendingString2 = pendingString1 + String(child.key)
                        let pendingRootToRemove = self.dataBaseRoot.childByAppendingPath(pendingString2)
                        pendingRootToRemove.removeValue()
                    }
                }
            });
            let delay = 1 * Double(NSEC_PER_SEC)
            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            dispatch_after(time, dispatch_get_main_queue()) {
                self.dismissViewControllerAnimated(true, completion: {});
                print("SENT DATA")
                
                
                //remove the request from pending requests
                self.pendingData.removeAtIndex(indexPath.row)
                self.tableView.reloadData()
            }
        
        }
    }
    
    
    // MARK: - Search Functions
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        if requestSelected {
            searchData = studentsData.filter { student in
                return student.name.lowercaseString.containsString(searchText.lowercaseString)
            }
        }
        // else {
//            searchData = pendingData.filter { student in
//                return student.name.lowercaseString.containsString(searchText.lowercaseString)
//            }
//        }
        tableView.reloadData()
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    
    // MARK: - Navigation
    
    @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue) {
        if unwindSegue.identifier == "unwindCancel" {
            rescheduleDoneButtonHit = false
            print("cancel")
        }
        
        else if unwindSegue.identifier == "unwindDone" {
            rescheduleDoneButtonHit = true
            pendingData.removeAtIndex(path)
            tableView.reloadData()
            print("removed")
            print("done")
        }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "createRequestSegue" {
            let newViewController:CreateRequestViewController = segue.destinationViewController as! CreateRequestViewController
            let indexPath = self.tableView.indexPathForSelectedRow
            if searchController.active && searchController.searchBar.text != "" {
                newViewController.selectedUser = self.searchData[indexPath!.row]
            }
            else {
                newViewController.selectedUser = self.studentsData[indexPath!.row]
            }
            newViewController.currentUser = self.currentUser
        }
        else if segue.identifier == "rescheduleRequestSegue" {
            let newViewController:RescheduleRequestViewController = segue.destinationViewController as! RescheduleRequestViewController
            
            if (self.pendingData[path].host.netid == userNetID) {
                newViewController.selectedUser = self.pendingData[path].guest
            }
            
            else if (self.pendingData[path].guest.netid == userNetID) {
                newViewController.selectedUser = self.pendingData[path].host
            }
            newViewController.currentUser = self.currentUser
        }
        
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }


    
    
    
    
    
    
    
    
    
    ////    func isLandscapeOrientation() -> Bool {
    ////        return UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication().statusBarOrientation)
    ////    }
    //
    //    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    ////        if isLandscapeOrientation() {
    ////            return hasImageAtIndexPath(indexPath) ? 140.0 : 120.0
    ////        } else {
    ////            return hasImageAtIndexPath(indexPath) ? 235.0 : 155.0
    ////        }
    //        return 100;
    //    }
    
    
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
    
    //    func addStudents() {
    //        let Emanuel = Student(name: "Emanuel Castaneda", netid: "emanuelc", club: "Cannon", proxNumber: "960755555")
    //        let Danielle = Student(name: "Danielle Pintz", netid: "dpintz", club: "Independent", proxNumber: "960755555")
    //        studentsData.append(Danielle)
    //
    //        let Meaghan = Student(name: "Meaghan O'Neill", netid: "mconeill", club: "Ivy", proxNumber: "960755555")
    //        studentsData.append(Meaghan)
    //
    //        let Sumer = Student(name: "Sumer Parikh", netid: "sumerp", club: "Cap & Gown", proxNumber: "960755555")
    //        studentsData.append(Sumer)
    //
    //        let James = Student(name: "James Almeida", netid: "jamespa", club: "Cap & Gown", proxNumber: "960755555")
    //        studentsData.append(James)
    //
    //        var students = Dictionary<String, Dictionary<String, String>>()
    //        students[Emanuel.netid] = getDictionary(Emanuel)
    //        students[Danielle.netid] = getDictionary(Danielle)
    //        students[Meaghan.netid] = getDictionary(Meaghan)
    //        students[Sumer.netid] = getDictionary(Sumer)
    //        //students[James.netid] = getDictionary(James)
    //
    //        let studentsRoot = dataBaseRoot.childByAppendingPath("students")
    //
    //        //updateChildValues is exactly like setValue except it doesn't delete the old data
    //        studentsRoot.updateChildValues(students)
    //    }
    
}
