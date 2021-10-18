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
//  CCActionSheet+Animation.swift
//  Component
//
//  Created by Tanakorn Phoochaliaw on 15/10/2564 BE.
//

import Foundation
import UIKit

extension CCActionSheet {
    
    // MARK: - Animation
    func showController() {
        UIView.setAnimationsEnabled(true)
        UIView.animate(withDuration: 0.55, delay: 0.05, usingSpringWithDamping: 0.85, initialSpringVelocity: 0.01, options: .curveLinear, animations: {
            self.alertView.transform = .identity
            self.backgroundView.alpha = 0.3
        }, completion: nil)
        UIView.setAnimationsEnabled(false)
    }
    
    func hideController(completion: ((Bool)->Void)? = nil) {
        UIView.animate(withDuration: 0.55, delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0.02, options: .curveLinear, animations: {
            self.alertView.transform = CGAffineTransform(translationX: 0, y: self.alertView.frame.height)
            self.backgroundView.alpha = 0
        }) { bool in
            completion?(bool)
        }
    }
    
    @objc func panGestureRecognizerHandler(_ sender: UIPanGestureRecognizer) {
        let touchPoint = sender.location(in: view.window)
        switch sender.state {
        case .began:
            self.initialTouchPoint = touchPoint
            self.initialAlertViewFrame = self.alertView.frame
        case .changed:
            let diff = touchPoint.y - self.initialTouchPoint.y
            let slowFactor: CGFloat = diff < 0 ? 0.4 : 1
            self.alertView.transform = CGAffineTransform(translationX: 0, y: diff*slowFactor)
        case .ended, .cancelled:
            if touchPoint.y - self.initialTouchPoint.y > self.stackView.frame.size.height/3 {
                self.dismissAlert()
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.alertView.transform = .identity
                })
            }
        default:
            break
        }
    }
}
