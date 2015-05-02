//
//  AddNewTripViewController.swift
//  OnJourney
//
//  Created by Jiaxin.Li on 3/21/15.
//  Copyright (c) 2015 jl6467. All rights reserved.
//

import UIKit
import MobileCoreServices

class AddNewTripViewController: RootViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ImageCropViewControllerDelegate, NoteInputAccessoryViewDelegate, UITextFieldDelegate {
	
	@IBOutlet var titileArea: UIView!
	@IBOutlet var titleInput: UITextField!
	@IBOutlet var noteInput: PlaceholderTextView!
	@IBOutlet var cover: UIImageView!
	@IBOutlet var saveButton: UIBarButtonItem!
    
    var tripNames: [String]!
	
	var coverImage: UIImage!
	var coverSize: CGSize!
	
	override func viewDidLoad() {
		super.viewDidLoad()
        
        self.titleInput.delegate = self
		
		saveButton.enabled = false
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "textFieldDidChange", name: UITextFieldTextDidChangeNotification, object: titleInput)
		
		cover.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "openAddCoverMenu"))

        //create inputAccessoryView
        createInputAccessoryViewForNoteInput()
	}
	
	func textFieldDidChange() {
		if titleInput.text.isEmpty {
			saveButton.enabled = false
		}else {
			saveButton.enabled = true
		}
	}
	
	func openAddCoverMenu() {
		
		let imageViewController = UIImagePickerController()
		imageViewController.delegate = self
		
		let menuController = CustomAlertController.createStandardImagePickupActionSheet("Select Image", message: nil, cameraAction: { (camera) -> Void in
			
			if UIImagePickerController.isSourceTypeAvailable(.Camera) {
				imageViewController.sourceType = .Camera
				imageViewController.mediaTypes = [kUTTypeImage]
				
				self.presentViewController(imageViewController, animated: true, completion: nil)
			}else {
				self.presentViewController(CustomAlertController.createStandardAlertView("Error!", message: "Device doesn't have Camera."), animated: true, completion: nil)
			}
			
		}) { (library) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
                imageViewController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
                imageViewController.mediaTypes = [kUTTypeImage]
                
                self.presentViewController(imageViewController, animated: true, completion: nil)
            }
		}
		
		self.presentViewController(menuController, animated: true, completion: nil)
		
	}

    func createInputAccessoryViewForNoteInput() {
        let nibs = NSBundle.mainBundle().loadNibNamed("NoteInputAccessoryView", owner: self, options: nil)
        let view = nibs[0] as! NoteInputAccessoryView
        view.delegate = self
        noteInput.inputAccessoryView = view
    }
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		self.navigationController?.toolbarHidden = true
		
		//set title interface
		titileArea.layer.masksToBounds = false
		titileArea.layer.backgroundColor = UIColor.whiteColor().CGColor
		titileArea.layer.cornerRadius = 2.0
		titileArea.layer.borderColor = UIColor.grayColor().CGColor
		titileArea.layer.borderWidth = 1.0
		titileArea.layer.shadowColor = UIColor.grayColor().CGColor
		titileArea.layer.shadowRadius = 1.5
		titileArea.layer.shadowOpacity = 0.8
		titileArea.layer.shadowOffset = CGSizeMake(0, 1)
		
		
		//set note interface
        noteInput.clipsToBounds = true
		noteInput.layer.masksToBounds = false
		noteInput.layer.backgroundColor = UIColor.whiteColor().CGColor
		noteInput.layer.cornerRadius = 2.0
		noteInput.layer.borderColor = UIColor.grayColor().CGColor
		noteInput.layer.borderWidth = 1.0
		noteInput.layer.shadowColor = UIColor.grayColor().CGColor
		noteInput.layer.shadowRadius = 1.5
		noteInput.layer.shadowOpacity = 0.8
		noteInput.layer.shadowOffset = CGSizeMake(0, 1)
		
		//set cover interface
		cover.layer.masksToBounds = false
		cover.layer.backgroundColor = UIColor.whiteColor().CGColor
		cover.layer.cornerRadius = 2.0
		cover.layer.borderColor = UIColor.grayColor().CGColor
		cover.layer.borderWidth = 1.0
		cover.layer.shadowColor = UIColor.grayColor().CGColor
		cover.layer.shadowRadius = 1.5
		cover.layer.shadowOpacity = 0.8
		cover.layer.shadowOffset = CGSizeMake(0, 1)

	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		titleInput.layer.shadowPath = UIBezierPath(rect: self.titleInput.bounds).CGPath
		noteInput.layer.shadowPath = UIBezierPath(rect: self.noteInput.bounds).CGPath
		cover.layer.shadowPath = UIBezierPath(rect: self.cover.bounds).CGPath
		
		//get the actual cropAreaSize
		coverSize = cover.frame.size
	}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		
		self.navigationController?.toolbarHidden = false
	}
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField == titleInput) {
            self.noteInput.becomeFirstResponder()
        }
        return true
    }
	
	//Pragma mark - UIImagePickerControllerDelegate
	
	func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
		picker.dismissViewControllerAnimated(true, completion: nil)
		
        self.coverImage = picker.sourceType == .Camera ? image : nil
		
		let imageCropViewController: ImageCropViewController = ImageCropViewController(image: image)
		imageCropViewController.delegate = self
		imageCropViewController.blurredBackground = true
		imageCropViewController.cropArea = coverSize
		
		self.navigationController?.pushViewController(imageCropViewController, animated: true)
	}
	
	//Pragma mark - ImageCropViewControllerDelegate
	
	func ImageCropViewControllerDidEdit(controller: UIViewController!, didFinishCroppingImage croppedImage: UIImage!) {
		
        if self.coverImage != nil {
            UIImageWriteToSavedPhotosAlbum(self.coverImage, self, nil, nil)
        }
		
		self.cover.image = croppedImage
		self.coverImage = croppedImage
		
		self.navigationController?.popViewControllerAnimated(true)
	}
	
	func ImageCropViewControllerDidCancel(controller: UIViewController!) {
		self.navigationController?.popViewControllerAnimated(true)
	}
    
    //Pragma mark - NoteInputAccessoryViewDelegate
    func didHideKeyboard(hideKeyboard: UIButton) {
        noteInput.resignFirstResponder()
    }
	
	@IBAction func saveClicked(sender: AnyObject) {
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let trip = CoreDataManager.createManagedObjectByName(context, managedObjectName: "Trip") as! Trip
        trip.name = titleInput.text
        trip.notes = noteInput.text
        trip.creationdate = NSDate()
        if coverImage != nil {
            trip.cover = UIImagePNGRepresentation(coverImage)
        }
        trip.path = trip.name
        
        //check if name is unique
        if !checkUniqueName(trip.name) {
            self.presentViewController(CustomAlertController.createStandardAlertView("Opps!", message: "Trip already exists."), animated: true, completion: nil)
            return
        }
        
        if CoreDataManager.save(context) {
            let path = DocumentHelper.createDirectoryByName(trip.name, parentDir: DocumentHelper.getDocumentDirectory())
            
            println(path)
            
            DocumentHelper.createDirectoryAtPath(path)
            self.navigationController?.popViewControllerAnimated(true)
        }
	}
    
    func checkUniqueName(checkedName: String) -> Bool {
        for name in tripNames {
            if name == checkedName {
                return false
            }
        }
        
        return true
    }
}
