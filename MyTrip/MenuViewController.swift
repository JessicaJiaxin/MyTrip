//
//  MenuViewController.swift
//  OnJourney
//
//  Created by Jiaxin.Li on 3/8/15.
//  Copyright (c) 2015 jl6467. All rights reserved.
//

import UIKit

class MenuViewController: RootTableViewController {
    
    private let IDENTIFER = "option"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor = UIColor.getColorBYHEX("#666C83")
    }
    
    override func viewWillAppear(animated: Bool) {
        let selectionBackgroundView = UIView()
        selectionBackgroundView.backgroundColor = UIColor.getColorBYHEX("#3E414B")
        
        for var section = 0; section < tableView.numberOfSections(); section++ {
            for var row = 0; row < tableView.numberOfRowsInSection(section); row++ {
                let indexPath = NSIndexPath(forRow: row, inSection: section)
                
                let cell = tableView.cellForRowAtIndexPath(indexPath)!
                cell.selectedBackgroundView = selectionBackgroundView
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)! as UITableViewCell
        
        cell.backgroundColor = UIColor.getColorBYHEX("#3E414B")
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)! as UITableViewCell
        cell.backgroundColor = UIColor.clearColor()
    }
}
