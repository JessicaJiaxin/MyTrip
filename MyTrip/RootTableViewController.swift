//
//  RootTableViewController.swift
//  OnJourney
//
//  Created by Jiaxin.Li on 3/6/15.
//  Copyright (c) 2015 jl6467. All rights reserved.
//

import UIKit

class RootTableViewController: UITableViewController {
    override func viewDidLoad() {
        
        self.tableView.backgroundColor = UIColor.getColorBYHEX("#F1F1F1")
        
        if (self.navigationItem.rightBarButtonItem != nil) {
            self.navigationItem.rightBarButtonItem = self.editButtonItem()
        }
        
        if self.revealViewController() != nil {
            if let menuButton = self.navigationItem.leftBarButtonItem {
                menuButton.target = self.revealViewController()
                menuButton.action = "revealToggle:"
                self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            }
        }
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        self.tableView.setEditing(editing, animated: animated)
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        if !tableView.editing {
            return .None
        }else {
            return .Delete
        }
    }
}
