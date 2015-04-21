//
//  EventsListViewController.swift
//  OnJourney
//
//  Created by Jiaxin.Li on 4/16/15.
//  Copyright (c) 2015 jl6467. All rights reserved.
//

import UIKit

class EventsListViewController: RootTableViewController, NSFetchedResultsControllerDelegate {
    var tripName: String!
    
    var fetchedResultController: NSFetchedResultsController!
    
    @IBOutlet var eventCounter: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = tripName;
        
        let nib = UINib(nibName: "EventCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "event")
        
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
        return 103;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let eventCell = tableView.cellForRowAtIndexPath(indexPath) as! EventCell
        
        self.performSegueWithIdentifier("showContent", sender: [eventCell.eventHtmlPath, eventCell.eventName.text])
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
