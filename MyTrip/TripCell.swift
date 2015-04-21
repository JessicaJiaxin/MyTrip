//
//  TripCell.swift
//  OnJourney
//
//  Created by Jiaxin.Li on 3/26/15.
//  Copyright (c) 2015 jl6467. All rights reserved.
//

import UIKit

class TripCell: UITableViewCell {
    @IBOutlet var canvas: UIView!
    @IBOutlet var cover: UIImageView!
    @IBOutlet var tripName: UILabel!
    @IBOutlet var tripNotes: UILabel!
    @IBOutlet var lastModifiedDate: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.canvas.layer.masksToBounds = false
        self.canvas.layer.cornerRadius = 2.0
        self.canvas.layer.borderColor = UIColor.grayColor().CGColor
        self.canvas.layer.borderWidth = 1.0
        self.canvas.layer.shadowColor = UIColor.blackColor().CGColor
        self.canvas.layer.shadowRadius = 1.5
        self.canvas.layer.shadowOpacity = 2
        self.canvas.layer.shadowOffset = CGSizeMake(0, 1)
    }
}
