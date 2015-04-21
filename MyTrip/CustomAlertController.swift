//
//  CustomAlertController.swift
//  OnJourney
//
//  Created by Jiaxin.Li on 3/23/15.
//  Copyright (c) 2015 jl6467. All rights reserved.
//

import UIKit

class CustomAlertController {
	
	class func createStandardImagePickupActionSheet(title: String, message: String?, cameraAction: (UIAlertAction!)-> Void, libraryAction: (UIAlertAction!)-> Void) -> UIAlertController {
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .ActionSheet)
		
		let cameraItem = UIAlertAction(title: "Camera", style: .Default, handler: cameraAction)
		
		let libraryItem = UIAlertAction(title: "Photos Library", style: .Default, handler: libraryAction)
		
		let cancelItem = UIAlertAction(title: "Cancel", style: .Cancel) { (canceled) -> Void in
			alertController.dismissViewControllerAnimated(true, completion: nil)
		}
		
		alertController.addAction(cameraItem)
		alertController.addAction(libraryItem)
		alertController.addAction(cancelItem)
		
		return alertController
	}
	
	class func createStandardAlertView(title: String, message: String?) -> UIAlertController {
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
		
		let okItem = UIAlertAction(title: "OK", style: .Cancel) { (canceled) -> Void in
			alertController.dismissViewControllerAnimated(true, completion: nil)
		}
		
		alertController.addAction(okItem)
		
		return alertController
		
	}
}
