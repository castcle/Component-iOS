//
//  NSObject+ListDiffable.swift
//  Component
//
//  Created by Tanakorn Phoochaliaw on 13/7/2564 BE.
//

import Foundation
import IGListKit

// MARK: - ListDiffable
extension NSObject: ListDiffable {
    public func diffIdentifier() -> NSObjectProtocol {
        return self
    }
    
    public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return isEqual(object)
    }
}
