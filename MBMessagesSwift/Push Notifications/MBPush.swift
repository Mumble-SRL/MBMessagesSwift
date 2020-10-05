//
//  MBPush.swift
//  MBMessages
//
//  Created by Lorenzo Oliveto on 21/04/2020.
//  Copyright © 2020 Lorenzo Oliveto. All rights reserved.
//

import UIKit
import MPushSwift
import UserNotifications

/// Wrapper around MPush to access it from the messages plugin
public class MBPush: NSObject {
    static var pushToken: String {
        set {
            MPush.token = newValue
        }
        get {
            return MPush.token
        }
    }
    
    static func registerDevice(deviceToken: Data,
                               success: (() -> Void)? = nil,
                               failure: ((_ error: Error?) -> Void)? = nil) {
        MPush.registerDevice(deviceToken: deviceToken, success: success, failure: failure)
    }
    
    static func register(toTopic topic: MBPTopic,
                         success: (() -> Void)? = nil,
                         failure: ((_ error: Error?) -> Void)? = nil) {
        MPush.register(toTopic: topic, success: success, failure: failure)
    }
    
    static func register(toTopics topics: [MBPTopic],
                         success: (() -> Void)? = nil,
                         failure: ((_ error: Error?) -> Void)? = nil) {
        MPush.register(toTopics: topics, success: success, failure: failure)
    }
    
    static func unregister(fromTopic topic: String,
                           success: (() -> Void)? = nil,
                           failure: ((_ error: Error?) -> Void)? = nil) {
        MPush.unregister(fromTopic: topic, success: success, failure: failure)
    }
    
    static func unregister(fromTopics topics: [String],
                           success: (() -> Void)? = nil,
                           failure: ((_ error: Error?) -> Void)? = nil) {
        MPush.unregister(fromTopics: topics, success: success, failure: failure)
    }
    
    static func unregisterFromAllTopics(success: (() -> Void)? = nil,
                                        failure: ((_ error: Error?) -> Void)? = nil) {
        MPush.unregisterFromAllTopics(success: success, failure: failure)
    }
    
    public static func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        MBMessageMetrics.didReceive(request, withContentHandler: contentHandler)
        let mutableContent = request.content.mutableCopy() as? UNMutableNotificationContent
        
        if let mutableContent = mutableContent {
            if let mediaUrl = request.content.userInfo["media_url"] as? String,
               let fileUrl = URL(string: mediaUrl) {
                let type = request.content.userInfo["media_type"] as? String
                downloadMedia(fileUrl: fileUrl,
                              type: type,
                              request: request,
                              mutableContent: mutableContent) {
                    contentHandler(mutableContent)
                }
            } else {
                contentHandler(mutableContent)
            }
        }
    }
    
    private static func downloadMedia(fileUrl: URL, type: String?,
                                      request: UNNotificationRequest,
                                      mutableContent: UNMutableNotificationContent, completion: @escaping () -> Void) {
        let task = URLSession.shared.downloadTask(with: fileUrl) { (location, _, _) in
            if let location = location {
                let tmpDirectory = NSTemporaryDirectory()
                let tmpUrl = URL(fileURLWithPath: tmpDirectory.appending(fileUrl.lastPathComponent))
                do {
                    try FileManager.default.moveItem(at: location, to: tmpUrl)
                    
                    var options: [String: String]?
                    if let type = type {
                        options = [String: String]()
                        options?[UNNotificationAttachmentOptionsTypeHintKey] = type
                    }
                    if let attachment = try? UNNotificationAttachment(identifier: "media." + fileUrl.pathExtension, url: tmpUrl, options: options) {
                        mutableContent.attachments = [attachment]
                    }
                    completion()
                } catch {
                    completion()
                }
            }
        }
        task.resume()
    }

}

/// A topic for MPush, refers to the MPush documentation
public typealias MBPTopic = MPTopic
