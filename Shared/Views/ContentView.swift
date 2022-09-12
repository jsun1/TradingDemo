//
//  ContentView.swift
//  Shared
//
//  Created by Jeffrey Sun on 9/11/22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var modelData: ModelData
    @State private var selection: Tab = .trade
    
    enum Tab {
        case home
        case trade
        case account
    }
    
    var body: some View {
        TabView(selection: $selection) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.circle")
                }
                .tag(Tab.home)
            
            TradeView()
                .environmentObject(modelData)
                .tabItem {
                    Label("Trade", systemImage: "chart.line.uptrend.xyaxis.circle.fill")
                }
                .tag(Tab.trade)
            
            AccountView()
                .tabItem {
                    Label("Account", systemImage: "person.circle.fill")
                }
                .tag(Tab.account)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ModelData())
    }
}
