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
//  Localizable.swift
//  Component
//
//  Created by Castcle Co., Ltd. on 17/1/2565 BE.
//

import Core

extension Localization {

    // MARK: - Content Detail
    public enum ContentDetail {
        case readMore
        case youRecasted
        case recasted
        case follow

        public var text: String {
            switch self {
            case .readMore:
                return "content_detail_read_more".localized(bundle: ConfigBundle.component)
            case .youRecasted:
                return "content_detail_you_recasted".localized(bundle: ConfigBundle.component)
            case .recasted:
                return "content_detail_recasted".localized(bundle: ConfigBundle.component)
            case .follow:
                return "content_detail_follow".localized(bundle: ConfigBundle.component)
            }
        }
    }

    // MARK: - Content Action
    public enum ContentAction {
        case recastTitle
        case recasted
        case quoteCast
        case unrecasted
        case choosePageOrUser
        case reportCast
        case followed
        case undo
        case delete

        public var text: String {
            switch self {
            case .recastTitle:
                return "content_action_recast_title".localized(bundle: ConfigBundle.component)
            case .recasted:
                return "content_action_recasted".localized(bundle: ConfigBundle.component)
            case .quoteCast:
                return "content_action_quote_cast".localized(bundle: ConfigBundle.component)
            case .unrecasted:
                return "content_action_unrecasted".localized(bundle: ConfigBundle.component)
            case .choosePageOrUser:
                return "content_action_choose_page_or_user".localized(bundle: ConfigBundle.component)
            case .reportCast:
                return "content_action_report_cast".localized(bundle: ConfigBundle.component)
            case .followed:
                return "content_action_followed".localized(bundle: ConfigBundle.component)
            case .undo:
                return "content_action_undo".localized(bundle: ConfigBundle.component)
            case .delete:
                return "content_action_delete".localized(bundle: ConfigBundle.component)
            }
        }
    }

    // MARK: - Castcle About
    public enum CastcleAbout {
        case joinUs
        case docs
        case whitepaper
        case version
        case termOfService
        case privacy

        public var text: String {
            switch self {
            case .joinUs:
                return "castcle_about_join_us".localized(bundle: ConfigBundle.component)
            case .docs:
                return "castcle_about_docs".localized(bundle: ConfigBundle.component)
            case .whitepaper:
                return "castcle_about_whitepaper".localized(bundle: ConfigBundle.component)
            case .version:
                return "castcle_about_version".localized(bundle: ConfigBundle.component)
            case .termOfService:
                return "castcle_about_term_of_service".localized(bundle: ConfigBundle.component)
            case .privacy:
                return "castcle_about_privacy".localized(bundle: ConfigBundle.component)
            }
        }
    }
}
