//
//  View_Home.swift
//  Yuta Picker
//
//  Created by Nguyen Phuc Loi on 05/03/2024.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var authenticationContextProvider: AuthenticationContextProvider
    @EnvironmentObject private var colourInfoContextProvider: ColourInfoContextProvider
    @State private var isOpen: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Text("")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            ZStack {
                                HStack {
                                    Text("YutaPicker")
                                        .font(.title.bold())
                                        .gradientTextColor(
                                            colors: [
                                                Color("PinkGradient1"),
                                                Color("PinkGradient2")
                                            ]
                                        )
                                    Spacer()
                                    Button(action: {
                                        
                                    }, label: {
                                        Image(systemName: "plus")
                                            .bold()
                                            .foregroundColor(.white)
                                    })
                                }
                            }
                        }
                    }
                Color("TertiaryBackground")
                    .edgesIgnoringSafeArea(.all)
//                Circle()
//                    .frame(width: 400, height: 400)
//                    .offset(x: 150, y: -200)
//                    .foregroundColor(Color.cyan.opacity(0.5))
//                    .blur(radius: 25)
//                Circle()
//                    .frame(width: 300, height: 300)
//                    .offset(x: -100, y: -125)
//                    .foregroundColor(Color("PinkGradient2").opacity(0.5))
//                    .blur(radius: 25)
            
                VStack {
//                    GradientText(title: "Palette", colors: [Color.cyan, Color.orange])
//                        .font(.title.bold())
//                        .offset(y: 16)
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                        .padding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 0))
                    
                    Text("Palette")
                        .foregroundColor(Color("PrimaryBackground"))
                        .font(.title.bold())
                        .offset(y: 16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 0))
               
                    
                    ScrollView (.horizontal) {
                        HStack (spacing: 16.0) {
                            Button(
                                action: {
                                    self.isOpen.toggle()
                                },
                                label: {
                                Image(systemName: "plus")
                                        .frame(width: 50, height: 50)
                                        .background(.black)
                                        
                                        .foregroundStyle(.linearGradient(colors: [Color("PinkGradient1"), Color("PinkGradient2")], startPoint: .top, endPoint: .bottom))
                                        .overlay (
                                            Circle()
                                                .stroke(LinearGradient(
                                                    colors: [Color.red, Color.blue],
                                                    startPoint: .top,
                                                    endPoint: .bottom), style: StrokeStyle(lineWidth: 5.0))
                                        )
                                        .cornerRadius(25.0)
                                        
                            })
                            
                            if let palleteIds = authenticationContextProvider.currentAccount?.paletteIds {
                                ForEach(palleteIds.reversed(), id: \.self) { palleteHex in
                                    NavigationLink{
                                        ColorAttributeDetailsView(hexCode: palleteHex)
                                    }label: {
                                        let uiColor = Color.init(hex: "#\(palleteHex)")!
                                        Color(uiColor)
                                            .frame(width: 50, height: 50)
                                            .cornerRadius(8.0)
                                            .shadow(color: uiColor, radius: 8, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 0.0)
                                    }
                                    
                                }
                            }
                        }
                        .padding()
                        
                    }

                    ScrollView (.vertical) {
                        VStack (spacing: 0.0) {
                            CardLibrary()
                        }
                        
                    }
                    
                }
            }
        }
        .onAppear() {
            Log.proposeLogWarning("User cannot be null")
            DispatchQueue.main.async {
                authenticationContextProvider.fetchCurrentAccount()
            }
        }
        .sheet(isPresented: $isOpen) {
            ColorPickerView(isOpen: $isOpen)
                .environmentObject(authenticationContextProvider)
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AuthenticationContextProvider())
        .environmentObject(ColourInfoContextProvider())
//    ContentView()
    
}
