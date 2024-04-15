//
//  ModelContainerManager.swift
//	SnapSwiftData
//
//  Created by Simon Nickel on 02.02.24.
//

import SwiftData
import OSLog

public final class ModelContainerManager {
	
	internal struct Constants {
		static let author: String = "app"
	}
		
	public let modelContainer: ModelContainer
	
	public init(schema: Schema) {
		do {
			
			let modelConfiguration = ModelConfiguration(schema: schema)
			modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
			
		} catch {
			Logger.snapSwiftData.error("Failed to create ModelContainer: \(error.localizedDescription)")
			fatalError("Failed to create ModelContainer: \(error)")
		}
	}
	
	@MainActor public var mainContext: ModelContext {
		let context = modelContainer.mainContext
		context.managedObjectContext?.transactionAuthor = Constants.author
		return context
	}
	
}
