//
//  mac_extensiLEApp.swift
//  mac_extensiLE
//
//  Created by Becca GW on 2023-03-11.
//

import SwiftUI
import PythonKit

@main
struct mac_extensiLEApp: App {
    @StateObject private var modelData = ModelData()
    @AppStorage("isDarkMode") private var isDarkMode = true
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(modelData)
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}

