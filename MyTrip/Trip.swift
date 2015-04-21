//
//  Trip.swift
//  OnJourney
//
//  Created by Jiaxin.Li on 3/27/15.
//  Copyright (c) 2015 jl6467. All rights reserved.
//

import Foundation
import CoreData

class Trip: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var notes: String
    @NSManaged var creationdate: NSDate
    @NSManaged var cover: NSData
    @NSManaged var path: String

}
