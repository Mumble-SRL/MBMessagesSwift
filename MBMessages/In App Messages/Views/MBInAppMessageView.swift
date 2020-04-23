//
//  MBInAppMessageView.swift
//  MBInAppMessage
//
//  Created by Lorenzo Oliveto on 17/03/2020.
//  Copyright © 2020 Lorenzo Oliveto. All rights reserved.
//

import UIKit
import SafariServices

public protocol MBInAppMessageViewDelegate: class {
    func viewWillAppear(view: MBInAppMessageView)
    func viewDidAppear(view: MBInAppMessageView)
    func viewWillDisappear(view: MBInAppMessageView)
    func viewDidDisappear(view: MBInAppMessageView)
    func buttonPressed(view: MBInAppMessageView, button: MBInAppMessageButton)
}

public extension MBInAppMessageViewDelegate {
    func viewWillAppear(view: MBInAppMessageView) {}
    func viewDidAppear(view: MBInAppMessageView) {}
    func viewWillDisappear(view: MBInAppMessageView) {}
    func viewDidDisappear(view: MBInAppMessageView) {}
}

// MARK: - MBInAppMessageViewStyleDelegate

public protocol MBInAppMessageViewStyleDelegate: class {
    func backgroundStyle(forMessage message: MBInAppMessage) -> MBInAppMessageViewBackgroundStyle
    func backgroundColor(forMessage message: MBInAppMessage) -> UIColor
    func titleColor(forMessage message: MBInAppMessage) -> UIColor
    func bodyColor(forMessage message: MBInAppMessage) -> UIColor
    func closeButtonColor(forMessage message: MBInAppMessage) -> UIColor
    func button1BackgroundColor(forMessage message: MBInAppMessage) -> UIColor
    func button1TitleColor(forMessage message: MBInAppMessage) -> UIColor
    func button2BackgroundColor(forMessage message: MBInAppMessage) -> UIColor
    func button2TitleColor(forMessage message: MBInAppMessage) -> UIColor
    func button2BorderColor(forMessage message: MBInAppMessage) -> UIColor?
    func titleFont(forMessage message: MBInAppMessage) -> UIFont
    func bodyFont(forMessage message: MBInAppMessage) -> UIFont
    func buttonsTextFont(forMessage message: MBInAppMessage) -> UIFont
}

public extension MBInAppMessageViewStyleDelegate {
    func backgroundStyle(forMessage message: MBInAppMessage) -> MBInAppMessageViewBackgroundStyle {
        return MBInAppMessageViewStyle.backgroundStyle(forMessage: message)
    }
    func backgroundColor(forMessage message: MBInAppMessage) -> UIColor {
        return MBInAppMessageViewStyle.backgroundColor(forMessage: message)
    }
    
    func titleColor(forMessage message: MBInAppMessage) -> UIColor {
        return MBInAppMessageViewStyle.titleColor(forMessage: message)
    }
    
    func bodyColor(forMessage message: MBInAppMessage) -> UIColor {
        return MBInAppMessageViewStyle.bodyColor(forMessage: message)
    }
    
    func closeButtonColor(forMessage message: MBInAppMessage) -> UIColor {
        return button1BackgroundColor(forMessage: message)
    }
    
    func button1BackgroundColor(forMessage message: MBInAppMessage) -> UIColor {
        return MBInAppMessageViewStyle.button1BackgroundColor(forMessage: message)
    }
    
    func button1TitleColor(forMessage message: MBInAppMessage) -> UIColor {
        return MBInAppMessageViewStyle.button1TitleColor(forMessage: message)
    }
    
    func button2BackgroundColor(forMessage message: MBInAppMessage) -> UIColor {
        return MBInAppMessageViewStyle.button2BackgroundColor(forMessage: message)
    }
    
    func button2TitleColor(forMessage message: MBInAppMessage) -> UIColor {
        return MBInAppMessageViewStyle.button2TitleColor(forMessage: message)
    }
    
    func button2BorderColor(forMessage message: MBInAppMessage) -> UIColor? {
        MBInAppMessageViewStyle.button2BorderColor(forMessage: message)
    }
    
    func titleFont(forMessage message: MBInAppMessage) -> UIFont {
        return MBInAppMessageViewStyle.titleFont(forMessage: message)
    }
    
    func bodyFont(forMessage message: MBInAppMessage) -> UIFont {
        return MBInAppMessageViewStyle.bodyFont(forMessage: message)
    }
    
    func buttonsTextFont(forMessage message: MBInAppMessage) -> UIFont {
        return MBInAppMessageViewStyle.buttonsTextFont(forMessage: message)
    }
}

// MARK: - MBInAppMessageView

public class MBInAppMessageView: UIView {
    var message: MBInAppMessage!
    weak var delegate: MBInAppMessageViewDelegate?
    weak var styleDelegate: MBInAppMessageViewStyleDelegate?
    
    var contentView: UIView!
    
    var imageView: UIImageView?
    var titleLabel: UILabel?
    var bodyLabel: UILabel!
    var button1: UIButton?
    var button2: UIButton?
    
    weak var viewController: UIViewController?
    
    /// Completion block called by the manager to display next messages if no button is pressed and the message view is dismissed
    var completionBlock: (() -> Void)?
    
    init(message: MBInAppMessage,
         delegate: MBInAppMessageViewDelegate? = nil,
         styleDelegate: MBInAppMessageViewStyleDelegate? = nil,
         viewController: UIViewController? = nil) {
        super.init(frame: .zero)
        self.message = message
        self.delegate = delegate
        self.styleDelegate = styleDelegate
        self.viewController = viewController
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        fatalError("Implement in subclasses")
    }
    
    func present() {
        fatalError("Implement in subclasses")
    }
    
    func hideWithDuration(duration: TimeInterval) {
        performHide(duration: duration, completionBlock: self.completionBlock)
    }
    
    @objc func hide() {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        if self.superview != nil {
            performHide(duration: 0.3, completionBlock: self.completionBlock)
        }
    }
    
    /// Used when a button is pressed, the completion block of the view is not called, but the one passed yes
    @objc func hideWithoutCallingCompletionBlock(completionBlock: (() -> Void)?) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        if self.superview != nil {
            performHide(duration: 0.3, completionBlock: completionBlock)
        }
    }
    
    func performHide(duration: TimeInterval,
                     completionBlock: (() -> Void)? = nil) {
        fatalError("Implement in subclasses")
    }
    
    @objc func buttonPressed(_ sender: UIButton) {
        MBMessageMetrics.createMessageMetricForMessage(metric: .interaction, messageId: message.id)
        hideWithoutCallingCompletionBlock {
            guard let buttons = self.message.buttons else {
                return
            }
            if sender == self.button1 {
                if let delegate = self.delegate {
                    delegate.buttonPressed(view: self, button: buttons[0])
                    print("call delegate button1")
                } else {
                    self.openLink(link: buttons[0].link)
                }
            } else if sender == self.button2 {
                if let delegate = self.delegate {
                    delegate.buttonPressed(view: self, button: buttons[1])
                    print("call delegate button2")
                } else {
                    self.openLink(link: buttons[1].link)
                }
            }
        }
    }
    
    private func openLink(link: String) {
        if link.hasPrefix("http") {
            if let viewController = viewController {
                if let url = URL(string: link) {
                    let safariViewController = SFSafariViewController(url: url)
                    viewController.present(safariViewController, animated: true, completion: nil)
                }
            }
        }
    }
}