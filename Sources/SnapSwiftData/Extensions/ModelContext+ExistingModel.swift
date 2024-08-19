//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import Foundation
import SwiftData

public extension ModelContext {
	
	/// Returns the `PersistentModel` for a given `PersistentIdentifier`.
	///
	/// In contrast to `.model(for:)` this will return `nil` if no object is found.
	/// In contrast to `.registeredModel(for:)`, it will fetch the object if its available but not registered in the context yet.
	func existingModel<T>(for objectID: PersistentIdentifier) throws -> T? where T: PersistentModel {
		
		if let registered: T = registeredModel(for: objectID) {
			return registered
		}
		
		let fetchDescriptor = FetchDescriptor<T>(
			predicate: #Predicate {
				$0.persistentModelID == objectID
			}
		)
		
		return try fetch(fetchDescriptor).first
		
	}
	
}
