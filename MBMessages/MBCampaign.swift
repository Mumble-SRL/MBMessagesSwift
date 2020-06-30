//
//  MBCampaign.swift
//  MBMessages
//
//  Created by Lorenzo Oliveto on 30/06/2020.
//  Copyright © 2020 Lorenzo Oliveto. All rights reserved.
//

import UIKit

/// The type of the campaign, in app message or push
public enum CampaignType {
    case inAppMessage
    case push
}

/// This object represents a campaign from MBurger
public class MBCampaign: NSObject {
    
    /// The id of the campaign
    public let id: Int
    
    /// The type of the campaign
    public let type: CampaignType
    
    /// If the type of the campaign is message, this is the in app message connected to the campaign
    public let message: MBInAppMessage?
    
    /// If the type of the campaign is push, this is the push message connected to the campaign
    public let push: MBPushMessage?
    
    /// Initializes a campaign with the parameters passed
    init(id: Int,
         type: CampaignType!,
         duration: TimeInterval? = 5,
         message: MBInAppMessage? = nil,
         push: MBPushMessage? = nil) {
        self.id = id
        self.type = type
        self.message = message
        self.push = push
    }
    
    /// Initializes a campaign with the dictionary returned by the APIs
    convenience init(dictionary: [String: Any]) {
        //TODO: implement
        self.init(id: 1, type: .inAppMessage, message: nil, push: nil)
    }
}
