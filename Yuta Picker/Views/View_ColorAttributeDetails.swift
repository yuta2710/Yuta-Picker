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
        VStack {
            if let backgroundColor = colourInfoContextProvider.currentColorDetails?.hex.value {
                let uiColor = Color.init(hex: "#\(backgroundColor)")!
                Rectangle()
                    .frame(maxWidth: .infinity)
                    .frame(height: 100)
                    .foregroundColor(uiColor)
                    .cornerRadius(12.0)
                    .shadow(color: uiColor, radius: 8, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 0.0)
                    .padding()
                
            }
            if let nameOfColor = colourInfoContextProvider.currentColorDetails?.name.value {
                Text("#\(nameOfColor)")
                    .font(.largeTitle.bold())
            }
            Text("Colour Information")
            Text(self.hexCode)
                .foregroundColor(.red)
                
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
