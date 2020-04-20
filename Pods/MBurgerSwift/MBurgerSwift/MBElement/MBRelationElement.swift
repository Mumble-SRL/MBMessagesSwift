//
//  MBRelationElement.swift
//  MBurgerSwift
//
//  Created by Alessandro Viviani on 07/10/2019.
//  Copyright © 2019 Mumble S.r.l (https://mumbleideas.it/). All rights reserved.
//

import Foundation

/// This class represents a MBurger relation element.
public class MBRelationElement: MBElement {
    /// The block id of the relation.
    public let blockId: Int
    
    /// The section id of the relation.
    public let sectionId: Int
    
    /// Initializes a relation element with an id, a name, an order and it's value.
    /// - Parameters:
    ///   - elementId: The `id` of the element.
    ///   - elementName: The `name` of the element.
    ///   - order: The `id order` of the element.
    ///   - blockId: The `id` of the block to which is related.
    ///   - sectionId: The `id` of the section to which is related.
    init(elementId: Int, elementName: String, order: Int, blockId: Int, sectionId: Int) {
        self.blockId = blockId
        self.sectionId = sectionId
        super.init(elementId: elementId, elementName: elementName, type: .relation, order: order)
    }
    
    /// Initializes a relation element with the dictionary returned by the api.
    /// - Parameters:
    ///   - dictionary: The `Dictionary` returned from the APIs reponse
    required init(dictionary: [String: Any]) {
        guard let dictValue = dictionary["value"] as? [String: Any] else {
            self.blockId = -1
            self.sectionId = -1
            super.init(dictionary: dictionary)
            return
        }
        
        self.blockId = dictValue["block_id"] as? Int ?? 0
        self.sectionId = dictValue["section_id"] as? Int ?? 0
        super.init(dictionary: dictionary)
    }
    
    enum CodingKeysElement: String, CodingKey {
        case blockId
        case sectionId
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeysElement.self)
        blockId = try container.decode(Int.self, forKey: .blockId)
        sectionId = try container.decode(Int.self, forKey: .sectionId)
        
        try super.init(from: decoder)
    }
    
    override public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeysElement.self)
        
        try container.encode(blockId, forKey: .blockId)
        try container.encode(sectionId, forKey: .sectionId)
    }
}
