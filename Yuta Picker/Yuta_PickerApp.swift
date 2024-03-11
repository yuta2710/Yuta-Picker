//
//  Yuta_PickerApp.swift
//  Yuta Picker
//
//  Created by Nguyen Phuc Loi on 05/03/2024.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
      return GIDSignIn.sharedInstance.handle(url)
    }
}



@main
struct Yuta_PickerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var authenticationContextProvider: AuthenticationContextProvider = AuthenticationContextProvider()
    @StateObject var colorInfoContextProvider: ColourInfoContextProvider = ColourInfoContextProvider()
    
    var body: some Scene {
        WindowGroup {
            if self.authenticationContextProvider.isActive {
                ContentView()
                    .environmentObject(authenticationContextProvider)
                    .environmentObject(colorInfoContextProvider)
            }else {
                AuthenticationView()
                    .environmentObject(authenticationContextProvider)
                    .environmentObject(colorInfoContextProvider)
            }
        }
    }
}
