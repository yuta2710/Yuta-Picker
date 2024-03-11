//
//  Model_ColorAttributes.swift
//  Yuta Picker
//
//  Created by Nguyen Phuc Loi on 05/03/2024.
//

import Foundation

struct ColorAttributes: Codable {
    struct Hex: Codable {
        let value: String
        let clean: String
    }
    
    struct RGB: Codable {
        struct Fraction: Codable {
            let r: Double
            let g: Double
            let b: Double
        }
        
        let fraction: Fraction
        let r: Int
        let g: Int
        let b: Int
        let value: String
    }
    
    struct HSL: Codable {
        struct Fraction: Codable {
            let h: Double
            let s: Double
            let l: Double
        }
        
        let fraction: Fraction
        let h: Int
        let s: Int
        let l: Int
        let value: String
    }
    
    struct HSV: Codable {
        struct Fraction: Codable {
            let h: Double
            let s: Double
            let v: Double
        }
        
        let fraction: Fraction
        let value: String
        let h: Int
        let s: Int
        let v: Int
    }
    
    struct Name: Codable {
        let value: String
        let closestNamedHex: String
        let exactMatchName: Bool
        let distance: Int
    }
    
    struct CMYK: Codable {
        struct Fraction: Codable {
            let c: Double
            let m: Double
            let y: Double
            let k: Double
        }
        
        let fraction: Fraction
        let value: String
        let c: Int
        let m: Int
        let y: Int
        let k: Int
    }
    
    struct XYZ: Codable {
        struct Fraction: Codable {
            let X: Double
            let Y: Double
            let Z: Double
        }
        
        let fraction: Fraction
        let value: String
        let X: Int
        let Y: Int
        let Z: Int
    }
    
    struct Image: Codable {
        let bare: String
        let named: String
    }
    
    struct Contrast: Codable {
        let value: String
    }
    
    struct Links: Codable {
        let `self`: SelfLink
        
        struct SelfLink: Codable {
            let href: String
        }
    }
    
    struct Embedded: Codable {
        
    }
    
    let hex: Hex
    let rgb: RGB
    let hsl: HSL
    let hsv: HSV
    let name: Name
    let cmyk: CMYK
    let XYZ: XYZ
    let image: Image
    let contrast: Contrast
    let _links: Links
    let _embedded: Embedded
}

