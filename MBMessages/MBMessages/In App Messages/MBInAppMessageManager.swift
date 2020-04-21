
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
    public static func presentMessage(_ message: MBInAppMessage,
                               delegate: MBInAppMessageViewDelegate? = nil,
                               styleDelegate: MBInAppMessageViewStyleDelegate? = nil,
                               overViewController viewController: UIViewController) {
        var targetViewController = viewController
        if let navigationController = targetViewController.navigationController {
            targetViewController = navigationController
        } else if let tabBarController = viewController.tabBarController {
            targetViewController = tabBarController
        }
        if message.style == .bannerTop {
            let banner = MBInAppMessageTopBannerView(message: message,
                                                   delegate: delegate,
                                                   styleDelegate: styleDelegate,
                                                   viewController: targetViewController)
            banner.present(overViewController: targetViewController)
        } else if message.style == .bannerBottom {
            let banner = MBInAppMessageBottomBannerView(message: message,
                                                      delegate: delegate,
                                                      styleDelegate: styleDelegate,
                                                      viewController: targetViewController)
            banner.present(overViewController: targetViewController)
        } else if message.style == .center {
            let centerView = MBInAppMessageCenterView(message: message,
                                                    delegate: delegate,
                                                    styleDelegate: styleDelegate,
                                                    viewController: targetViewController)
            centerView.present(overViewController: targetViewController)
        } else if message.style == .fullscreenImage {
            let fullscreenImageview = MBInAppMessageFullscreenImageView(message: message,
                                                                      delegate: delegate,
                                                                      styleDelegate: styleDelegate,
                                                                      viewController: targetViewController)
            fullscreenImageview.present(overViewController: targetViewController)
        }
    }
}
