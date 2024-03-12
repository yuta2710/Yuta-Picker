//
//  View_PaletteDetails.swift
//  Yuta Picker
//
//  Created by Nguyen Phuc Loi on 11/03/2024.
//

import SwiftUI

struct ColorAttributeDetailsView: View {
    @EnvironmentObject private var colourInfoContextProvider: ColourInfoContextProvider
    var hexCode: String
    
    var body: some View {
        ZStack {
            Color("PrimaryBackground")
                .edgesIgnoringSafeArea(.all)
            if let backgroundColor = colourInfoContextProvider.currentColorDetails?.hex.value {
                let uiColor = Color.init(hex: "#\(hexCode)")!
                WaveAnimation(fillColor: uiColor)
                    .edgesIgnoringSafeArea(.all)
                
            }
            
            if
                let nameOfColor: String = colourInfoContextProvider.currentColorDetails?.name.value,
                let contrastColor: String = colourInfoContextProvider.currentColorDetails?.contrast.value{
                VStack {
                    Text("#\(nameOfColor)")
                        .foregroundColor(Color.init(hex: "\(contrastColor)")!)
                        .font(.largeTitle.bold())
                    
                    Text("Colour Information")
                        .foregroundColor(Color.init(hex: "\(contrastColor)")!)
                    Text(self.hexCode)
                        .foregroundColor(Color.init(hex: "\(contrastColor)")!)
                    
                }
            }
            
            
        }
        .onAppear() {
            DispatchQueue.main.async {
                colourInfoContextProvider.getJsonByQuery(queries: [
                    "hex": "\(hexCode)",
                ])
            }
        }
    }
}

#Preview {
    ColorAttributeDetailsView(hexCode: "000000")
        .environmentObject(AuthenticationContextProvider())
        .environmentObject(ColourInfoContextProvider())
}
