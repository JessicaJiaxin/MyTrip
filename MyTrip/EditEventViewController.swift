//
// Created by Jiaxin.Li on 4/16/15.
// Copyright (c) 2015 jl6467. All rights reserved.
//

import Foundation
import MobileCoreServices

class EditEventViewController: ZSSRichTextEditor, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var saveButton: UIBarButtonItem!

    var event: Event!

    var basePath: String!
    var absolutePath: String!

    var eventTitle: String!
    let newTitle = UITextField()
    
    var imageCache = [String]()

    override func viewDidLoad() {

        self.basePath = DocumentHelper.getDocumentDirectory().stringByAppendingPathComponent(self.event.tripName)
        self.absolutePath = self.basePath.stringByAppendingPathComponent(event.path)

        self.baseURL = NSURL(fileURLWithPath: basePath)

        super.viewDidLoad()
        
        let content = String(contentsOfURL: NSURL(fileURLWithPath: absolutePath)!, encoding: NSUTF8StringEncoding, error: nil)
        self.setHTML(content)
        
        self.navigationController?.navigationBar.translucent = false
        
        newTitle.placeholder = "Add Title Here"
        newTitle.textAlignment = .Center
        newTitle.font = UIFont(name: "AvenirNext-DemiBold", size: 18)
        
        self.navigationItem.titleView = newTitle
        newTitle.sizeToFit()
        newTitle.text = event.name
        
        //set observer of textfield
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didEditText", name: UITextFieldTextDidChangeNotification, object: newTitle)
        
        //create custom button
        let imageButton = ZSSBarButtonItem(image: UIImage(named: "addImage"), style: .Plain, target: self, action: "addImageFromLocal")
        self.addCustomToolbarItem(imageButton)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.toolbarHidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.toolbarHidden = false
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
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
    
    //Pragma mark - UIImagePickerControllerDelegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        let pngData = UIImagePNGRepresentation(image)
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        let imageName = formatter.stringFromDate(NSDate()).stringByAppendingPathExtension("png")
        let imagePath = basePath.stringByAppendingPathComponent(imageName!)
        pngData.writeToFile(imagePath, atomically: true)
        
        imageCache.append(imageName!)
        
        let htmlSegment = "<img src=\"\(imageName!)\" width=\"\(UIScreen.mainScreen().bounds.width - 5)\" height = \"\(UIScreen.mainScreen().bounds.width - 5)\">"
        
        self.focusTextEditor()
        self.insertHTML(htmlSegment)
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveEvent(sender: AnyObject) {
        //save the html to document path
        let html = self.getHTML()
        
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        html.writeToFile(absolutePath, atomically: true, encoding: NSUTF8StringEncoding, error: nil)
        
        //clear all useless picture
        var found = false
        for imageName in imageCache {
            let imagePath = basePath.stringByAppendingPathComponent(imageName)
            if html.rangeOfString(imageName) == nil {
                DocumentHelper.removeFileAtPath(imagePath)
            }else if !found {
                
                //create thumbnail with image
                let image = UIImage(contentsOfFile: imagePath)
                let thumbnailSize = CGSizeMake(60, 60)
                
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
        println(newTitle.text)
        
        //save the event to core data
        event.name = newTitle.text
        CoreDataManager.save(context)
        
        //dismiss viewController
        self.navigationController?.popViewControllerAnimated(true)
    }
}
