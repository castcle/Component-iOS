//
//  UIColorExtension.swift
//  Component
//
//  Created by Tanakorn Phoochaliaw on 8/7/2564 BE.
//

import UIKit

extension UIColor {
    public convenience init(rgb: (r: CGFloat, g: CGFloat, b: CGFloat)) {
        self.init(red: rgb.r/255, green: rgb.g/255, blue: rgb.b/255, alpha: 1.0)
    }
}
