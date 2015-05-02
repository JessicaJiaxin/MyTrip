//
//  TripCell.swift
//  OnJourney
//
//  Created by Jiaxin.Li on 3/6/15.
//  Copyright (c) 2015 jl6467. All rights reserved.
//

import UIKit

let formatter = NSDateFormatter()
class EventCell: UITableViewCell {
	
	@IBOutlet var canvas: UIView!
	@IBOutlet var thumbnail: UIImageView!
	@IBOutlet var eventName: UILabel!
	@IBOutlet var creationDate: UILabel!
	
    var eventHtmlPath: String!
    
	override func awakeFromNib() {
		super.awakeFromNib()
        
        formatter.dateFormat = "MM/dd/yyyy HH:mm:ss"
		
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
    
    func configEvent(event: Event) {
        self.eventName.text = event.name
        self.creationDate.text = formatter.stringFromDate(event.creationdate)
        self.thumbnail.image = UIImage(data: event.thumbnail)
        self.eventHtmlPath = event.path
    }
}
