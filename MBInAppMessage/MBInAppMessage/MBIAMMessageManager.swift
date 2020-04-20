
//
//  MBIAMMessageManager.swift
//  MBInAppMessage
//
//  Created by Lorenzo Oliveto on 17/03/2020.
//  Copyright © 2020 Lorenzo Oliveto. All rights reserved.
//

import UIKit
import SafariServices

public class MBIAMMessageManager: NSObject {
    static var linkOpenerMessageViewDelegate: LinkOpenerMessageViewDelegate?
    
    public static func presentMessage(_ message: MBIAMMessage,
                               delegate: MBIAMMessageViewDelegate? = nil,
                               styleDelegate: MBIAMMessageViewStyleDelegate? = nil,
                               overViewController viewController: UIViewController) {
        var targetViewController = viewController
        if let navigationController = targetViewController.navigationController {
            targetViewController = navigationController
        } else if let tabBarController = viewController.tabBarController {
            targetViewController = tabBarController
        }
        var delegate = delegate
        if delegate == nil {
            self.linkOpenerMessageViewDelegate = LinkOpenerMessageViewDelegate(viewController: viewController)
            delegate = self.linkOpenerMessageViewDelegate
        }
        if message.style == .bannerTop {
            let banner = MBIAMMessageTopBannerView(message: message,
                                                   delegate: delegate,
                                                   styleDelegate: styleDelegate)
            banner.present(overViewController: targetViewController)
        } else if message.style == .bannerBottom {
            let banner = MBIAMMessageBottomBannerView(message: message,
                                                      delegate: delegate,
                                                      styleDelegate: styleDelegate)
            banner.present(overViewController: targetViewController)
        } else if message.style == .center {
            let centerView = MBIAMMessageCenterView(message: message,
                                                    delegate: delegate,
                                                    styleDelegate: styleDelegate)
            centerView.present(overViewController: targetViewController)
        } else if message.style == .fullscreenImage {
            let fullscreenImageview = MBIAMMessageFullscreenImageView(message: message,
                                                                      delegate: delegate,
                                                                      styleDelegate: styleDelegate)
            fullscreenImageview.present(overViewController: targetViewController)
        }
    }
}

internal class LinkOpenerMessageViewDelegate: MBIAMMessageViewDelegate {
    weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func buttonPressed(view: MBIAMMessageView, button: MBIAMMessageButton) {
        if button.link.hasPrefix("http") {
            if let viewController = viewController {
                if let link = button.link, let url = URL(string: link) {
                    let safariViewController = SFSafariViewController(url: url)
                    viewController.present(safariViewController, animated: true, completion: nil)
                    
                }
            }
        }
    }
    
    func viewDidDisappear(view: MBIAMMessageView) {
        // Is this ok?
        MBIAMMessageManager.linkOpenerMessageViewDelegate = nil
    }
}
