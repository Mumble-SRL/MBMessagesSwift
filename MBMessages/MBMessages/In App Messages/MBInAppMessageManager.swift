//
//  MBInAppMessageManager.swift
//  MBInAppMessage
//
//  Created by Lorenzo Oliveto on 17/03/2020.
//  Copyright © 2020 Lorenzo Oliveto. All rights reserved.
//

import UIKit
import SafariServices

public class MBInAppMessageManager: NSObject {
    static func presentMessages(_ messages: [MBInAppMessage],
                                delegate: MBInAppMessageViewDelegate? = nil,
                                styleDelegate: MBInAppMessageViewStyleDelegate? = nil) {
        guard messages.count != 0 else {
            return
        }
        guard let topMostViewController = topMostViewController() else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.presentMessages(messages,
                                     delegate: delegate,
                                     styleDelegate: styleDelegate)
            }
            return
        }
        presentMessage(atIndex: 0,
                       messages: messages,
                       delegate: delegate,
                       styleDelegate: styleDelegate,
                       overViewController: topMostViewController)
    }

    private static func presentMessage(atIndex index: Int,
                                       messages: [MBInAppMessage],
                                       delegate: MBInAppMessageViewDelegate? = nil,
                                       styleDelegate: MBInAppMessageViewStyleDelegate? = nil,
                                       overViewController viewController: UIViewController) {
        guard index < messages.count else {
            return
        }
        let message = messages[index]
        if message.style == .bannerTop {
            let banner = MBInAppMessageTopBannerView(message: message,
                                                   delegate: delegate,
                                                   styleDelegate: styleDelegate,
                                                   viewController: viewController)
            banner.present(overViewController: viewController)
        } else if message.style == .bannerBottom {
            let banner = MBInAppMessageBottomBannerView(message: message,
                                                      delegate: delegate,
                                                      styleDelegate: styleDelegate,
                                                      viewController: viewController)
            banner.present(overViewController: viewController)
        } else if message.style == .center {
            let centerView = MBInAppMessageCenterView(message: message,
                                                    delegate: delegate,
                                                    styleDelegate: styleDelegate,
                                                    viewController: viewController)
            centerView.present(overViewController: viewController)
        } else if message.style == .fullscreenImage {
            let fullscreenImageview = MBInAppMessageFullscreenImageView(message: message,
                                                                      delegate: delegate,
                                                                      styleDelegate: styleDelegate,
                                                                      viewController: viewController)
            fullscreenImageview.present(overViewController: viewController)
        }
        //TODO: next message
    }
    
    private static func topMostViewController(_ controller: UIViewController? = nil) -> UIViewController? {
        var controller = controller
        if controller == nil {
            if #available(iOS 13.0, *) {
            controller = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController
            } else {
                controller = UIApplication.shared.keyWindow?.rootViewController
            }
        }
        if let navigationController = controller as? UINavigationController {
            return topMostViewController(navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topMostViewController(selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topMostViewController(presented)
        }
        return controller
    }
}
