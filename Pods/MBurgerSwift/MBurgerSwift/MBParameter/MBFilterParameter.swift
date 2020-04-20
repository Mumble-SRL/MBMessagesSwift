//
//  MBFilterParameter.swift
//  MBurgerSwift
//
//  Created by Alessandro Viviani on 26/09/2019.
//  Copyright © 2019 Mumble S.r.l (https://mumbleideas.it/). All rights reserved.
//

import Foundation

/// A parameter used to filter the elements retuned.
public struct MBFilterParameter: MBParameter {
    /// The field used to filter.
    let field: String

    /// The value used to filter the elements.
    let value: String
    
    /// Initializes a filter parameter.
    /// - Parameters:
    ///   - field: The `field` used to filter.
    ///   - value: The `value` used to filter the elements.
    public init(field: String, value: String) {
        self.field = field
        self.value = value
    }
    
    public func parameterRepresentation() -> [String: Any] {
        let key = "filter[\(field)]"
        return [
            key: value
        ]
    }
}
