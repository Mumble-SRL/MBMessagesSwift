//
//  MBPushMessage.swift
//  MBMessages
//
//  Created by Lorenzo Oliveto on 30/06/2020.
//  Copyright © 2020 Lorenzo Oliveto. All rights reserved.
//

public class MBPushMessage: NSObject {
    /// The id of the message
    public let id: Int!

    /// Initializes a push message with the parameters passed
    init(id: Int) {
        self.id = id
    }

    /// Initializes a message with the dictionary returned by the APIs
    convenience init(dictionary: [String: Any]) {
        let id = dictionary["id"] as? Int ?? 0

        self.init(id: id)
    }
}
