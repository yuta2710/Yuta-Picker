//
//  UiLib_TabBarCustomization.swift
//  Yuta Picker
//
//  Created by Nguyen Phuc Loi on 05/03/2024.
//

import SwiftUI

struct TabBarCustomization: View {
    @Binding var currentTab: Tab
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let EXTRA_OFFSET_CONSTANT: CGFloat = CGFloat(7)
            
            HStack (spacing: 0.0) {
                ForEach(Tab.allCases, id: \.rawValue) { tab in
                    Button(action: {
                        withAnimation(.easeInOut) {
                            currentTab = tab
                        }
                    }, label: {
                        Image(systemName: tab.rawValue)
                            .resizable()
                            .frame(width: 35, height: 35)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .offset(y: currentTab == tab ? -17 : 0)
                    })
                }
            }
            .frame(maxWidth: .infinity)
            .background(alignment: .leading){
                Circle()
                    .fill(Color.black)
                    .frame(width: 80, height: 80)
                    .shadow(color: .black.opacity(0.25), radius: 20, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
                    .offset(x: offsetController(width: width) + EXTRA_OFFSET_CONSTANT, y: -17)
                    .overlay(
                        Circle()
                            .trim(from: 0, to: 0.5)
                            .stroke(LinearGradient(gradient: Gradient(colors: [Color.cyan, Color.red, Color("PinkGradient1"), Color("PinkGradient2")]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/), lineWidth: 2.0)
                            .rotationEffect(.degrees(110))
                            .offset(x: offsetController(width: width) + EXTRA_OFFSET_CONSTANT, y: -17)
                    )
            }
            
        }
        .frame(height: 30)
        .padding(.top, 30)
        .background(LinearGradient(gradient: Gradient(colors: [Color("Shadow"), Color.black]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/))
        
        
    }
    
    func offsetController(width: CGFloat) -> CGFloat{
        let currentIndex: CGFloat = CGFloat(getBindingTabIndex())
        if currentIndex == 0 { return 0 }
        let buttonWidth = width / CGFloat(Tab.allCases.count)
        
        return (currentIndex * buttonWidth)
    }
    
    func getBindingTabIndex() -> Int {
        switch currentTab {
        case .home:
            return 0
        case .search:
            return 1
        case .camera:
            return 2
        case .profile:
            return 3
        }
    }
}

#Preview {
//    TabBarCustomization(currentTab: .constant(.home))
    ContentView()
}
