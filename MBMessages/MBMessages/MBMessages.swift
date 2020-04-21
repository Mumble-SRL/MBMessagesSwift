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
    public weak var delegate: MBMessagesDelegate?
    public weak var viewDelegate: MBInAppMessageViewDelegate?
    public weak var styleDelegate: MBInAppMessageViewStyleDelegate?
    
    public var messagesDelay: TimeInterval = 1
    
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
                             success: { [weak self] response in
                                guard let body = response["body"] as? [[String: Any]] else {
                                    return
                                }
                                let delay = self?.messagesDelay ?? 0
                                let messages = body.map({ MBInAppMessage(dictionary: $0) })
                                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                                    MBInAppMessageManager.presentMessages(messages,
                                                                          delegate: self?.viewDelegate,
                                                                          styleDelegate: self?.styleDelegate)
                                })
            }, failure: { error in
                self.delegate?.inAppMessageCheckFailed(sender: self, error: error)
        })
    }
    
    // MARK: - Push handling
    
    public static var pushToken: String {
        set {
            MBPush.pushToken = newValue
        }
        get {
            return MBPush.pushToken
        }
    }
    
    public static func registerDeviceToPush(deviceToken: Data,
                                            success: (() -> Void)? = nil,
                                            failure: ((_ error: Error?) -> Void)? = nil) {
        MBPush.registerDevice(deviceToken: deviceToken, success: success, failure: failure)
    }
    
    public static func registerPushMessages(toTopic topic: String,
                                            success: (() -> Void)? = nil,
                                            failure: ((_ error: Error?) -> Void)? = nil) {
        MBPush.register(toTopic: topic, success: success, failure: failure)
    }
    
    public static func registerPushMessages(toTopics topics: [String],
                                            success: (() -> Void)? = nil,
                                            failure: ((_ error: Error?) -> Void)? = nil) {
        MBPush.register(toTopics: topics, success: success, failure: failure)
    }
    
    public static func unregisterPushMessages(fromTopic topic: String,
                                              success: (() -> Void)? = nil,
                                              failure: ((_ error: Error?) -> Void)? = nil) {
        MBPush.unregister(fromTopic: topic, success: success, failure: failure)
    }
    
    public static func unregisterPushMessages(fromTopics topics: [String],
                                              success: (() -> Void)? = nil,
                                              failure: ((_ error: Error?) -> Void)? = nil) {
        MBPush.unregister(fromTopics: topics, success: success, failure: failure)
    }
    
    public static func unregisterPushMessagesFromAllTopics(success: (() -> Void)? = nil,
                                                           failure: ((_ error: Error?) -> Void)? = nil) {
        MBPush.unregisterFromAllTopics(success: success, failure: failure)
    }
    
    //TODO: messages analytics: api when push arrives + api when push is tapped
}
