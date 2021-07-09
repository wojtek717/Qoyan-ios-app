// File automatically generated by tuist
//
//  MainScreen.swift
//  MainScreen
//
//  Created by Wojciech Konury on 02/05/2021.
//

import SwiftUI
import Vendors
import ComposableArchitecture
import QoyanUI

public struct MainScreen: View {
    let store: Store<RootState, RootAction>
    
    public init(store: Store<RootState, RootAction>) {
        self.store = store
        
        UITabBar.appearance().backgroundColor = UIColor(Color(QoyanUI.QoyanUIAsset.purpleBackground.color))
    }
    
    public var body: some View {
        WithViewStore(self.store) { viewStore in
            
            TabView {
                HydrationView(store: self.store.scope(
                                state: \.hydrationState,
                                action: RootAction.hydrationAction))
                    .tabItem {
                        Image(systemName: "heart.fill")
                        Text("Favourites")
                    }
                Text("Friends Screen")
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("Friends")
                    }
                Text("Nearby Screen")
                    .tabItem {
                        Image(systemName: "mappin.circle.fill")
                        Text("Nearby")
                    }
                    .background(Color.yellow)
            }
            .accentColor(Color(QoyanUIAsset.purpleLight.color))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen(store: .init(
                    initialState: RootState(),
                    reducer: rootReducer,
                    environment: RootEnvironment()))
    }
}
