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
//  TableView.swift
//  Component
//
//  Created by Castcle Co., Ltd. on 22/12/2564 BE.
//

import UIKit
import Core

public extension UITableView {
    func registerFeedCell() {
        self.register(UINib(nibName: ComponentNibVars.TableViewCell.headerFeed, bundle: ConfigBundle.component), forCellReuseIdentifier: ComponentNibVars.TableViewCell.headerFeed)
        self.register(UINib(nibName: ComponentNibVars.TableViewCell.footerFeed, bundle: ConfigBundle.component), forCellReuseIdentifier: ComponentNibVars.TableViewCell.footerFeed)
        self.register(UINib(nibName: ComponentNibVars.TableViewCell.postText, bundle: ConfigBundle.component), forCellReuseIdentifier: ComponentNibVars.TableViewCell.postText)
        self.register(UINib(nibName: ComponentNibVars.TableViewCell.postLink, bundle: ConfigBundle.component), forCellReuseIdentifier: ComponentNibVars.TableViewCell.postLink)
        self.register(UINib(nibName: ComponentNibVars.TableViewCell.postLinkPreview, bundle: ConfigBundle.component), forCellReuseIdentifier: ComponentNibVars.TableViewCell.postLinkPreview)
        self.register(UINib(nibName: ComponentNibVars.TableViewCell.imageX1, bundle: ConfigBundle.component), forCellReuseIdentifier: ComponentNibVars.TableViewCell.imageX1)
        self.register(UINib(nibName: ComponentNibVars.TableViewCell.imageX2, bundle: ConfigBundle.component), forCellReuseIdentifier: ComponentNibVars.TableViewCell.imageX2)
        self.register(UINib(nibName: ComponentNibVars.TableViewCell.imageX3, bundle: ConfigBundle.component), forCellReuseIdentifier: ComponentNibVars.TableViewCell.imageX3)
        self.register(UINib(nibName: ComponentNibVars.TableViewCell.imageXMore, bundle: ConfigBundle.component), forCellReuseIdentifier: ComponentNibVars.TableViewCell.imageXMore)
        self.register(UINib(nibName: ComponentNibVars.TableViewCell.blog, bundle: ConfigBundle.component), forCellReuseIdentifier: ComponentNibVars.TableViewCell.blog)
        self.register(UINib(nibName: ComponentNibVars.TableViewCell.blogNoImage, bundle: ConfigBundle.component), forCellReuseIdentifier: ComponentNibVars.TableViewCell.blogNoImage)
        self.register(UINib(nibName: ComponentNibVars.TableViewCell.skeleton, bundle: ConfigBundle.component), forCellReuseIdentifier: ComponentNibVars.TableViewCell.skeleton)
        self.register(UINib(nibName: ComponentNibVars.TableViewCell.activityHeader, bundle: ConfigBundle.component), forCellReuseIdentifier: ComponentNibVars.TableViewCell.activityHeader)
        self.register(UINib(nibName: ComponentNibVars.TableViewCell.quoteText, bundle: ConfigBundle.component), forCellReuseIdentifier: ComponentNibVars.TableViewCell.quoteText)
        self.register(UINib(nibName: ComponentNibVars.TableViewCell.quoteLink, bundle: ConfigBundle.component), forCellReuseIdentifier: ComponentNibVars.TableViewCell.quoteLink)
        self.register(UINib(nibName: ComponentNibVars.TableViewCell.quoteLinkPreview, bundle: ConfigBundle.component), forCellReuseIdentifier: ComponentNibVars.TableViewCell.quoteLinkPreview)
        self.register(UINib(nibName: ComponentNibVars.TableViewCell.quoteImageX1, bundle: ConfigBundle.component), forCellReuseIdentifier: ComponentNibVars.TableViewCell.quoteImageX1)
        self.register(UINib(nibName: ComponentNibVars.TableViewCell.quoteImageX2, bundle: ConfigBundle.component), forCellReuseIdentifier: ComponentNibVars.TableViewCell.quoteImageX2)
        self.register(UINib(nibName: ComponentNibVars.TableViewCell.quoteImageX3, bundle: ConfigBundle.component), forCellReuseIdentifier: ComponentNibVars.TableViewCell.quoteImageX3)
        self.register(UINib(nibName: ComponentNibVars.TableViewCell.quoteImageXMore, bundle: ConfigBundle.component), forCellReuseIdentifier: ComponentNibVars.TableViewCell.quoteImageXMore)
        self.register(UINib(nibName: ComponentNibVars.TableViewCell.quoteBlog, bundle: ConfigBundle.component), forCellReuseIdentifier: ComponentNibVars.TableViewCell.quoteBlog)
        self.register(UINib(nibName: ComponentNibVars.TableViewCell.quoteBlogNoImage, bundle: ConfigBundle.component), forCellReuseIdentifier: ComponentNibVars.TableViewCell.quoteBlogNoImage)
        self.register(UINib(nibName: ComponentNibVars.TableViewCell.suggestionUser, bundle: ConfigBundle.component), forCellReuseIdentifier: ComponentNibVars.TableViewCell.suggestionUser)
        self.register(UINib(nibName: ComponentNibVars.TableViewCell.adsPage, bundle: ConfigBundle.component), forCellReuseIdentifier: ComponentNibVars.TableViewCell.adsPage)
        self.register(UINib(nibName: ComponentNibVars.TableViewCell.reached, bundle: ConfigBundle.component), forCellReuseIdentifier: ComponentNibVars.TableViewCell.reached)
        self.register(UINib(nibName: ComponentNibVars.TableViewCell.longText, bundle: ConfigBundle.component), forCellReuseIdentifier: ComponentNibVars.TableViewCell.longText)
        self.register(UINib(nibName: ComponentNibVars.TableViewCell.longTextLink, bundle: ConfigBundle.component), forCellReuseIdentifier: ComponentNibVars.TableViewCell.longTextLink)
        self.register(UINib(nibName: ComponentNibVars.TableViewCell.longTextLinkPreview, bundle: ConfigBundle.component), forCellReuseIdentifier: ComponentNibVars.TableViewCell.longTextLinkPreview)
        self.register(UINib(nibName: ComponentNibVars.TableViewCell.longImageX1, bundle: ConfigBundle.component), forCellReuseIdentifier: ComponentNibVars.TableViewCell.longImageX1)
        self.register(UINib(nibName: ComponentNibVars.TableViewCell.longImageX2, bundle: ConfigBundle.component), forCellReuseIdentifier: ComponentNibVars.TableViewCell.longImageX2)
        self.register(UINib(nibName: ComponentNibVars.TableViewCell.longImageX3, bundle: ConfigBundle.component), forCellReuseIdentifier: ComponentNibVars.TableViewCell.longImageX3)
        self.register(UINib(nibName: ComponentNibVars.TableViewCell.longImageXMore, bundle: ConfigBundle.component), forCellReuseIdentifier: ComponentNibVars.TableViewCell.longImageXMore)
    }
}
