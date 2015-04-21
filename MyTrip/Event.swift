//
//  Event.swift
//  OnJourney
//
//  Created by Jiaxin.Li on 4/16/15.
//  Copyright (c) 2015 jl6467. All rights reserved.
//

import Foundation
import CoreData

class Event: NSManagedObject {

    @NSManaged var creationdate: NSDate
    @NSManaged var latitude: NSNumber
    @NSManaged var location: String
    @NSManaged var longitude: NSNumber
    @NSManaged var name: String
    @NSManaged var path: String
    @NSManaged var thumbnail: NSData
    @NSManaged var tripName: String

}
