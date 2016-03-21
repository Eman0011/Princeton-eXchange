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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eXchangeBanner.image = UIImage(named:"exchange_banner")!
        self.tableView.rowHeight = 100.0
        
        friendButton.layer.cornerRadius = 5
        friendButton.backgroundColor = UIColor.orangeColor()
        myClubButton.layer.cornerRadius = 5
        myClubButton.backgroundColor = UIColor.blackColor()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
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
        return 0
    }
    
    
    /* NOTE: uses the eXchangeTableViewCell layout for simplicity. nameLabel serves as description label, and clubLabel serves as information label */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("exchangeCell", forIndexPath: indexPath) as! eXchangeTableViewCell
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