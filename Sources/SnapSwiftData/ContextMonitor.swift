//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import Foundation
import SwiftData
import CoreData
import Combine
import OSLog

public class ContextMonitor {
	
	public let context: ModelContext

	public typealias ChangeHandler = @Sendable (NotificationCenter.Publisher.Output) -> Void
	private let onChange: ChangeHandler?
	
	private var subscriptions = Set<AnyCancellable>()

	public init(context: ModelContext, onChange: ChangeHandler?) {
		self.context = context
		self.onChange = onChange

		NotificationCenter.default.publisher(
			for: .NSManagedObjectContextObjectsDidChange,
			object: context.managedObjectContext
		)
		.sink { [weak self] output in
			
			Logger.monitorContextChange.info("Context did change: \(output)")
			
			onChange?(output)
			
			if let userInfo = output.userInfo {
				self?.handle(userInfo: userInfo)
			}
			
		}
		.store(in: &subscriptions)
	}
	
	
	// MARK: Change Stream
	
	private func handle(userInfo: [AnyHashable : Any]) {
		var identifiers: [PersistentIdentifier] = []
		
		if let updated = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject> {
			for identifier in updated.compactMap({ $0.objectID.persistentIdentifier}) {
				identifiers.append(identifier)
			}
		}
		
		if let inserted = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject> {
			let filtered = inserted.filter({ !["NSCKImportOperation", "NSCKEvent", "NSCKHistoryAnalyzerState", "NSCKRecordMetadata"].contains($0.entity.managedObjectClassName) })
			guard filtered.count > 0 else { return }
			
			for identifier in filtered.compactMap({ $0.objectID.persistentIdentifier}) {
				identifiers.append(identifier)
			}
		}
		
		if let deleted = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject> {
			for identifier in deleted.compactMap({ $0.objectID.persistentIdentifier}) {
				identifiers.append(identifier)
			}
		}
		
		if let refreshed = userInfo[NSRefreshedObjectsKey] as? Set<NSManagedObject> {
			for identifier in refreshed.compactMap({ $0.objectID.persistentIdentifier}) {
				identifiers.append(identifier)
			}
		}
		
		if let invalidated = userInfo[NSInvalidatedObjectsKey] as? Set<NSManagedObject> {
			for identifier in invalidated.compactMap({ $0.objectID.persistentIdentifier}) {
				identifiers.append(identifier)
			}
		}
		
		for identifier in identifiers {
			continuation?.yield(identifier)
		}
	}
	
	public lazy var changeStream: AsyncStream<PersistentIdentifier> = {
		AsyncStream { (continuation: AsyncStream<PersistentIdentifier>.Continuation) -> Void in
			self.continuation = continuation
		}
	}()
	
	private var continuation: AsyncStream<PersistentIdentifier>.Continuation?
	
}
