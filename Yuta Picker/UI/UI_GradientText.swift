//
//  UI_GradientText.swift
//  Yuta Picker
//
//  Created by Nguyen Phuc Loi on 05/03/2024.
//

import SwiftUI

struct GradientText: View {
    var title: String = "Hello world"
    var colors: [Color] = [Color("PinkGradient1"), Color("PinkGradient2")]
    var body: some View {
        Text(title)
            .gradientTextColor(colors: colors)
    }
}

extension View {
    func gradientTextColor(colors: [Color]) -> some View {
        self
            .overlay(
                LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
            )
            .mask(self)
    }
}

#Preview {
    GradientText()
}
