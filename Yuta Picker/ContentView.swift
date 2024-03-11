//
//  ContentView.swift
//  Yuta Picker
//
//  Created by Nguyen Phuc Loi on 05/03/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var currentTab: Tab = Tab.home
    
    var body: some View {
        NavigationView {
            VStack (spacing: 0.0) {
                TabView(selection: $currentTab) {
                    HomeView()
                        .tag(Tab.home)
                    
                    SearchView()
                        .tag(Tab.search)
                    
                    CameraView()
                        .tag(Tab.camera)
                    
                    ProfileView()
                        .tag(Tab.profile)
                    
                }
                TabBarCustomization(currentTab: $currentTab)
            }
            .ignoresSafeArea(.keyboard)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthenticationContextProvider())
        .environmentObject(ColourInfoContextProvider())
    
}
