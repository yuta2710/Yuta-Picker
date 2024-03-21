//
//  ContentView.swift
//  Yuta Picker
//
//  Created by Nguyen Phuc Loi on 05/03/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var currentTab: Tab = Tab.home
    
    init() {
        UITabBar.appearance().backgroundColor = .white
    }
    
    var body: some View {
        NavigationView {
            VStack (spacing: 0.0) {
                TabView(selection: $currentTab) {
                    HomeView()
                        .tabItem {
                            Image(systemName: Tab.home.rawValue)
                            Text("Home")
                        }
                        .tag(Tab.home)

                    SearchView()
                        .tabItem {
                            Image(systemName: Tab.search.rawValue)
                            Text("Search")
                        }
                        .tag(Tab.search)

                    CameraView()
                        .tabItem {
                            Image(systemName: Tab.camera.rawValue)
                            Text("Camera")
                        }
                        .tag(Tab.camera)
                    

                    ProfileView()
                        .tabItem {
                            Image(systemName: Tab.profile.rawValue)
                            Text("Profile")
                        }
                        .tag(Tab.profile)
                }
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
