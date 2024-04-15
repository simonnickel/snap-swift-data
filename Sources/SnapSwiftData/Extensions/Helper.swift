//
//  Helper.swift
//  SnapSwiftData
//
//  Created by Simon Nickel on 02.02.24.
//

import Foundation

/// Returns the value of a child property of an object using reflection.
///
/// - Parameters:
///   - object: The object to inspect.
///   - childName: The name of the child property to retrieve.
/// - Returns: The value of the child property, or nil if it does not exist.
internal func getMirrorChildValue(of object: Any, childName: String) -> Any? {
	
	guard let child = Mirror(reflecting: object).children.first(where: { $0.label == childName }) else {
		return nil
	}

	return child.value
	
}
