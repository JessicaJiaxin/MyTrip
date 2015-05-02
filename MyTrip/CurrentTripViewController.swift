//
//  CurrentTripViewController.swift
//  OnJourney
//
//  Created by Jiaxin.Li on 3/5/15.
//  Copyright (c) 2015 jl6467. All rights reserved.
//

import UIKit

class CurrentTripViewController: RootTableViewController, NSFetchedResultsControllerDelegate {
    var tripName: String!
    @IBOutlet var addEventButton: UIBarButtonItem!
    
    var fetchedResultController: NSFetchedResultsController!
    
    @IBOutlet var eventCounter: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.allowsSelectionDuringEditing = true
        
        //get current trip
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let fetchRequest = CoreDataManager.createFetchRequest(context, managedEntityName: "Trip", sortDescriptorNames: ["creationdate"])
        
        let result = context?.executeFetchRequest(fetchRequest, error: nil)
        
        if result!.count > 0 {
            let trip = result![0] as! Trip
            
            self.title = trip.name
            self.tripName = trip.name
            
            self.addEventButton.enabled = true
            
            let nib = UINib(nibName: "EventCell", bundle: nil)
            self.tableView.registerNib(nib, forCellReuseIdentifier: "event")
        }else {
            self.title = "Empty"
            self.tripName = "Empty"
            
            self.addEventButton.enabled = false
            
            let label = UILabel(frame: self.view.frame)
            label.textAlignment = .Center
            label.font = UIFont(name: "AvenirNext-MediumItalic", size: 18)
            label.text = "Go to \"Trip History\" to add your first trip now!"
            
            self.tableView.addSubview(label)
        }
        
        fetchedResultController = self.initialFetchedResultController()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addNewEvent" {
            let viewController = segue.destinationViewController as! AddNewEventViewController
            viewController.tripName = tripName
        }else if segue.identifier == "showContent" {
            let viewController = segue.destinationViewController as! DisplayEventViewController
            let values = sender as! [String]
            viewController.url = values[0]
            viewController.title = values[1]
            viewController.tripName = tripName
        }else if segue.identifier == "editEvent" {
            let viewController = segue.destinationViewController as! EditEventViewController
            let value = sender as! Event
            viewController.event = value
        }
    }

    //pragma mark - Fetched result Controller
    func initialFetchedResultController() -> NSFetchedResultsController {
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let entity = CoreDataManager.createEntityDescriptionByName(context, managedEntityName: "Event")
        let sortDescriptor = CoreDataManager.createSortDescriptorByName("creationdate")
        let fetchRequest = CoreDataManager.createFetchRequest(entity, sortDescriptors: [sortDescriptor])
        
        //add predicate
        let predicate = NSPredicate(format: "tripName = %@", tripName)
        fetchRequest.predicate = predicate
        
        let fetchedResultController = CoreDataManager.createFetchedResultsController(context, fetchRequest: fetchRequest, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self
        
        var error: NSError? = nil
        
        if (!fetchedResultController.performFetch(&error)) {
            abort()
        }
        
        return fetchedResultController
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch (type) {
        case .Insert:
            self.tableView .insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
            break
        case .Delete:
            self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
            break
        case .Move:
            break
        case .Update:
            break
        default:
            return
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        let tableView = self.tableView
        
        switch (type){
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
            break
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            break
        case .Update:
            self.configureCell(self.tableView.cellForRowAtIndexPath(indexPath!) as! EventCell, indexPath: indexPath!)
            break
        case .Move:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
            break
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }
    
    func configureCell(cell: EventCell, indexPath: NSIndexPath) {
        let event = self.fetchedResultController.objectAtIndexPath(indexPath) as! Event
        cell.configEvent(event)
    }
    
    //pragma mark - UITableViewController
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultController.sections![section] as! NSFetchedResultsSectionInfo
        
        eventCounter.title = "\(sectionInfo.numberOfObjects) Events"
        
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let eventCell = tableView.dequeueReusableCellWithIdentifier("event") as! EventCell
        self.configureCell(eventCell, indexPath: indexPath)
        
        return eventCell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 83;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let eventCell = tableView.cellForRowAtIndexPath(indexPath) as! EventCell
        
        if tableView.editing {
            self.performSegueWithIdentifier("editEvent", sender: fetchedResultController.objectAtIndexPath(indexPath))
        }else {
            self.performSegueWithIdentifier("showContent", sender: [eventCell.eventHtmlPath, eventCell.eventName.text])
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.layer.shadowPath = UIBezierPath(rect: cell.frame).CGPath
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            let event = self.fetchedResultController.fetchedObjects![indexPath.row] as! Event
            
            self.fetchedResultController.managedObjectContext.deleteObject(event)
            self.fetchedResultController.managedObjectContext.save(nil)
        }
    }
}
