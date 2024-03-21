//
//  View_Search.swift
//  Yuta Picker
//
//  Created by Nguyen Phuc Loi on 07/03/2024.
//

import SwiftUI

struct SearchView: View {
    @State private var searchColorByHexValue: String = "000001"
    @State var rgbComponents: (Double, Double, Double) = (0.0, 0.0, 0.0)
    @State var hsbComponents: (Double, Double, Double) = (0.0, 0.0, 0.0)
    @State var cmykComponents: (Double, Double, Double, Double) = (0.0, 0.0, 0.0, 0.0)
    @State var isRandomColor: Bool = false
    @State var randomColor: String = ""
    
    @EnvironmentObject private var colourInfoContextProvider: ColourInfoContextProvider
    var body: some View {
        NavigationStack {
            Text("\(searchColorByHexValue)")
            if searchColorByHexValue.count == 6 {
                let uiColor = Color(hex: "#\(searchColorByHexValue)")!
                
                GeometryReader() { proxy in
                    let width = proxy.size.width
                    let height = proxy.size.height
                    
                    ZStack {
                        WaveAnimation(fillColor: uiColor)
                        
                        if
                            let nameOfColor: String = colourInfoContextProvider.currentColorDetails?.name.value,
                            let contrastColor: String = colourInfoContextProvider.currentColorDetails?.contrast.value {
                            VStack {
                                let contrastUIColor = Color(hex: contrastColor)
                                
                                HStack (spacing: 8.0) {
                                    Text(String(format: "R: %.2f, ", self.rgbComponents.0))
                                        .foregroundColor(contrastUIColor)
                                    
                                    Text(String(format: "G: %.2f, ", self.rgbComponents.1))
                                        .foregroundColor(contrastUIColor)
                                    
                                    Text(String(format: "B: %.2f, ", self.rgbComponents.2))
                                        .foregroundColor(contrastUIColor)
                                }
                                
                                HStack (spacing: 8.0) {
                                    Text(String(format: "H: %.2f, ", self.hsbComponents.0))
                                        .foregroundColor(contrastUIColor)
                                    
                                    Text(String(format: "S: %.2f, ", self.hsbComponents.1))
                                        .foregroundColor(contrastUIColor)
                                    
                                    Text(String(format: "B: %.2f, ", self.hsbComponents.2))
                                        .foregroundColor(contrastUIColor)
                                }
                                
                                HStack (spacing: 8.0) {
                                    Text(String(format: "C: %.2f, ", self.cmykComponents.0))
                                        .foregroundColor(contrastUIColor)
                                    
                                    Text(String(format: "M: %.2f, ", self.cmykComponents.1))
                                        .foregroundColor(contrastUIColor)
                                    
                                    Text(String(format: "Y: %.2f, ", self.cmykComponents.2))
                                        .foregroundColor(contrastUIColor)
                                    
                                    Text(String(format: "J: %.2f ", self.cmykComponents.3))
                                        .foregroundColor(contrastUIColor)
                                }
                                
                                Text("\(nameOfColor)")
                                    .foregroundColor(contrastUIColor)
                                    .font(.largeTitle.bold())
                                Text("Colour Information")
                                    .foregroundColor(contrastUIColor)
                                Text("#\(self.searchColorByHexValue)")
                                    .foregroundColor(contrastUIColor)
                                
                                Button(action: {
                                    
                                }, label: {
                                    Image(systemName: "arrow.triangle.2.circlepath")
                                })
                                
                            }
                            .offset(y: 48)
                        }
                    }
                    
                }
            }
        }
        .onChange(of: searchColorByHexValue) { newSearchValue in
            fetchColorInformation(hexValue: searchColorByHexValue)
        }
        .onAppear() {
            DispatchQueue.global().async {
                fetchColorInformation(hexValue: searchColorByHexValue)
            }
        }
        .searchable(text: $searchColorByHexValue)
    }
    
    private func fetchColorInformation(hexValue: String) {
        if hexValue.count == 6 {
            self.colourInfoContextProvider.getJsonByQuery(queries: ["hex": "\(hexValue)"])
            let colorByHexSearching = Color(hex: "#\(hexValue)")!
            
            let (red, green, blue) = colorByHexSearching.rgbComponents()
            let (hue, saturation, brightness) = colorByHexSearching.hsbComponents()
            let (cyan, magnento, yellow, keyline) = colorByHexSearching.cmykComponents()
            
            DispatchQueue.main.async {
                self.rgbComponents = (red, green, blue)
                self.hsbComponents = (hue, saturation, brightness)
                self.cmykComponents = (cyan, magnento, yellow, keyline)
            }
        }
    }
}

#Preview {
    SearchView()
        .environmentObject(AuthenticationContextProvider())
        .environmentObject(ColourInfoContextProvider())
}
