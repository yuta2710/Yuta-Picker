//
//  UI_CardLibrary.swift
//  Yuta Picker
//
//  Created by Nguyen Phuc Loi on 05/03/2024.
//

import SwiftUI

struct CardLibrary: View {
    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack(alignment: .leading, spacing: 16) {
                Text("Glassmorphism")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                ScrollView(.horizontal) {
                    HStack (alignment: .center) {
                        Color.cyan
                            .frame(width: 30, height: 30)
                            .cornerRadius(16.0)
                        
                        Color.red
                            .frame(width: 30, height: 30)
                            .cornerRadius(16.0)
                        
                        Color.orange
                            .frame(width: 30, height: 30)
                            .cornerRadius(16.0)
                        
                        Color.green
                            .frame(width: 30, height: 30)
                            .cornerRadius(16.0)
                    }
                }
                
                VStack (alignment: .leading, spacing: 6.0) {
                    HStack {
                        Text("Created at:")
                            .font(.footnote)
                            .foregroundColor(Color("PrimaryBackground").opacity(0.6))
                        Text(Date().formatted())
                            .font(.footnote)
                            .foregroundColor(.white)
                    }
                    
                    HStack {
                        Text("Last modified at:")
                            .font(.footnote)
                            .foregroundColor(Color("PrimaryBackground").opacity(0.6))
                        Text(Date().formatted())
                            .font(.footnote)
                            .foregroundColor(.white)
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .frame(minHeight: 200)
            .foregroundColor(Color.black.opacity(0.8))
        }
        .background(
            RoundedRectangle(cornerRadius: 18.0)
                .stroke(.white.opacity(0.2), lineWidth: 1.0)
                .background(VisualEffectBlur(blurStyle: .dark))
                .cornerRadius(18.0)
                .shadow(color: Color.cyan.opacity(0.5), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 2.0)
        )
        .padding()
    }
}

#Preview {
    CardLibrary()
}





//            LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.6759886742, green: 0.9469802976, blue: 1, alpha: 1)), Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))]), startPoint: .top, endPoint: .bottom)
//                .edgesIgnoringSafeArea(.all)
//
//            LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)).opacity(0.6), Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)).opacity(0.3)]), startPoint: .topLeading, endPoint: .bottomTrailing)
//                .edgesIgnoringSafeArea(.all)

