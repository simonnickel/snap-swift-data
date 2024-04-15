//
//  NSManagedObjectID+PersistentIdentifier.swift
//	SnapSwiftData
//
//  Created by Simon Nickel on 02.02.24.
//

import Foundation
import CoreData
import SwiftData
import OSLog

public extension NSManagedObjectID {
	
	/// Compute PersistentIdentifier from NSManagedObjectID
	var persistentIdentifier: PersistentIdentifier? {
		
		guard let storeIdentifier, let entityName = entity.name else { return nil }
		
		let json = PersistentIdentifierJSON(
			implementation: .init(
				primaryKey: primaryKey,
				uriRepresentation: uriRepresentation(),
				isTemporary: isTemporaryID,
				storeIdentifier: storeIdentifier,
				entityName: entityName
			)
		)
		do {
			let encoder = JSONEncoder()
			let data = try encoder.encode(json)
			
			let decoder = JSONDecoder()
			return try decoder.decode(PersistentIdentifier.self, from: data)
		} catch {
			Logger.snapSwiftData.error("Failed to Decode PersistentIdentifier: \(error)")
			return nil
		}
		
	}

	// Primary key is last path component of URI
	var primaryKey: String {
		uriRepresentation().lastPathComponent
	}

	// Store identifier is host of URI
	var storeIdentifier: String? {
		guard let identifier = uriRepresentation().host() else { return nil }
		return identifier
	}
}


// MARK: - PersistentIdentifier

extension PersistentIdentifier {
	
	public func jsonRepresentation() -> PersistentIdentifierJSON.Implementation? {
		guard let data = try? JSONEncoder().encode(self),
			  let persistendIdentifierJSON = try? JSONDecoder().decode(PersistentIdentifierJSON.self, from: data)
		else { return  nil }
		
		return persistendIdentifierJSON.implementation
	}
	
}


// MARK: - PersistentIdentifierJSON

// Model to represent identifier implementation as JSON
public struct PersistentIdentifierJSON: Codable {
	
	public struct Implementation: Codable {
		public var primaryKey: String
		public var uriRepresentation: URL
		public var isTemporary: Bool
		public var storeIdentifier: String
		public var entityName: String
	}

	public var implementation: Implementation
	
}
