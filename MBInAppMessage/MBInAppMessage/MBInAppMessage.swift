//
//  MBInAppMessage.swift
//  MBInAppMessage
//
//  Created by Lorenzo Oliveto on 20/04/2020.
//  Copyright © 2020 Lorenzo Oliveto. All rights reserved.
//

import UIKit
import MBurgerSwift

public class MBInAppMessage: NSObject, MBPluginProtocol {
    weak var delegate: MBIAMMessageViewDelegate?
    weak var styleDelegate: MBIAMMessageViewStyleDelegate?

    override init() {
        super.init()
        checkMessages()
        NotificationCenter.default.addObserver(self, selector: #selector(checkMessages), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc public func checkMessages() {
        //TODO: call api
        print("Call in app messages api")
    }
}
