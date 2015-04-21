//
//  WeatherCell.swift
//  OnJourney
//
//  Created by Jiaxin.Li on 3/5/15.
//  Copyright (c) 2015 jl6467. All rights reserved.
//

import UIKit

class WeatherCell: UITableViewCell {

	@IBOutlet var canvas: UIView!
	@IBOutlet var locationLabel: UILabel!
	@IBOutlet var temperatureLabel: UILabel!
	@IBOutlet var temperatureRangeLabel: UILabel!
	@IBOutlet var updatedInfoLabel: UILabel!
	
	@IBOutlet var weatherIcon: UIImageView!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		self.canvas.layer.masksToBounds = false
		self.canvas.layer.cornerRadius = 2.0
		self.canvas.layer.borderColor = UIColor.grayColor().CGColor
		self.canvas.layer.borderWidth = 1.0
		self.canvas.layer.shadowColor = UIColor.grayColor().CGColor
		self.canvas.layer.shadowRadius = 1.5
		self.canvas.layer.shadowOpacity = 0.8
		self.canvas.layer.shadowOffset = CGSizeMake(0, 1)
	}
}
