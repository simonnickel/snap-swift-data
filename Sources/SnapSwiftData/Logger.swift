//
//  PersistentHistoryMonitor+Logger.swift
//  SnapSwiftData
//
//  Created by Simon Nickel on 02.02.24.
//

import Foundation
import OSLog

internal extension Logger {
	
	private static var subsystem: String { Bundle.main.bundleIdentifier! }
	
	static let snapSwiftData = Logger(subsystem: subsystem, category: "SnapSwiftData")
	static let monitorContextChange = Logger(subsystem: subsystem, category: "MonitorContextChange")
	static let monitorPersistentHistory = Logger(subsystem: subsystem, category: "MonitorPersistentHistory")
	
}

// TODO concurrency: Remove once @preconcurrency works as expected.
// This fixes the warning on Logger.settings not being concurrency safe. Should apply @preconcurrency import OSLog instead.
// https://forums.swift.org/t/preconcurrency-doesnt-suppress-static-property-concurrency-warnings/70469/2
extension Logger: @unchecked Sendable {}
