//
//  Animation_Wave.swift
//  Yuta Picker
//
//  Created by Nguyen Phuc Loi on 12/03/2024.
//

import SwiftUI

struct WaveAnimation: View {
    @State private var percent = 20.0
    @State private var waveOffset = Angle(degrees: 0)
    @State var fillColor: Color = Color("TertiaryBackground")
    
    var body: some View {
        Wave(offSet: Angle(degrees: waveOffset.degrees), percent: percent)
            .fill(
                fillColor
            )
         
        .onAppear() {
            Task.init {
                withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    self.waveOffset = Angle(degrees: 360)
                }
            }
        }
    }
}


struct Wave: Shape {
    var offSet: Angle
    var percent: Double
    
    var animatableData: Double {
        get { offSet.degrees }
        set { offSet = Angle(degrees: newValue) }
    }
    
    func path(in rect: CGRect) -> Path {
        var pathResponse = Path()
        let lowestWave = 0.02
        let highestWave = 1.00 // 1.00
        
        let newPercent = lowestWave + (highestWave - lowestWave) * (percent / 100)
        let waveHeight = 0.015 * rect.height // 0.01
        let yOffSet = 250.0 // CGFloat(1 - newPercent) * (rect.height - 4 * waveHeight) + 2 * waveHeight
        let startAngle = offSet
        let endAngle = offSet + Angle(degrees: 360 + 10) // 360 + 10
        
        pathResponse.move(to: CGPoint(x: 0, y: yOffSet + waveHeight * CGFloat(sin(offSet.radians))))
        
        for angle in stride(from: startAngle.degrees, through: endAngle.degrees, by: 5) {
            let x = CGFloat((angle - startAngle.degrees) / 360) * (rect.width - 5)
            pathResponse.addLine(to: CGPoint(x: x, y: yOffSet + waveHeight * CGFloat(sin(Angle(degrees: angle).radians))))
        }
        
        pathResponse.addLine(to: CGPoint(x: rect.width, y: rect.height))
        pathResponse.addLine(to: CGPoint(x: 0, y: rect.height))
        pathResponse.closeSubpath()
        
        return pathResponse
    }
}

#Preview {
    WaveAnimation()
}
