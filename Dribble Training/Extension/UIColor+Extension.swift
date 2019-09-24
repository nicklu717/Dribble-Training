//
//  UIColor+Extension.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/24.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit

extension UIColor {

    static let b1_linen = UIColor(hex: "D5D2C1")
    static let b2_twine = UIColor(hex: "BD8E62")
    static let b3_fawn = UIColor(hex: "A46843")
    static let b4_hickory = UIColor(hex: "370D00")
    
    convenience init(hex: String) {
        
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt32 = 0
        
        scanner.scanHexInt32(&rgbValue)
        
        let redValue = (rgbValue & 0xff0000) >> 16
        let greenValue = (rgbValue & 0xff00) >> 8
        let blueValue = rgbValue & 0xff
        
        self.init(
            red: CGFloat(redValue) / 0xff,
            green: CGFloat(greenValue) / 0xff,
            blue: CGFloat(blueValue) / 0xff,
            alpha: 1
        )
    }
}
