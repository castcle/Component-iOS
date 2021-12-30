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
//  CommentViewModel.swift
//  Component
//
//  Created by Castcle Co., Ltd. on 2/9/2564 BE.
//

import Networking
import Moya
import SwiftyJSON

public final class CommentViewModel {
    
    private var commentRepository: CommentRepository = CommentRepositoryImpl()
    var content: Content?
    var comments: [Comment] = []
    var commentRequest: CommentRequest = CommentRequest()
    let tokenHelper: TokenHelper = TokenHelper()
    var stage: Stage = .none
    var commentId: String = ""
    
    enum Stage {
        case getComments
        case createComment
        case replyComment
        case likeComment
        case unlikeComment
        case none
    }
    
    public init(content: Content? = nil) {
        if let content = content {
            self.content = content
            self.getComments()
        }
    }
    
    public func getComments() {
        self.stage = .getComments
        self.commentRepository.getComments(contentId: self.content?.id ?? "") { (success, response, isRefreshToken)  in
            if success {
                do {
                    let rawJson = try response.mapJSON()
                    let json = JSON(rawJson)
                    let commentPayload = CommentPayload(json: json)
                    self.comments = commentPayload.payload
                    self.didLoadCommentsFinish?()
                } catch {}
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                }
            }
        }
    }
    
    public func createComment () {
        self.stage = .createComment
        self.commentRepository.createComment(contentId: self.content?.id ?? "", commentRequest: self.commentRequest) { (success, response, isRefreshToken)  in
            if success {
                self.getComments()
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                }
            }
        }
    }
    
    public func replyComment () {
        self.stage = .replyComment
        self.commentRepository.replyComment(contentId: self.content?.id ?? "", commentId: self.commentId, commentRequest: self.commentRequest) { (success, response, isRefreshToken)  in
            if success {
                self.getComments()
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                }
            }
        }
    }
    
    public func likeComment () {
        self.stage = .likeComment
        self.commentRepository.likedComment(contentId: self.content?.id ?? "", commentId: self.commentId, commentRequest: self.commentRequest) { (success, response, isRefreshToken)  in
            if success {
                print("Like success")
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                }
            }
        }
    }
    
    public func unlikeComment () {
        self.stage = .unlikeComment
        self.commentRepository.unlikedComment(contentId: self.content?.id ?? "", commentId: self.commentId, commentRequest: self.commentRequest) { (success, response, isRefreshToken)  in
            if success {
                print("Unlike success")
            } else {
                if isRefreshToken {
                    self.tokenHelper.refreshToken()
                }
            }
        }
    }
    
    var didLoadCommentsFinish: (() -> ())?
}

extension CommentViewModel: TokenHelperDelegate {
    public func didRefreshTokenFinish() {
        if self.stage == .getComments {
            self.getComments()
        } else if self.stage == .createComment {
            self.createComment()
        } else if self.stage == .replyComment {
            self.replyComment()
        } else if self.stage == .likeComment {
            self.likeComment()
        } else if self.stage == .unlikeComment {
            self.unlikeComment()
        }
    }
}
