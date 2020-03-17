
//
//  MBInAppMessageManager.swift
//  MBurgerInAppMessage
//
//  Created by Lorenzo Oliveto on 17/03/2020.
//  Copyright © 2020 Lorenzo Oliveto. All rights reserved.
//

import UIKit

class MBInAppMessageManager: NSObject {
    static func presentMessage(_ message: MBInAppMessage,
                               overViewController viewController: UIViewController) {
        var targetViewController = viewController
        if let navigationController = targetViewController.navigationController {
            targetViewController = navigationController
        } else if let tabBarController = viewController.tabBarController {
            targetViewController = tabBarController
        }
        if message.style == .bannerTop {
            let banner = MBInAppMessageTopBanner(message: message)
            banner.present(overViewController: targetViewController)
        } else if message.style == .bannerBottom {
            let banner = MBInAppMessageBottomBanner(message: message)
            banner.present(overViewController: targetViewController)
        }
    }
}
