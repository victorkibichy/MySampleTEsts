//
//  MySampleTEstsApp.swift
//  MySampleTEsts
//
//  Created by Vic on 13/10/2025.
//

import SwiftUI

@main
struct MySampleTEstsApp: App {

    @StateObject private var model = AppModel()

    var body: some Scene {
        WindowGroup {
            RevampedLandingScreen()
        }
    }
}
