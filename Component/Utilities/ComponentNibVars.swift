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
//  Created by Castcle Co., Ltd. on 15/7/2564 BE.
//

public struct ComponentNibVars {
    // MARK: - View Controller
    public struct ViewController {
        public static let internalWebView = "InternalWebViewController"
        public static let splashScreen = "SplashScreenViewController"
        public static let datePicker = "DatePickerViewController"
        public static let recastPopup = "RecastPopupViewController"
        public static let comment = "CommentViewController"
        public static let reportSuccess = "ReportSuccessViewController"
    }
    
    // MARK: - View
    public struct Storyboard {
        public static let internalWebView = "WebView"
        public static let splashScreen = "SplashScreen"
        public static let picker = "Picker"
        public static let recast = "Recast"
        public static let comment = "Comment"
        public static let report = "Report"
    }
    
    public struct View {
        public static let comment = "CommentKeyboardInput"
    }
    
    // MARK: - TableViewCell
    public struct TableViewCell {
        public static let userList = "UserListTableViewCell"
        public static let headerFeed = "HeaderTableViewCell"
        public static let footerFeed = "FooterTableViewCell"
        public static let postText = "TextTableViewCell"
        public static let postLink = "TextLinkTableViewCell"
        public static let postLinkPreview = "TextLinkPreviewTableViewCell"
        public static let imageX1 = "ImageX1TableViewCell"
        public static let imageX2 = "ImageX2TableViewCell"
        public static let imageX3 = "ImageX3TableViewCell"
        public static let imageXMore = "ImageXMoreTableViewCell"
        public static let blog = "BlogTableViewCell"
        public static let blogNoImage = "BlogNoImageTableViewCell"
        public static let comment = "CommentTableViewCell"
        public static let reply = "ReplyTableViewCell"
        public static let skeleton = "SkeletonFeedTableViewCell"
        public static let activityHeader = "ActivityHeaderTableViewCell"
        public static let quoteText = "QuoteCastTextCell"
        public static let quoteLink = "QuoteCastTextLinkCell"
        public static let quoteLinkPreview = "QuoteCastTextLinkPreviewCell"
        public static let quoteImageX1 = "QuoteCastImageX1Cell"
        public static let quoteImageX2 = "QuoteCastImageX2Cell"
        public static let quoteImageX3 = "QuoteCastImageX3Cell"
        public static let quoteImageXMore = "QuoteCastImageXMoreCell"
        public static let quoteBlog = "QuoteCastBlogCell"
        public static let quoteBlogNoImage = "QuoteCastBlogNoImageCell"
        public static let suggestionUser = "SuggestionUserTableViewCell"
        public static let adsPage = "AdsPageTableViewCell"
        public static let reached = "ReachedTableViewCell"
    }
    
    // MARK: - CollectionViewCell
    public struct CollectionViewCell {
    }
}
