//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import Foundation
import SwiftData

public final class PersistentHistoryMonitor {
		
	private let modelContainer: ModelContainer
	
	private let monitor: PersistentHistoryMonitorActor
	
	/// An `AsyncStream` to stream all `PersistentIdentifier` that are handled by `PersistentHistoryTracking` (send via  `NSPersistentStoreRemoteChange` notification).
	public let remoteChangeStream: AsyncStream<PersistentIdentifier>
	
	private let continuation: AsyncStream<PersistentIdentifier>.Continuation
	
	public init(modelContainer: ModelContainer, excludeAuthors: [String]) {
		self.modelContainer = modelContainer
		
		monitor = PersistentHistoryMonitorActor(modelContainer: modelContainer)
		
		let (stream, continuation) = AsyncStream.makeStream(of: PersistentIdentifier.self)
		self.remoteChangeStream = stream
		self.continuation = continuation
		
		setupMonitor(excludeAuthors: excludeAuthors)
	}
	
	deinit {
		continuation.finish()
	}

	
	// MARK: - PersistentHistoryTracking
	
	private func setupMonitor(excludeAuthors: [String]) {
		
		let monitor = self.monitor
		let continuation = self.continuation
		
		Task {
			await monitor.register(excludeAuthors: excludeAuthors) { change in
				
				if let id = change.changedObjectID.persistentIdentifier {
					continuation.yield(id)
				}
				
			}
		}
		
	}
	
}
