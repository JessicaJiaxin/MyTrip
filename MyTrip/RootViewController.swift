//
//  RootViewController.swift
//  OnJourney
//
//  Created by Jiaxin.Li on 3/8/15.
//  Copyright (c) 2015 jl6467. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        if self.revealViewController() != nil {
            if let menuButton = self.navigationItem.leftBarButtonItem {
                menuButton.target = self.revealViewController()
                menuButton.action = "revealToggle:"
                self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            }
        }
    }
}
