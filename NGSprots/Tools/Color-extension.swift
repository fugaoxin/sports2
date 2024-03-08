//
//  Color-extension.swift
//  DYZB2
//
//  Created by wen xi on 2022/11/2.
//

import UIKit

extension UIColor {
    class func hexColor(hex:String) ->UIColor {

        var cString = hex.trimmingCharacters(in:CharacterSet.whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            let index = cString.index(cString.startIndex, offsetBy:1)
            cString = String(cString.suffix(from: index))
        }

        
        if (cString.count != 6) {
            return UIColor.red
        }
        
        let rIndex = cString.index(cString.startIndex, offsetBy: 2)
        let rString = String(cString.prefix(upTo: rIndex))
        let otherString = String(cString.suffix(from: rIndex))
        let gIndex = otherString.index(otherString.startIndex, offsetBy: 2)
        let gString = String(otherString.prefix(upTo: gIndex))
        let bString = String(otherString.suffix(from: gIndex))
        
        var r:CUnsignedLongLong = 0, g:CUnsignedLongLong = 0, b:CUnsignedLongLong = 0;
        Scanner(string: rString).scanHexInt64(&r)
        Scanner(string: gString).scanHexInt64(&g)
        Scanner(string: bString).scanHexInt64(&b)

        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
    class func kRgbColor(red:CGFloat, green:CGFloat, blue:CGFloat) ->UIColor{

       return UIColor.init(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha:1.0)

    }
    class func kRgbColor(red:CGFloat, green:CGFloat, blue:CGFloat,alpha:CGFloat) ->UIColor{

       return UIColor.init(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha:alpha)

    }
}
