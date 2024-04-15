//
//  ModelContext+CoreData.swift
//  SnapSwiftData
//
//  Created by Simon Nickel on 02.02.24.
//

import SwiftData
import CoreData
import OSLog

/// Accessing underlying CoreData implementation details from SwiftData.
public extension ModelContext {
	
	/// Computed property to access the underlying NSManagedObjectContext.
	var managedObjectContext: NSManagedObjectContext? {
		guard let managedObjectContext = getMirrorChildValue(of: self, childName: "_nsContext") as? NSManagedObjectContext else {
			Logger.snapSwiftData.error("Failed to create NSManagedObjectContext from ModelContext.")
			return nil
		}
		return managedObjectContext
	}
	
	/// Computed property to access the NSPersistentStoreCoordinator.
	var coordinator: NSPersistentStoreCoordinator? {
		managedObjectContext?.persistentStoreCoordinator
	}
	
}
