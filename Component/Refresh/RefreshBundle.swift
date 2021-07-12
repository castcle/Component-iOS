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
        }else if UIScreen.main.scale == 3 {
            imageName = imageName + "@3x"
        }
        let bundle = Bundle(path: bundle.bundlePath + "/images")
         if let path = bundle?.path(forResource: imageName, ofType: "png") {
            let image = UIImage(contentsOfFile: path)
            return image
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
