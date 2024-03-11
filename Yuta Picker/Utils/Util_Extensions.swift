//
//  Util_Extensions.swift
//  Yuta Picker
//
//  Created by Nguyen Phuc Loi on 08/03/2024.
//

import Foundation
import SwiftUI

extension Color {
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0
        
        let length = hexSanitized.count
        
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
        
        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
            
        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
            
        } else {
            return nil
        }
        
        self.init(red: r, green: g, blue: b, opacity: a)
    }
    
    func rgbComponents() -> (Double, Double, Double) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        let uiColor = UIColor(self)
        
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return (red: Double(red), green: Double(green), blue: Double(blue))
    }
    
    func hsbComponents() -> (Double, Double, Double) {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        
        let uiColor = UIColor(self)
        
        uiColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        
        return (hue: Double(hue), saturation: Double(saturation), brightness: Double(brightness))
    }
    
    func cmykComponents() -> (Double, Double, Double, Double) {
        let (red, green, blue) = self.rgbComponents()
        
        var keyline: CGFloat = 1.0 - max(red, green, blue)
        var cyan: CGFloat = (1.0 - red - keyline) / (1.0 - keyline)
        var magnento: CGFloat = (1 - green - keyline) / (1 - keyline)
        var yellow: CGFloat = (1 - blue - keyline) / (1 - keyline)
       
        return (cyan, magnento, yellow, keyline)
        
        
        
    }
    
    func asHex() -> String? {
        let uic = UIColor(self)
        guard let components = uic.cgColor.components, components.count >= 3 else {
            return nil
        }
        
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        
        var a = Float(1.0)
        
        if components.count >= 4 {
            a = Float(components[3])
        }
        
        if a != Float(1.0) {
            return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        }else {
            return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
    }
}


