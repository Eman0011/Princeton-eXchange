//
//  eXchangeViewController.swift
//  Exchange
//
//  Created by Emanuel Castaneda on 3/18/16.
//  Copyright © 2016 Emanuel Castaneda. All rights reserved.
//

import UIKit

class eXchangeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {

    // MARK: View Controller Outlets
    
    @IBOutlet var eXchangeBanner: UIImageView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var requestButton: UIButton!
    @IBOutlet var pendingButton: UIButton!

    
    
    // MARK: Global variable initialization
    
    var mockData: [Student] = []
    var searchData: [Student] = []
    var pendingData: [Student] = []
    let searchController = UISearchController(searchResultsController: nil)
    var requestSelected = true
    var path = -1
    var userNetID: String = ""
    
    
    // MARK: Initializing functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tbc = self.tabBarController as! eXchangeTabBarController
        self.userNetID = tbc.userNetID;
        
        eXchangeBanner.image = UIImage(named:"exchange_banner")!
        self.tableView.rowHeight = 100.0
        
        requestButton.layer.cornerRadius = 5
        requestButton.backgroundColor = UIColor.orangeColor()
        pendingButton.layer.cornerRadius = 5
        pendingButton.backgroundColor = UIColor.blackColor()
        
        
        self.loadMockData()
        
        // setup search bar
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }
    
    // used as a filler until we have a database to access
    func loadMockData() {
        let Emanuel = Student(name: "Emanuel Castaneda", netid: "emanuelc", club: "Cannon", proxNumber: "960755555")
        mockData.append(Emanuel)
        
        let Danielle = Student(name: "Danielle Pintz", netid: "", club: "Independent", proxNumber: "")
        mockData.append(Danielle)
        
        let Meaghan = Student(name: "Meaghan O'Neill", netid: "", club: "Ivy", proxNumber: "")
        mockData.append(Meaghan)
        
        let Sumer = Student(name: "Sumer Parikh", netid: "", club: "Cap & Gown", proxNumber: "")
        mockData.append(Sumer)
        
        let James = Student(name: "James Almeida", netid: "jamespa", club: "Cap & Gown", proxNumber: "")
        mockData.append(James)
        
        let Extra = Student(name: "Other", netid: "", club: "--", proxNumber: "")
        mockData.append(Extra)
        mockData.append(Extra)
        mockData.append(Extra)
        mockData.append(Extra)
        
        pendingData.append(Danielle)
        pendingData.append(Emanuel)
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
            return mockData.count
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
            } else {
                if student.name != "" {
                    cell.nameLabel.text = student.name + " wants to get a meal!"
                    cell.clubLabel.text = student.club
                }
            }
        }
        
        // If the user is not searching, just populate cells with all appropriate groups of users
        else {
            if requestSelected {
                student = mockData[indexPath.row]
                cell.nameLabel.text = student.name
                cell.clubLabel.text = student.club
            } else {
                student = pendingData[indexPath.row]
                if student.name != "" {
                    cell.nameLabel.text = student.name + " wants to get a meal!"
                    cell.clubLabel.text = student.club
                }
            }
        }

        cell.studentImage.image = UIImage(named: student.imageName)
        return cell
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
        print(indexPath.row)
        path = indexPath.row
        
        if (response == "Accept") {
            //send the exchange to the database
            
            //remove the request from pending requests
            if searchController.active && searchController.searchBar.text != "" {
                searchData.removeAtIndex(indexPath.row)
                tableView.reloadData()
            }
            else {
                pendingData.removeAtIndex(indexPath.row)
                tableView.reloadData()
            }
            
        }
        else if (response == "Reschedule") {
            //prompt the user to create a new exchange
            
            performSegueWithIdentifier("createRequestSegue", sender: nil)
            
            //if user hits cancel, do nothing
            //if user hits done, create the new exchange and delete the old one
            
            pendingData.removeAtIndex(indexPath.row)
            tableView.reloadData()
        }
        
        else if (response == "Decline") {
            //remove the request
            pendingData.removeAtIndex(indexPath.row)
            tableView.reloadData()
            
            //optionally send a notification to requester that user couldn't make it
        }
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
    
    
    // MARK: - Search Functions
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        if requestSelected {
            searchData = mockData.filter { student in
                return student.name.lowercaseString.containsString(searchText.lowercaseString)
            }
        } else {
            searchData = pendingData.filter { student in
                return student.name.lowercaseString.containsString(searchText.lowercaseString)
            }
        }
        tableView.reloadData()
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
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
    
    
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if requestSelected {
            let viewController:CreateRequestViewController = segue.destinationViewController as! CreateRequestViewController
            let indexPath = self.tableView.indexPathForSelectedRow
            if searchController.active && searchController.searchBar.text != "" {
                viewController.selectedUser = self.searchData[indexPath!.row]
            }
            else {
                viewController.selectedUser = self.mockData[indexPath!.row]
            }
            print("debugging")
        }
        else {
            let viewController:CreateRequestViewController = segue.destinationViewController as! CreateRequestViewController
            if searchController.active && searchController.searchBar.text != "" {
                viewController.selectedUser = self.searchData[path]
            }
            else {
                viewController.selectedUser = self.pendingData[path]
            }
            path = -1
        }
        
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }


}
