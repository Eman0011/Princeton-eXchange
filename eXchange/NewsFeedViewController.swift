//
//  NewsFeedViewController.swift
//  eXchange
//
//  Created by Emanuel Castaneda on 3/21/16.
//  Copyright © 2016 Emanuel Castaneda. All rights reserved.
//

import UIKit

class NewsFeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var eXchangeBanner: UIImageView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var friendButton: UIButton!
    @IBOutlet var myClubButton: UIButton!
    
    var friendButtonSelected = true
    
    var mockMeals: [Meal] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eXchangeBanner.image = UIImage(named:"exchange_banner")!
        self.tableView.rowHeight = 100.0
        
        friendButton.layer.cornerRadius = 5
        friendButton.backgroundColor = UIColor.orangeColor()
        myClubButton.layer.cornerRadius = 5
        myClubButton.backgroundColor = UIColor.blackColor()
        
        loadMockData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }
    
    func loadMockData() {
        let Emanuel = Student(name: "Emanuel Castaneda", netid: "emanuelc", club: "Cannon", proxNumber: "960755555")
        let Danielle = Student(name: "Danielle Pintz", netid: "", club: "Independent", proxNumber: "")
        let Meaghan = Student(name: "Meaghan O'Neill", netid: "", club: "Ivy", proxNumber: "")
        let Sumer = Student(name: "Sumer Parikh", netid: "", club: "Cap & Gown", proxNumber: "")
        //        let James = Student(name: "James Almeida", netid: "", club: "", proxNumber: "")
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MM-dd-yyyy, hh:mm a"
        formatter.AMSymbol = "am"
        formatter.PMSymbol = "pm"
        
        let today = NSDate()
        print(formatter.stringFromDate(today))
        
        let x1 = eXchange(host: Emanuel, guest: Sumer,  type: "Lunch")
        x1.meal1.date = formatter.dateFromString("3-7-2016, 1:30 pm")!
        x1.completeExchange(formatter.dateFromString("3-22-2016, 12:00 pm")!, type: "Lunch", host: Sumer, guest: Emanuel)
        x1.meal2?.date = formatter.dateFromString("3-22-2016, 12:00 pm")!
        mockMeals.append(x1.meal1)
        mockMeals.append(x1.meal2!)
        
        let x2 = eXchange(host: Emanuel, guest: Meaghan, type: "Dinner")
        x2.meal1.date = formatter.dateFromString("3-12-2016, 7:30 pm")!
        x2.completeExchange(formatter.dateFromString("3-16-2016, 6:30 pm")!, type: "Dinner", host: Meaghan, guest: Emanuel)
        mockMeals.append(x2.meal1)
        mockMeals.append(x2.meal2!)
        
        let x3 = eXchange(host: Emanuel, guest: Danielle, type: "Lunch")
        x3.meal1.date = formatter.dateFromString("3-14-2016, 1:30 pm")!
        mockMeals.append(x3.meal1)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Button Actions
    @IBAction func friendButtonPressed(sender: AnyObject) {
        friendButtonSelected = true
        friendButton.backgroundColor = UIColor.orangeColor()
        myClubButton.backgroundColor = UIColor.blackColor()
        tableView.reloadData()
    }
    
    @IBAction func myClubButtonPressed(sender: AnyObject) {
        friendButtonSelected = false
        myClubButton.backgroundColor = UIColor.orangeColor()
        friendButton.backgroundColor = UIColor.blackColor()
        tableView.reloadData()
    }

    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mockMeals.count
    }
    
    
    /* NOTE: uses the eXchangeTableViewCell layout for simplicity. nameLabel serves as description label, and clubLabel serves as information label */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.numberOfLines = 0
        let meal = mockMeals[indexPath.row]
        cell.imageView?.image = UIImage(named: meal.host.club + ".jpg")
        cell.textLabel!.text = "\(meal.host.name) and \(meal.guest.name) eXchanged for \(meal.type) at \(meal.host.club)"
        return cell
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