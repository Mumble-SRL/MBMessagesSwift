//
//  MBInAppMessage.swift
//  MBInAppMessage
//
//  Created by Lorenzo Oliveto on 20/04/2020.
//  Copyright © 2020 Lorenzo Oliveto. All rights reserved.
//

import UIKit
import MBurgerSwift
import MBNetworkingSwift

public protocol MBMessagesDelegate: class {
    func inAppMessageCheckFailed(sender: MBMessages, error: Error?)
}

public class MBMessages: NSObject, MBPluginProtocol {
    weak var delegate: MBMessagesDelegate?
    weak var viewDelegate: MBInAppMessageViewDelegate?
    weak var styleDelegate: MBInAppMessageViewStyleDelegate?
    
    override public init() {
        super.init()
        checkMessages()
        NotificationCenter.default.addObserver(self, selector: #selector(checkMessages), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc public func checkMessages() {
        MBApiManager.request(withToken: MBManager.shared.apiToken,
                             locale: MBManager.shared.localeString,
                             apiName: "messages",
                             method: .get,
                             development: MBManager.shared.development,
                             encoding: URLParameterEncoder.queryItems,
                             success: { response in
                                print(response)
        }, failure: { error in
            self.delegate?.inAppMessageCheckFailed(sender: self, error: error)
        })
    }
    
}
