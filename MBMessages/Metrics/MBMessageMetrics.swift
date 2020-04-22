//
//  MBMessageMetrics.swift
//  MBMessages
//
//  Created by Lorenzo Oliveto on 22/04/2020.
//  Copyright © 2020 Lorenzo Oliveto. All rights reserved.
//

import UIKit
import MBurgerSwift
import MBNetworkingSwift

enum MBMessageMetricsMetricType: String {
    case push
    case message
}

enum MBMessageMetricsMetric: String {
    case view
    case interaction
}

class MBMessageMetrics: NSObject {
    static func applicationDidFinishLaunchingWithOptions(launchOptions: [UIApplication.LaunchOptionsKey: Any]?, userDidInteractWithNotificationBlock: (([String: AnyHashable]) -> Void)?) {
        if let userInfo = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as? [String: AnyHashable] {
            if let userDidInteractWithNotificationBlock = userDidInteractWithNotificationBlock {
                userDidInteractWithNotificationBlock(userInfo)
            }
            checkNotificationPayload(userInfo: userInfo, forMetric: .interaction)
        }
    }
    
    static func userNotificationCenter(willPresent notification: UNNotification) {
        if let userInfo = notification.request.content.userInfo as? [String: AnyHashable] {
            checkNotificationPayload(userInfo: userInfo, forMetric: .view)
        }
    }
    
    public static func userNotificationCenter(didReceive response: UNNotificationResponse, userDidInteractWithNotificationBlock: (([String: AnyHashable]) -> Void)?) {
        if let userInfo = response.notification.request.content.userInfo as? [String: AnyHashable] {
            if let userDidInteractWithNotificationBlock = userDidInteractWithNotificationBlock {
                userDidInteractWithNotificationBlock(userInfo)
            }
            checkNotificationPayload(userInfo: userInfo, forMetric: .interaction)
        }
    }
    
    internal static func checkNotificationPayload(userInfo: [String: Any],
                                                  forMetric metric: MBMessageMetricsMetric) {
        //TODO: real key and test
        if let notificationId = userInfo["notification_id"] as? Int {
            if metric == .interaction && !pushNotificationViewSent(notificationId: notificationId) {
                createMessageMetricForPush(metric: .view, pushId: notificationId)
            }
            createMessageMetricForPush(metric: metric, pushId: notificationId)
        }
    }
    
    internal static func createMessageMetricForPush(metric: MBMessageMetricsMetric,
                                                    pushId: Int) {
        createMessageMetric(type: .push, metric: metric, pushId: pushId)
    }
    
    internal static func createMessageMetricForMessage(metric: MBMessageMetricsMetric,
                                                       messageId: Int) {
        createMessageMetric(type: .message, metric: metric, messageId: messageId)
    }
    
    private static func createMessageMetric(type: MBMessageMetricsMetricType,
                                            metric: MBMessageMetricsMetric,
                                            pushId: Int? = nil,
                                            messageId: Int? = nil,
                                            success: (() -> Void)? = nil,
                                            failure: ((_ error: Error) -> Void)? = nil) {
        var parameters = [String: Any]()
        parameters["type"] = type.rawValue
        parameters["metric"] = metric.rawValue
        if let pushId = pushId {
            parameters["push_id"] = NSNumber(value: pushId).stringValue
        }
        if let messageId = messageId {
            parameters["message_id"] = NSNumber(value: messageId).stringValue
        }
        MBApiManager.request(withToken: MBManager.shared.apiToken,
                             locale: MBManager.shared.localeString,
                             apiName: "metrics",
                             method: .post,
                             parameters: parameters,
                             development: MBManager.shared.development,
                             success: { _ in
                                if let success = success {
                                    success()
                                }
        }, failure: { error in
            if let failure = failure {
                failure(error)
            }
        })
    }
    
    private static func pushNotificationViewSent(notificationId: Int) -> Bool {
        let userDefaults = UserDefaults.standard
        let viewSentNotificationIds = userDefaults.object(forKey: pushNotificationViewedKey) as? [Int] ?? []
        return viewSentNotificationIds.contains(notificationId)
    }
    
    private static func setPushNotificationViewShowed(notificationId: Int) {
        let userDefaults = UserDefaults.standard
        var viewSentNotificationIds = userDefaults.object(forKey: pushNotificationViewedKey) as? [Int] ?? []
        if !viewSentNotificationIds.contains(notificationId) {
            viewSentNotificationIds.append(notificationId)
            UserDefaults.standard.set(viewSentNotificationIds, forKey: pushNotificationViewedKey)
        }
    }
    
    private static var pushNotificationViewedKey: String {
        return "com.mumble.mburger.messages.pushNotificationViewed"
    }
}
