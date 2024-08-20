//
//  BookwormApp.swift
//  Bookworm
//
//  Created by Martí Espinosa Farran on 24/7/24.
//

import SwiftData
import SwiftUI

@main
struct BookwormApp: App {
    
    let modelContainer: ModelContainer
    
    init() {
        do {
            modelContainer = try ModelContainer(for: ReadBook.self)
        } catch {
            fatalError("Could not initialise ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(modelContainer)
    }
}
