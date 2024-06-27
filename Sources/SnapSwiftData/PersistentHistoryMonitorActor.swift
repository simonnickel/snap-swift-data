//
//  PersistentHistoryMonitor.swift
//  SnapSwiftData
//
//  Created by Simon Nickel on 02.02.24.
//

import Foundation
import SwiftData
import CoreData
import Combine
import OSLog

/// NSPersistentHistoryChange has to move out of ModelActor. Should not change and therefore be just Sendable.
extension NSPersistentHistoryChange: @unchecked @retroactive Sendable { }

/// Consumes PersistentHistoryTracking events via Combine and posts them to the change handler (see PersistentHistoryMonitor for consumption).
@ModelActor 
public actor PersistentHistoryMonitorActor: Sendable {
	
	public typealias ChangeHandler = @Sendable (NSPersistentHistoryChange) -> Void
	private var onChange: ChangeHandler? = nil

	private var subscriptions = Set<AnyCancellable>()

	// Respond to persistent history tracking notifications
	public func register(excludeAuthors: [String] = [], onChange: @escaping ChangeHandler) {
		self.onChange = onChange
		
		guard let coordinator = modelContext.coordinator else { return }
		
		NotificationCenter.default.publisher(
			for: .NSPersistentStoreRemoteChange,
			object: coordinator
		)
		.sink { _ in
			self.processPersistentHistory(excludeAuthors: excludeAuthors)
		}
		.store(in: &subscriptions)
	}
	
	private func processPersistentHistory(excludeAuthors: [String]) {
		let transactions = fetchTransaction(after: lastHistoryTransactionTimestamp)
		lastHistoryTransactionTimestamp = transactions.max { $1.timestamp > $0.timestamp }?.timestamp ?? .now
		
		// Filter transactions to exclude transactions generated by excludeAuthors.
		for transaction in transactions where !excludeAuthors.contains([transaction.author ?? ""]) {
			for change in transaction.changes ?? [] {
				
				Logger.monitorPersistentHistory.debug("\(change)")
				onChange?(change)
				
			}
		}
	}
	
	private var lastHistoryTransactionTimestamp: Date {
		get { UserDefaults.standard.object(forKey: "lastHistoryTransactionTimestamp") as? Date ?? Date.distantPast }
		set { UserDefaults.standard.setValue(newValue, forKey: "lastHistoryTransactionTimestamp") }
	}

	private func fetchTransaction(after timestamp: Date) -> [NSPersistentHistoryTransaction] {
		do {
			
			let fetchRequest = NSPersistentHistoryChangeRequest.fetchHistory(after: timestamp)
			
			guard let historyResult = try modelContext.managedObjectContext?.execute(fetchRequest) as? NSPersistentHistoryResult
			else {
				Logger.monitorPersistentHistory.error("Failed to fetch NSPersistentHistoryResult.")
				return []
			}
			
			guard let transactions = historyResult.result as? [NSPersistentHistoryTransaction]
			else {
				Logger.monitorPersistentHistory.error("Failed to get NSPersistentHistoryTransaction from NSPersistentHistoryResult.")
				return []
			}
			
			return transactions
			
		} catch {
			Logger.monitorPersistentHistory.error("Failed to fetch transaction: \(error.localizedDescription)")
			return []
		}
	}

}
