//
//  TripHistoryViewController.swift
//  OnJourney
//
//  Created by Jiaxin.Li on 3/26/15.
//  Copyright (c) 2015 jl6467. All rights reserved.
//

import UIKit

class TripHistoryViewController: RootTableViewController, NSFetchedResultsControllerDelegate {
    
    lazy var fetchedResultController: NSFetchedResultsController = self.initialFetchedResultController()
    lazy var dateFormatter = NSDateFormatter()
    lazy var tripNames: [String] = self.getFetchedTripNames()
    
    @IBOutlet var tripIndicator: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
		let tripCellNib = UINib(nibName: "TripCell", bundle: nil)
        tableView.registerNib(tripCellNib, forCellReuseIdentifier: "trip")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addNewTrip" {
            let viewController = segue.destinationViewController as! AddNewTripViewController
            viewController.tripNames = tripNames
        } else if segue.identifier == "showEvents" {
            let viewController = segue.destinationViewController as! EventsListViewController
            viewController.tripName = sender as! String
        }
    }
    
    //configure trip cell
    func configureCell(cell: TripCell, indexPath: NSIndexPath) {
        let data = self.fetchedResultController.objectAtIndexPath(indexPath) as! Trip
        cell.cover.image = UIImage(data: data.cover)
        cell.tripName.text = data.name
        cell.tripNotes.text = data.notes
        cell.lastModifiedDate.text = dateFormatter.stringFromDate(data.creationdate)
    }
    
    //pragma mark - UITableViewController Datasource & Delegate
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.fetchedResultController.sections!.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultController.sections![section] as! NSFetchedResultsSectionInfo
        tripIndicator.title = "\(sectionInfo.numberOfObjects) Trips"
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tripCell = tableView.dequeueReusableCellWithIdentifier("trip") as! TripCell
        self.configureCell(tripCell, indexPath: indexPath)
        
        return tripCell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 150
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! TripCell
        
        self.performSegueWithIdentifier("showEvents", sender: cell.tripName.text)
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.layer.shadowPath = UIBezierPath(rect: cell.frame).CGPath
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            let trip = self.fetchedResultController.fetchedObjects![indexPath.row] as! Trip
            
            let path = DocumentHelper.createDirectoryByName(trip.path, parentDir: DocumentHelper.getDocumentDirectory())
            println(trip.path)
            println(path)
            
            DocumentHelper.deleteDirectoryAtPath(path, withCasecade: true)
            
            self.fetchedResultController.managedObjectContext.deleteObject(trip)
        }
    }
    
    //pragma mark - Fetched result Controller
    func initialFetchedResultController() -> NSFetchedResultsController {
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let entity = CoreDataManager.createEntityDescriptionByName(context, managedEntityName: "Trip")
        let sortDescriptor = CoreDataManager.createSortDescriptorByName("creationdate")
        let fetchRequest = CoreDataManager.createFetchRequest(entity, sortDescriptors: [sortDescriptor])
        
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
            self.configureCell(self.tableView.cellForRowAtIndexPath(indexPath!) as! TripCell, indexPath: indexPath!)
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
    
    //pragma mark - assistant method
    func getFetchedTripNames() -> [String] {
        var result = [String]()
        
        if let trips = self.fetchedResultController.fetchedObjects as? [Trip] {
            for trip in trips {
                result.append(trip.name)
            }
        }
        
        return result
    }
}
