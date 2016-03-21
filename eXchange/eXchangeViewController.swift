//
//  eXchangeViewController.swift
//  Exchange
//
//  Created by Emanuel Castaneda on 3/18/16.
//  Copyright © 2016 Emanuel Castaneda. All rights reserved.
//

import UIKit

class eXchangeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {

    @IBOutlet var eXchangeBanner: UIImageView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var requestButton: UIButton!
    @IBOutlet var pendingButton: UIButton!

    
    var mockData: [Student] = []
    var searchData: [Student] = []
    var pendingData: [Student] = []
    let searchController = UISearchController(searchResultsController: nil)
    var requestSelected = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    func loadMockData() {
        let Emanuel = Student(name: "Emanuel Castaneda", netid: "emanuelc", club: "Cannon", proxNumber: "960755555")
        mockData.append(Emanuel)
        
        let Danielle = Student(name: "Danielle Pintz", netid: "", club: "Independent", proxNumber: "")
        mockData.append(Danielle)
        
        let Meaghan = Student(name: "Meaghan O'Neill", netid: "", club: "Ivy", proxNumber: "")
        mockData.append(Meaghan)
        
        let Sumer = Student(name: "Sumer Parikh", netid: "", club: "Cap & Gown", proxNumber: "")
        mockData.append(Sumer)
        
        let James = Student(name: "James Almeida", netid: "", club: "", proxNumber: "")
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
        tableView.reloadData()
    }
    
    @IBAction func pendingButtonPressed(sender: AnyObject) {
        requestSelected = false
        pendingButton.backgroundColor = UIColor.orangeColor()
        requestButton.backgroundColor = UIColor.blackColor()
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
        } else {
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
       
        if requestSelected {
            
        } else {
            
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Accept", style: .Default, handler:{ action in self.exexuteAction(action, indexPath:indexPath)}))
            alert.addAction(UIAlertAction(title: "Reschedule", style: .Default, handler:{ action in self.exexuteAction(action, indexPath:indexPath)}))
            alert.addAction(UIAlertAction(title: "Decline", style: .Default, handler:{ action in self.exexuteAction(action, indexPath:indexPath)}))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func exexuteAction(alert: UIAlertAction!, indexPath: NSIndexPath){
        let response = alert.title!
        print(response)
        print(indexPath.row)
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
    
    
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */

}
