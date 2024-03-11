//
//  UI_SolidButton.swift
//  Yuta Picker
//
//  Created by Nguyen Phuc Loi on 05/03/2024.
//

import SwiftUI

struct SolidButton: View {
    var title: String = "Sign In With Google"
    var hasIcon: Bool = true
    var iconFromAppleSystem: Bool = false
    var iconName: String = "GoogleLogo"
    var bgColor: Color = Color.white
    var textColor: Color = Color.black
    var action: () -> Void
    var body: some View {
        Button(action: action, label: {
            HStack {
                if hasIcon && !iconName.isEmpty {
                    if iconFromAppleSystem {
                        Image(systemName: iconName)
                            .frame(width: 50, height: 50)
                            .foregroundColor(textColor)
                    }else{
                        Image(iconName)
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                }
                Text(title)
                    .foregroundColor(textColor)
            }
        })
        .frame(maxWidth: .infinity)
        .frame(height: 50)
        .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
        .background(bgColor)
        .cornerRadius(12.0)
        .padding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16))
        .shadow(color: bgColor == .white ? textColor.opacity(0.25) : bgColor.opacity(0.5), radius: 12, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 1.0)
        
    }
}

#Preview {
    SolidButton(){}
}
