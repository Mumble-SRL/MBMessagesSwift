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
    case inapp
}

enum MBMessageMetricsMetric: String {
    case view
    case interaction
}

class MBMessageMetrics: NSObject {
    static func applicationDidFinishLaunchingWithOptions(launchOptions: [UIApplication.LaunchOptionsKey: Any]?, userDidInteractWithNotificationBlock: (([String: AnyHashable]) -> Void)?, completionBlock: @escaping () -> Void) {
        if let userInfo = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as? [String: AnyHashable] {
            if let userDidInteractWithNotificationBlock = userDidInteractWithNotificationBlock {
                userDidInteractWithNotificationBlock(userInfo)
            }
            checkNotificationPayload(userInfo: userInfo, forMetric: .interaction, completionBlock: completionBlock)
        } else {
            completionBlock()
        }
    }
    
    static func userNotificationCenter(willPresent notification: UNNotification) {
        if let userInfo = notification.request.content.userInfo as? [String: AnyHashable] {
            checkNotificationPayload(userInfo: userInfo, forMetric: .view, completionBlock: {})
        }
    }
    
    public static func userNotificationCenter(didReceive response: UNNotificationResponse, userDidInteractWithNotificationBlock: (([String: AnyHashable]) -> Void)?) {
        if let userInfo = response.notification.request.content.userInfo as? [String: AnyHashable] {
            if let userDidInteractWithNotificationBlock = userDidInteractWithNotificationBlock {
                userDidInteractWithNotificationBlock(userInfo)
            }
            checkNotificationPayload(userInfo: userInfo, forMetric: .interaction, completionBlock: {})
        }
    }
    
    internal static func checkNotificationPayload(userInfo: [String: Any],
                                                  forMetric metric: MBMessageMetricsMetric,
                                                  completionBlock: @escaping () -> Void) {
        if let notificationId = userInfo["push_id"] as? String {
            if metric == .interaction && !pushNotificationViewSent(notificationId: notificationId) {
                createMessageMetricForPush(metric: .view, pushId: notificationId, completionBlock: {
                    createMessageMetricForPush(metric: metric,
                                               pushId: notificationId,
                                               completionBlock: completionBlock)
                })
            } else {
                createMessageMetricForPush(metric: metric,
                                           pushId: notificationId,
                                           completionBlock: completionBlock)
            }
        } else {
            completionBlock()
        }
    }
    
    internal static func createMessageMetricForPush(metric: MBMessageMetricsMetric,
                                                    pushId: String,
                                                    completionBlock: @escaping () -> Void) {
        createMessageMetric(type: .push, metric: metric, pushId: pushId, success: {
            completionBlock()
        }, failure: { _ in
            completionBlock()
        })
    }
    
    internal static func createMessageMetricForInAppMessage(metric: MBMessageMetricsMetric,
                                                            messageId: Int) {
        createMessageMetric(type: .inapp, metric: metric, messageId: messageId)
    }
    
    private static func createMessageMetric(type: MBMessageMetricsMetricType,
                                            metric: MBMessageMetricsMetric,
                                            pushId: String? = nil,
                                            messageId: Int? = nil,
                                            success: (() -> Void)? = nil,
                                            failure: ((_ error: Error) -> Void)? = nil) {
        var parameters = [String: Any]()
        parameters["type"] = type.rawValue
        parameters["metric"] = metric.rawValue
        if let pushId = pushId {
            parameters["push_id"] = pushId
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
    
    private static func pushNotificationViewSent(notificationId: String) -> Bool {
        let userDefaults = UserDefaults.standard
        let viewSentNotificationIds = userDefaults.object(forKey: pushNotificationViewedKey) as? [String] ?? []
        return viewSentNotificationIds.contains(notificationId)
    }
    
    private static func setPushNotificationViewShowed(notificationId: String) {
        let userDefaults = UserDefaults.standard
        var viewSentNotificationIds = userDefaults.object(forKey: pushNotificationViewedKey) as? [String] ?? []
        if !viewSentNotificationIds.contains(notificationId) {
            viewSentNotificationIds.append(notificationId)
            UserDefaults.standard.set(viewSentNotificationIds, forKey: pushNotificationViewedKey)
        }
    }
    
    private static var pushNotificationViewedKey: String {
        return "com.mumble.mburger.messages.pushNotificationViewed"
    }
}
