//
//  PersistentHistoryMonitor.swift
//  SnapSwiftData
//
//  Created by Simon Nickel on 08.02.24.
//

import Foundation
import SwiftData

public final class PersistentHistoryMonitor {
		
	private let modelContainer: ModelContainer
	
	private let monitor: PersistentHistoryMonitorActor
	
	/// An `AsyncStream` to stream all `PersistentIdentifier` that are handled by `PersistentHistoryTracking` (send via  `NSPersistentStoreRemoteChange` notification).
	public let remoteChangeStream: AsyncStream<PersistentIdentifier>
	
	private let continuation: AsyncStream<PersistentIdentifier>.Continuation?
	
	public init(modelContainer: ModelContainer, excludeAuthors: [String]) {
		self.modelContainer = modelContainer
		
		monitor = PersistentHistoryMonitorActor(modelContainer: modelContainer)
		
		var tempContinuation: AsyncStream<PersistentIdentifier>.Continuation?
		self.remoteChangeStream = AsyncStream { (continuation: AsyncStream<PersistentIdentifier>.Continuation) -> Void in
			tempContinuation = continuation
		}
		self.continuation = tempContinuation
		
		setupMonitor(excludeAuthors: excludeAuthors)
	}

	
	// MARK: - PersistentHistoryTracking
	
	private func setupMonitor(excludeAuthors: [String]) {
		
		let monitor = self.monitor
		let continuation = self.continuation
		
		Task {
			await monitor.register(excludeAuthors: excludeAuthors) { change in
				
				if let id = change.changedObjectID.persistentIdentifier {
					continuation?.yield(id)
				}
				
			}
		}
		
	}
	
}
