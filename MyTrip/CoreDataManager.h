//
//  CoreDataManager.h
//  DayReminder
//
//  Created by Jiaxin.Li on 1/31/15.
//  Copyright (c) 2015 jl6467. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface CoreDataManager : NSObject

+ (NSEntityDescription *)createEntityDescriptionByName:(NSManagedObjectContext *) context managedEntityName:(NSString *)entityName;

+ (NSSortDescriptor *) createSortDescriptorByName:(NSString *) attributeName;

+ (NSFetchRequest *)createFetchRequest:(NSManagedObjectContext *) context managedEntityName:(NSString *)entityName sortDescriptorNames:(NSArray *)names;

+ (NSFetchRequest *) createFetchRequest:(NSEntityDescription *) entity sortDescriptors:(NSArray *) sorts;

+ (NSFetchedResultsController *) createFetchedResultsController:(NSManagedObjectContext *) context fetchRequest:(NSFetchRequest *) fetchRequest  sectionNameKeyPath:(NSString *) sectionNameKeyPath cacheName:(NSString *) name;

+ (NSManagedObject *) createManagedObjectByName:(NSManagedObjectContext *) context managedObjectName:(NSString *) name;

+ (BOOL)save:(NSManagedObjectContext *) context;

@end
