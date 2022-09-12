//
//  TradingDemoApp.swift
//  Shared
//
//  Created by Jeffrey Sun on 9/11/22.
//

import SwiftUI

@main
struct TradingDemoApp: App {
    @StateObject private var modelData = ModelData()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(modelData)
        }
    }
}
