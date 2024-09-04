//
//  MyWordleApp.swift
//  MyWordle
//
//  Created by János Székely on 29/05/2024.
//

import SwiftUI

@main
struct MyWordleApp: App {
    @StateObject var dm = WordleDataModel()
    @StateObject var csManager = ColorScemeManager()
    var body: some Scene {
        WindowGroup {
            GameView()
                .environmentObject(dm)
                .environmentObject(csManager)
                .onAppear {
                    csManager.applyColorScheme()
                }
        }
    }
}
