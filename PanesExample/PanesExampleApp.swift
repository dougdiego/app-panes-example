//
//  PanesExampleApp.swift
//  PanesExample
//
//  Created by Doug Diego on 10/13/25.
//

import SwiftUI

@main
struct PanesExampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        #if os(macOS)
        .defaultSize(width: 1000, height: 600)
        #endif
    }
}
