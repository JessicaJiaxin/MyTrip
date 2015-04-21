//
//  CoreDataManager.m
//  DayReminder
//
//  Created by Jiaxin.Li on 1/31/15.
//  Copyright (c) 2015 jl6467. All rights reserved.
//
#import "CoreDataManager.h"

@implementation CoreDataManager

#pragma mark - entityDescription

+ (NSEntityDescription *)createEntityDescriptionByName:(NSManagedObjectContext *) context managedEntityName:(NSString *)entityName {
	if (entityName == nil || [entityName isEqualToString:@""]) {
		return nil;
	}
	
	NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
	
	return entity;
}

#pragma mark - sortDescription

+ (NSSortDescriptor *)createSortDescriptorByName:(NSString *)attributeName {
	if (attributeName == nil || [attributeName isEqualToString:@""]) {
		return nil;
	}
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:attributeName ascending:NO];
	
	return sortDescriptor;
}

#pragma mark - fetchRequest

+ (NSFetchRequest *)createFetchRequest:(NSManagedObjectContext *) context managedEntityName:(NSString *)entityName sortDescriptorNames:(NSArray *)names {
	
    NSEntityDescription *entity = [self createEntityDescriptionByName:context managedEntityName:entityName];
	
	NSMutableArray *sorts = [[NSMutableArray alloc] init];
	for (NSString *sortName in names) {
		[sorts addObject:[self createSortDescriptorByName:sortName]];
	}
	
	return [self createFetchRequest:entity sortDescriptors:sorts];
}

+ (NSFetchRequest *)createFetchRequest:(NSEntityDescription *)entity sortDescriptors:(NSArray *)sorts {
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	
	[fetchRequest setFetchBatchSize:20];
	
	[fetchRequest setEntity:entity];
	
	if (sorts != nil) {
		[fetchRequest setSortDescriptors:sorts];
	}
	
	return fetchRequest;
}

#pragma mark - fetchedResultsController

+ (NSFetchedResultsController *) createFetchedResultsController:(NSManagedObjectContext *) context fetchRequest:(NSFetchRequest *) fetchRequest  sectionNameKeyPath:(NSString *) sectionNameKeyPath cacheName:(NSString *) name {
	
	NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:sectionNameKeyPath cacheName:name];
	
	return controller;
}

#pragma mark - managedObject

+ (NSManagedObject *) createManagedObjectByName:(NSManagedObjectContext *) context managedObjectName:(NSString *) name {
    NSEntityDescription *entity = [self createEntityDescriptionByName:context managedEntityName:name];
	
	NSManagedObject *object = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
	
	return object;
}

+ (BOOL)save:(NSManagedObjectContext *) context {
    return [context save:nil];
}

@end
