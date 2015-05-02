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
        self.canvas.layer.cornerRadius = 2.3
        self.canvas.layer.backgroundColor = UIColor.getColorBYHEX("#FCFCFC").CGColor
        self.canvas.layer.borderColor = UIColor.getColorBYHEX("#BBBBBB").CGColor
        self.canvas.layer.borderWidth = 0.8
        self.canvas.layer.shadowColor = UIColor.grayColor().CGColor
        self.canvas.layer.shadowRadius = 0.5
        self.canvas.layer.shadowOpacity = 2
        self.canvas.layer.shadowOffset = CGSizeMake(0, 1)
    }
}
