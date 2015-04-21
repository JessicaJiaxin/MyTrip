//
// Created by Jiaxin.Li on 4/16/15.
// Copyright (c) 2015 jl6467. All rights reserved.
//

import Foundation
import MobileCoreServices

class AddNewEventViewController: ZSSRichTextEditor, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var saveButton: UIBarButtonItem!
    var tripName: String!
    var eventTitle: String!
    let newTitle = UITextField()
    
    var imageCache = [String]()
    
    var filePath: String!

    override func viewDidLoad() {
        filePath = DocumentHelper.getDocumentDirectory().stringByAppendingPathComponent(tripName)
        self.baseURL = NSURL(fileURLWithPath: filePath, isDirectory: true)
        
        super.viewDidLoad()
    
        self.navigationController?.navigationBar.translucent = false
        
        newTitle.placeholder = "Add Title Here"
        newTitle.textAlignment = .Center
        newTitle.font = UIFont(name: "AvenirNext-DemiBold", size: 18)
        
        self.navigationItem.titleView = newTitle
        newTitle.sizeToFit()
        
        saveButton.enabled = false
        //set observer of textfield
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didEditText", name: UITextFieldTextDidChangeNotification, object: newTitle)
        
        //create custom button
        let imageButton = ZSSBarButtonItem(image: UIImage(named: "addImage"), style: .Plain, target: self, action: "addImageFromLocal")
        self.addCustomToolbarItem(imageButton)

        self.toolbarItemTintColor = UIColor.blackColor()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.newTitle.becomeFirstResponder()
    }
    
    func didEditText () {
        if (newTitle.text.isEmpty) {
            saveButton.enabled = false
        }else {
            saveButton.enabled = true
        }
    }
    
    func addImageFromLocal() {
        
        let imageViewController = UIImagePickerController()
        imageViewController.delegate = self
        imageViewController.allowsEditing = true
        
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
                    imageViewController.sourceType = .PhotoLibrary
                    imageViewController.mediaTypes = [kUTTypeImage]
                    
                    self.presentViewController(imageViewController, animated: true, completion: nil)
                }
        }
        
        self.presentViewController(menuController, animated: true, completion: nil)
        
    }

    
    func insertLocation () {
        
    }
    
    //Pragma mark - UIImagePickerControllerDelegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        let pngData = UIImagePNGRepresentation(image)
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        let imageName = formatter.stringFromDate(NSDate()).stringByAppendingPathExtension("png")
        let imagePath = filePath.stringByAppendingPathComponent(imageName!)
        pngData.writeToFile(imagePath, atomically: true)
        
        imageCache.append(imageName!)

        let htmlSegment = "<img src=\"\(imageName!)\" width=\"\(UIScreen.mainScreen().bounds.width - 5)\" height = \"\(UIScreen.mainScreen().bounds.width - 5)\">"
        
        self.focusTextEditor()
        self.baseURL = NSURL(fileURLWithPath: filePath)
        self.insertHTML(htmlSegment)
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveEvent(sender: AnyObject) {
        //save the html to document path
        let html = self.getHTML()
        let fileName = newTitle.text
        
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let event = CoreDataManager.createManagedObjectByName(context, managedObjectName: "Event") as! Event
        
        let htmlPath = filePath.stringByAppendingPathComponent(fileName.stringByAppendingPathExtension("html")!)
        
        html.writeToFile(htmlPath, atomically: true, encoding: NSUTF8StringEncoding, error: nil)
        
        //clear all useless picture
        var found = false
        for imageName in imageCache {
            let imagePath = filePath.stringByAppendingPathComponent(imageName)
            if html.rangeOfString(imageName) == nil {
                DocumentHelper.removeFileAtPath(imagePath)
            }else if !found {
                
                //create thumbnail with image
                let image = UIImage(contentsOfFile: imagePath)
                let thumbnailSize = CGSizeMake(75, 75)
                
                UIGraphicsBeginImageContext(thumbnailSize)
                image?.drawInRect(CGRectMake(0, 0, thumbnailSize.width, thumbnailSize.height))
                let thumbnail = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                if thumbnail != nil {
                    event.thumbnail = UIImagePNGRepresentation(thumbnail)
                }
                
                found = true
            }
        }
        
        //default thumbnail
        if !found {
            
        }
        
        //save the event to core data
        event.tripName = tripName
        event.name = newTitle.text
        event.creationdate = NSDate()
        event.path = fileName.stringByAppendingPathExtension("html")!
        
        CoreDataManager.save(context)
        
        //dismiss viewController
        self.navigationController?.popViewControllerAnimated(true)
    }
}
