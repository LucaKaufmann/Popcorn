//
//  UIColor+hex.swift
//  Popcorn
//
//  Created by Luca Kaufmann on 4.5.2020.
//  Copyright © 2020 mqtthings. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
}

//extension UIColor {
//    public convenience init?(hex: String) {
//        let r, g, b: CGFloat
//
//        var hexColor = ""
//        if hex.hasPrefix("#") {
//            let start = hex.index(hex.startIndex, offsetBy: 1)
//            hexColor = String(hex[start...])
//        } else {
//            hexColor = String(hex)
//        }
//
//        if hexColor.count == 6 {
//            let scanner = Scanner(string: hexColor)
//            var hexNumber: UInt64 = 0
//
//            if scanner.scanHexInt64(&hexNumber) {
//                r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
//                g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
//                b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
////                    a = CGFloat(hexNumber & 0x000000ff) / 255
//
//                self.init(red: r, green: g, blue: b, alpha: 1.0)
//                return
//            }
//        }
//        self.init()
//        return nil
//    }
//}
