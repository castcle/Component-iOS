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
//  ComponentNibVars.swift
//  Component
//
//  Created by Tanakorn Phoochaliaw on 15/7/2564 BE.
//

public struct ComponentNibVars {
    // MARK: - View Controller
    public struct ViewController {
        public static let internalWebView = "InternalWebViewController"
        public static let splashScreen = "SplashScreenViewController"
        public static let datePicker = "DatePickerViewController"
        public static let recastPopup = "RecastPopupViewController"
    }
    
    // MARK: - View
    public struct Storyboard {
        public static let internalWebView = "WebView"
        public static let splashScreen = "SplashScreen"
        public static let picker = "Picker"
        public static let recast = "Recast"
    }
    
    // MARK: - TableViewCell
    public struct TableViewCell {
        public static let userList = "UserListTableViewCell"
    }
    
    // MARK: - CollectionViewCell
    public struct CollectionViewCell {
        public static let headerFeed = "HeaderFeedCell"
        public static let footerFeed = "FooterFeedCell"
        public static let postText = "TextCell"
        public static let postTextLinkCell = "TextLinkCell"
        public static let imageX1Cell = "ImageX1Cell"
        public static let imageX2Cell = "ImageX2Cell"
        public static let imageX3Cell = "ImageX3Cell"
        public static let imageXMoreCell = "ImageXMoreCell"
        public static let blogCell = "BlogCell"
        public static let blogNoImageCell = "BlogNoImageCell"
    }
}
