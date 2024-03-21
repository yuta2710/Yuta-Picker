//
//  View_Profile.swift
//  Yuta Picker
//
//  Created by Nguyen Phuc Loi on 07/03/2024.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var authenticationContextProvider: AuthenticationContextProvider
    
    var body: some View {
        Button(action: {
            authenticationContextProvider.signOut {
                
            }
        }, label: {
            Text("Logout")
        })
        
        
    }
}

#Preview {
    ProfileView()
}
