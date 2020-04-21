//
//  MBTag.swift
//  MBurgerSwift
//
//  Created by Lorenzo Oliveto on 09/04/2020.
//  Copyright © 2020 Mumble S.r.l (https://mumbleideas.it/). All rights reserved.
//

import UIKit

class MBTag: NSObject {
    @objc let key: String!
    @objc var value: String!
    
    @objc init(key: String, value: String!) {
        self.key = key
        self.value = value
    }
    
    convenience init (dictionary: [String: String]) {
        let key = dictionary["key"] ?? ""
        let value = dictionary["value"] ?? ""
        self.init(key: key, value: value)
    }
    
    func toDictoinary() -> [String: String] {
        return ["key": key, "value": value]
    }
    
}
