//
//  SNAP - https://github.com/simonnickel/snap
//  Created by Simon Nickel
//

import Foundation
import OSLog

internal extension Logger {
	
	private static var subsystem: String { Bundle.main.bundleIdentifier! }
	
	static let snapSwiftData = Logger(subsystem: subsystem, category: "SnapSwiftData")
	static let monitorContextChange = Logger(subsystem: subsystem, category: "MonitorContextChange")
	static let monitorPersistentHistory = Logger(subsystem: subsystem, category: "MonitorPersistentHistory")
	
}
