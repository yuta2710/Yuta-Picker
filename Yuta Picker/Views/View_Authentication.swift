//
//  View_Authentication.swift
//  Yuta Picker
//
//  Created by Nguyen Phuc Loi on 05/03/2024.
//

import SwiftUI

struct AuthenticationView: View {
    @EnvironmentObject private var authContext: AuthenticationContextProvider
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.darkBackground, Color.pinkGradient2]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/)
                .edgesIgnoringSafeArea(.all)

            Image("Background 1")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            
            VStack (alignment: .leading) {
                Text("Let's go with us")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                    .padding()
                
                SolidButton(
                    title: "Sign In With Google",
                    hasIcon: true,
                    iconFromAppleSystem: false,
                    iconName: "GoogleLogo",
                    bgColor: .white,
                    textColor: .black) {
                        self.authContext.isSignInWithGoogle.toggle()
                        Task.init {
                            let success = await authContext.signInWithGoogle {}
                            if success {
                                Log.proposeLogInfo("[SUCCESS] ==> User login successfully")
                            }else {
                                Log.proposeLogWarning("[WARNING] ==> Login Failed")
                            }
                            self.authContext.isSignInWithGoogle.toggle()
                            
                        }
                    }
                
                SolidButton(
                    title: "Sign In With Facebook",
                    hasIcon: true,
                    iconFromAppleSystem: false,
                    iconName: "FacebookLogo",
                    bgColor: Color("FacebookBlueBackground"),
                    textColor: .white) {
                        
                    }
                
                SolidButton(
                    title: "Sign In With Github",
                    hasIcon: true,
                    iconFromAppleSystem: false,
                    iconName: "GithubLogo",
                    bgColor: Color("PrimaryBackground"),
                    textColor: .black) {
                        
                    }
            }
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        
    }
}

#Preview {
    AuthenticationView()
        .environmentObject(AuthenticationContextProvider())
}
