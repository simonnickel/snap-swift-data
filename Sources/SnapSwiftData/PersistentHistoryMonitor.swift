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
	
	public init(modelContainer: ModelContainer, excludeAuthors: [String]) {
		self.modelContainer = modelContainer
		
		monitor = PersistentHistoryMonitorActor(modelContainer: modelContainer)
		setupMonitor(excludeAuthors: excludeAuthors)
	}

	
	// MARK: - PersistenHistoryTracking
	
	private func setupMonitor(excludeAuthors: [String]) {
		
		let monitor = self.monitor
		let continuation = self.continuation
		
		Task.detached { // TODO: Does this really need to be detached? Should this be executed on the ModelActor?
			await monitor.register(excludeAuthors: excludeAuthors) { change in
				
				if let id = change.changedObjectID.persistentIdentifier {
					continuation?.yield(id)
				}
				
			}
		}
		
	}
	
	public lazy var remoteChangeStream: AsyncStream<PersistentIdentifier> = {
		AsyncStream { (continuation: AsyncStream<PersistentIdentifier>.Continuation) -> Void in
			self.continuation = continuation
		}
	}()
	
	private var continuation: AsyncStream<PersistentIdentifier>.Continuation?
	
}
