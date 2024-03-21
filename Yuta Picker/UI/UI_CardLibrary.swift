//
//  UI_CardLibrary.swift
//  Yuta Picker
//
//  Created by Nguyen Phuc Loi on 05/03/2024.
//

import SwiftUI

struct CardLibrary: View {
    @Binding var isOpenAlertDeleteConfirmation: Bool
    @Binding var currentLibrarySelected: Library?
    
    var library: Library
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text(library.name)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    Spacer()
                    
                    HStack(spacing: 24.0) {
                        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                            Image(systemName: "gearshape")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.green)
                            //                                .shadow(color: Color("PrimaryBackground"), radius: 1, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 0.2)
                        })
                        
                        Button(action: {
                            isOpenAlertDeleteConfirmation.toggle()
                            currentLibrarySelected = library
                        }, label: {
                            Image(systemName: "trash")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.red)
                            //                                .shadow(color: Color.red, radius: 0.5, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 0.0)
                        })
                    }
                }
                
                ScrollView(.horizontal) {
                    HStack (alignment: .center) {
                        ForEach(library.colors, id: \.self) { hex in
                            let uiColor = Color.init(hex: "#\(hex)")!
                            Color(uiColor)
                                .frame(width: 30, height: 30)
                                .cornerRadius(18.0)
                                .shadow(color: uiColor, radius: 8, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 0.0)
                                .cornerRadius(18.0)
                        }
                    }
                }
                
                VStack (alignment: .leading, spacing: 6.0) {
                    HStack {
                        Text("Created at:")
                            .font(.footnote)
                            .foregroundColor(Color("PrimaryBackground").opacity(0.6))
                        Text("\(Date().formattedDateString(from: library.createdAt))")
                            .font(.footnote)
                            .foregroundColor(.white)
                    }
                    
                    HStack {
                        Text("Last modified at:")
                            .font(.footnote)
                            .foregroundColor(Color("PrimaryBackground").opacity(0.6))
                        Text("\(Date().formattedDateString(from: library.modifiedAt))")
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
    CardLibrary(
        isOpenAlertDeleteConfirmation: .constant(true),
        currentLibrarySelected: .constant(.init(id: "", name: "", colors: [], ownerId: "",
                                                createdAt: Date().timeIntervalSince1970, modifiedAt: Date().timeIntervalSince1970)),
        library: .init(id: "", name: "", colors: [], ownerId: "",
                               createdAt: Date().timeIntervalSince1970, modifiedAt: Date().timeIntervalSince1970))
}





//            LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.6759886742, green: 0.9469802976, blue: 1, alpha: 1)), Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))]), startPoint: .top, endPoint: .bottom)
//                .edgesIgnoringSafeArea(.all)
//
//            LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)).opacity(0.6), Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)).opacity(0.3)]), startPoint: .topLeading, endPoint: .bottomTrailing)
//                .edgesIgnoringSafeArea(.all)

