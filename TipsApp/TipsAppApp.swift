//
//  TipsAppApp.swift
//  Tips App
//
//  Created by Anand Upadhyay on 28/06/25.
//

import SwiftUI
import SwiftData

@main
struct TipsAppApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            TipCalculation.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            
            // Migrate existing data to set default currency
            migrateExistingData(container: container)
            
            return container
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    private static func migrateExistingData(container: ModelContainer) {
        let context = container.mainContext
        
        do {
            let descriptor = FetchDescriptor<TipCalculation>()
            let calculations = try context.fetch(descriptor)
            
            for calculation in calculations {
                if calculation.currency == nil {
                    calculation.currency = .usd
                }
            }
            
            try context.save()
        } catch {
            print("Migration failed: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            SplashScreenView()
        }
        .modelContainer(sharedModelContainer)
    }
}
