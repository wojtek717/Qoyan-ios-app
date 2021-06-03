//
//  QoyanApp.swift
//  QoyanApp
//
//  Created by Wojciech Konury on 02/05/2021.
//

import SwiftUI
import Vendors
import ComposableArchitecture
import MainScreen

@main
struct QoyanApp: App {
    var body: some Scene {
        WindowGroup {
            MainScreen(
                store: Store(
                    initialState: RootState(),
                    reducer: rootReducer,
                    environment: RootEnvironment()))
        }
    }
}
