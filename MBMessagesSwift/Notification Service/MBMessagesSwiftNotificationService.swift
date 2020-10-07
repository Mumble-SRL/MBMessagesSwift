//
//  MBMessagesSwiftNotificationService.swift
//  MBMessagesSwift
//
//  Created by Lorenzo Oliveto on 07/10/2020.
//  Copyright © 2020 Lorenzo Oliveto. All rights reserved.
//

import UIKit
import UserNotifications

public class MBMessagesSwiftNotificationService: NSObject {
    public static func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
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
