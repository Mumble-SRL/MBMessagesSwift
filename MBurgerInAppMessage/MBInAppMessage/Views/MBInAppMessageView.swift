//
//  MBInAppMessageView.swift
//  MBurgerInAppMessage
//
//  Created by Lorenzo Oliveto on 17/03/2020.
//  Copyright © 2020 Lorenzo Oliveto. All rights reserved.
//

import UIKit

protocol MBInAppMessageViewDelegate: class {
    func viewWillAppear(view: MBInAppMessageView)
    func viewDidAppear(view: MBInAppMessageView)
    func viewWillDisappear(view: MBInAppMessageView)
    func viewDidDisappear(view: MBInAppMessageView)
    func buttonPressed(view: MBInAppMessageView, button: MBInAppMessageButton)
}

extension MBInAppMessageViewDelegate {
    func viewWillAppear(view: MBInAppMessageView) {}
    func viewDidAppear(view: MBInAppMessageView) {}
    func viewWillDisappear(view: MBInAppMessageView) {}
    func viewDidDisappear(view: MBInAppMessageView) {}
}

// MARK: - MBInAppMessageViewStyleDelegate

protocol MBInAppMessageViewStyleDelegate: class {
    func backgroundStyle(forMessage message: MBInAppMessage) -> MBInAppMessageViewBackgroundStyle
    func backgroundColor(forMessage message: MBInAppMessage) -> UIColor
    func textColor(forMessage message: MBInAppMessage) -> UIColor
    func closeButtonColor(forMessage message: MBInAppMessage) -> UIColor
    func button1BackgroundColor(forMessage message: MBInAppMessage) -> UIColor
    func button1TextColor(forMessage message: MBInAppMessage) -> UIColor
    func button2BackgroundColor(forMessage message: MBInAppMessage) -> UIColor
    func button2TextColor(forMessage message: MBInAppMessage) -> UIColor
    func button2BorderColor(forMessage message: MBInAppMessage) -> UIColor?
    func titleFont(forMessage message: MBInAppMessage) -> UIFont
    func bodyFont(forMessage message: MBInAppMessage) -> UIFont
    func buttonsTextFont(forMessage message: MBInAppMessage) -> UIFont
}

extension MBInAppMessageViewStyleDelegate {
    func backgroundStyle(forMessage message: MBInAppMessage) -> MBInAppMessageViewBackgroundStyle {
        return MBInAppMessageViewStyle.backgroundStyle(forMessage: message)
    }
    func backgroundColor(forMessage message: MBInAppMessage) -> UIColor {
        return MBInAppMessageViewStyle.backgroundColor(forMessage: message)
    }
    
    func textColor(forMessage message: MBInAppMessage) -> UIColor {
        return MBInAppMessageViewStyle.textColor(forMessage: message)
    }

    func closeButtonColor(forMessage message: MBInAppMessage) -> UIColor {
        return button1BackgroundColor(forMessage: message)
    }
    
    func button1BackgroundColor(forMessage message: MBInAppMessage) -> UIColor {
        return MBInAppMessageViewStyle.button1BackgroundColor(forMessage: message)
    }
    
    func button1TextColor(forMessage message: MBInAppMessage) -> UIColor {
        return MBInAppMessageViewStyle.button1TextColor(forMessage: message)
    }
    
    func button2BackgroundColor(forMessage message: MBInAppMessage) -> UIColor {
        return MBInAppMessageViewStyle.button2BackgroundColor(forMessage: message)
    }
    
    func button2TextColor(forMessage message: MBInAppMessage) -> UIColor {
        return MBInAppMessageViewStyle.button2TextColor(forMessage: message)
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

class MBInAppMessageView: UIView {
    var message: MBInAppMessage!
    weak var delegate: MBInAppMessageViewDelegate?
    weak var styleDelegate: MBInAppMessageViewStyleDelegate?
    
    var contentView: UIView!

    var imageView: UIImageView?
    var titleLabel: UILabel?
    var bodyLabel: UILabel!
    var button1: UIButton?
    var button2: UIButton?

    init(message: MBInAppMessage,
         delegate: MBInAppMessageViewDelegate? = nil, 
         styleDelegate: MBInAppMessageViewStyleDelegate? = nil) {
        super.init(frame: .zero)
        self.message = message
        self.delegate = delegate
        self.styleDelegate = styleDelegate
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        fatalError("Implement in subclasses")
    }
    
    func present(overViewController viewController: UIViewController) {
        fatalError("Implement in subclasses")
    }
    
    func hideWithDuration(duration: TimeInterval) {
        performHide(duration: duration)
    }
    
    @objc func hide() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(hide), object: nil)
        performHide(duration: 0.3)
    }
    
    func performHide(duration: TimeInterval) {
        fatalError("Implement in subclasses")
    }
        
    @objc func buttonPressed(_ sender: UIButton) {
        hide()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            guard let buttons = self.message.buttons else {
                return
            }
            if sender == self.button1 {
                self.delegate?.buttonPressed(view: self, button: buttons[0])
                print("call delegate button1")
            } else if sender == self.button2 {
                self.delegate?.buttonPressed(view: self, button: buttons[1])
                print("call delegate button2")
            }
        }
    }
}
