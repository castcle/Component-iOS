//  Copyright (c) 2021, Castcle and/or its affiliates. All rights reserved.
//  DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
//
//  This code is free software; you can redistribute it and/or modify it
//  under the terms of the GNU General Public License version 3 only, as
//  published by the Free Software Foundation.
//
//  This code is distributed in the hope that it will be useful, but WITHOUT
//  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
//  FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
//  version 3 for more details (a copy is included in the LICENSE file that
//  accompanied this code).
//
//  You should have received a copy of the GNU General Public License version
//  3 along with this work; if not, write to the Free Software Foundation,
//  Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
//
//  Please contact Castcle, 22 Phet Kasem 47/2 Alley, Bang Khae, Bangkok,
//  Thailand 10160, or visit www.castcle.com if you need additional information
//  or have any questions.
//
//  RefreshBundle.swift
//  Component
//
//  Created by Tanakorn Phoochaliaw on 8/7/2564 BE.
//

import UIKit

class RefreshBundle {
    
    var bundle: Bundle
    
    init(bundle: Bundle) {
        self.bundle = bundle
    }
    
    @discardableResult
    static func bundle(name: String, for aClass: Swift.AnyClass) -> RefreshBundle? {
        let bundle = Bundle(for: aClass)
        if let path = bundle.path(forResource: name, ofType: "bundle") {
            if let bundle = Bundle(path: path) {
                return RefreshBundle(bundle: bundle)
            }
        }
        return nil
    }
    
    func imageFromBundle(_ imageName: String) -> UIImage? {
        var imageName = imageName
        if UIScreen.main.scale == 2 {
            imageName = imageName + "@2x"
        } else if UIScreen.main.scale == 3 {
            imageName = imageName + "@3x"
        }
        
        if let bundle = Bundle(path: bundle.bundlePath + "/images") {
            if let path = bundle.path(forResource: imageName, ofType: "png") {
                let image = UIImage(contentsOfFile: path)
                return image
            }
        }
        return nil
    }
    
    func localizedString(key: String) -> String {
        if let current = Locale.current.languageCode {
            var language = ""
            switch current {
            case "zh":
                language = "zh"
            default:
                language = "en"
            }
            if let path = bundle.path(forResource: language, ofType: "lproj") {
                if let bundle = Bundle(path: path) {
                    let value = bundle.localizedString(forKey: key, value: nil, table: nil)
                    return Bundle.main.localizedString(forKey: key, value: value, table: nil)
                }
            }
        }
        return key
    }
}
