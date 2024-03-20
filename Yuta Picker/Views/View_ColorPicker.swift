//
//  View_ColorPicker.swift
//  Yuta Picker
//
//  Created by Nguyen Phuc Loi on 05/03/2024.
//

import SwiftUI
import UIKit
import Foundation

struct ColorPickerView: View {
    @StateObject private var colorAttributesVM: ColorAttributesViewViewModel = ColorAttributesViewViewModel()
    @State var rgbComponents: (Double, Double, Double) = (0.0, 0.0, 0.0)
    @State var hsbComponents: (Double, Double, Double) = (0.0, 0.0, 0.0)
    @State var cmykComponents: (Double, Double, Double, Double) = (0.0, 0.0, 0.0, 0.0)
    
    @EnvironmentObject private var authVM: AuthenticationContextProvider
    
    @Binding var isOpen: Bool
    @Binding var alertToastConfiguration: AlertToastConfiguration?
    @Binding var isOpenAlertToast: Bool
    @Binding var isCompleteEvent: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                Text("")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(action: {
                                self.isOpen.toggle()
                            }) {
                                Image(systemName: "arrow.backward")
                                    .resizable()
                                    .frame(width: 30, height: 25)
                            }
                        }
                        
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                print("Data Color before saved to DB: \(colorAttributesVM.selectedColor.asHex()!)")
                                if let hexColor = colorAttributesVM.selectedColor.asHex(),
                                   let currentAccount = authVM.currentAccount {
                                    self.colorAttributesVM.saveUserPalette(account: currentAccount, paletteData: hexColor) {
                                 
                                        Log.proposeLogInfo("[SUCCESS - save user palette]: \(colorAttributesVM.selectedColor.asHex()!)")
                                    }
                                    
                                    DispatchQueue.main.async {
                                        self.isOpen.toggle()
                                        
                                        withAnimation(.easeInOut){
                                            self.isOpenAlertToast = true
                                        }
                                        
                                        self.alertToastConfiguration = AlertToastConfiguration(
                                            displayMode: .hud,
                                            type: .complete(.green),
                                            title: "Save new palette successfully",
                                            subtitle: nil)
                                        self.isCompleteEvent = true
                                        
                                        authVM.fetchCurrentAccount(){}
                                    }
                                }
                            }) {
                                Image(systemName: "square.and.arrow.down")
                                    .resizable()
                                    .frame(width: 30, height: 40)
                            }
                        }
                        
                    }
                
                 
                
                ColorPicker("", selection: $colorAttributesVM.selectedColor)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    .labelsHidden() // Trick to hide the label text
                    .zIndex(1.0)
                
                
                VStack {
                    Rectangle()
                        .foregroundColor(colorAttributesVM.selectedColor)
                        .frame(height: 200)
                        .cornerRadius(20)
                        .padding()
                    
                    
                    HStack (spacing: 8.0) {
                        Text(String(format: "R: %.2f, ", self.rgbComponents.0))
                            .foregroundColor(.black)
                        
                        Text(String(format: "G: %.2f, ", self.rgbComponents.1))
                            .foregroundColor(.black)
                        
                        Text(String(format: "B: %.2f, ", self.rgbComponents.2))
                            .foregroundColor(.black)
                    }
                    
                    HStack (spacing: 8.0) {
                        Text(String(format: "H: %.2f, ", self.hsbComponents.0))
                            .foregroundColor(.black)
                        
                        Text(String(format: "S: %.2f, ", self.hsbComponents.1))
                            .foregroundColor(.black)
                        
                        Text(String(format: "B: %.2f, ", self.hsbComponents.2))
                            .foregroundColor(.black)
                    }
                    
                    HStack (spacing: 8.0) {
                        Text(String(format: "C: %.2f, ", self.cmykComponents.0))
                            .foregroundColor(.black)
                        
                        Text(String(format: "M: %.2f, ", self.cmykComponents.1))
                            .foregroundColor(.black)
                        
                        Text(String(format: "Y: %.2f, ", self.cmykComponents.2))
                            .foregroundColor(.black)
                        
                        Text(String(format: "J: %.2f ", self.cmykComponents.3))
                            .foregroundColor(.black)
                    }
                    
                }
                
            }
            
            .onAppear() {
                DispatchQueue.main.async {
                    authVM.fetchCurrentAccount(){}
                }
                
            }
            .onChange(of: colorAttributesVM.selectedColor) { value in
                let (red, green, blue) = value.rgbComponents()
                let (hue, saturation, brightness) = value.hsbComponents()
                let (cyan, magnento, yellow, keyline) = value.cmykComponents()
                
                Log.proposeLogInfo("VALUE WAS CHANGED")
                Log.proposeLogInfo("[RGB DATA]: \(red), \(green), \(blue)")
                Log.proposeLogInfo("[HSB DATA]: \(hue), \(saturation), \(brightness)")
                
                DispatchQueue.main.async {
                    self.rgbComponents = (red, green, blue)
                    self.hsbComponents = (hue, saturation, brightness)
                    self.cmykComponents = (cyan, magnento, yellow, keyline)
                    
                }
            }
        }
        .frame(maxWidth: .infinity)
        Spacer()
    }
}

#Preview {
    //    ColorPickerView(isOpen: .constant(true))
    HomeView()
        .environmentObject(AuthenticationContextProvider())
}
