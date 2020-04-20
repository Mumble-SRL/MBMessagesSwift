//
//  MBInAppMessageView.swift
//  MBInAppMessage
//
//  Created by Lorenzo Oliveto on 17/03/2020.
//  Copyright © 2020 Lorenzo Oliveto. All rights reserved.
//

import UIKit

protocol MBIAMMessageViewDelegate: class {
    func viewWillAppear(view: MBIAMMessageView)
    func viewDidAppear(view: MBIAMMessageView)
    func viewWillDisappear(view: MBIAMMessageView)
    func viewDidDisappear(view: MBIAMMessageView)
    func buttonPressed(view: MBIAMMessageView, button: MBIAMMessageButton)
}

//TODO: call it when view appears/disappears
extension MBIAMMessageViewDelegate {
    func viewWillAppear(view: MBIAMMessageView) {}
    func viewDidAppear(view: MBIAMMessageView) {}
    func viewWillDisappear(view: MBIAMMessageView) {}
    func viewDidDisappear(view: MBIAMMessageView) {}
}

// MARK: - MBInAppMessageViewStyleDelegate

protocol MBIAMMessageViewStyleDelegate: class {
    func backgroundStyle(forMessage message: MBIAMMessage) -> MBIAMMessageViewBackgroundStyle
    func backgroundColor(forMessage message: MBIAMMessage) -> UIColor
    func titleColor(forMessage message: MBIAMMessage) -> UIColor
    func bodyColor(forMessage message: MBIAMMessage) -> UIColor
    func closeButtonColor(forMessage message: MBIAMMessage) -> UIColor
    func button1BackgroundColor(forMessage message: MBIAMMessage) -> UIColor
    func button1TitleColor(forMessage message: MBIAMMessage) -> UIColor
    func button2BackgroundColor(forMessage message: MBIAMMessage) -> UIColor
    func button2TitleColor(forMessage message: MBIAMMessage) -> UIColor
    func button2BorderColor(forMessage message: MBIAMMessage) -> UIColor?
    func titleFont(forMessage message: MBIAMMessage) -> UIFont
    func bodyFont(forMessage message: MBIAMMessage) -> UIFont
    func buttonsTextFont(forMessage message: MBIAMMessage) -> UIFont
}

extension MBIAMMessageViewStyleDelegate {
    func backgroundStyle(forMessage message: MBIAMMessage) -> MBIAMMessageViewBackgroundStyle {
        return MBIAMMessageViewStyle.backgroundStyle(forMessage: message)
    }
    func backgroundColor(forMessage message: MBIAMMessage) -> UIColor {
        return MBIAMMessageViewStyle.backgroundColor(forMessage: message)
    }
    
    func titleColor(forMessage message: MBIAMMessage) -> UIColor {
        return MBIAMMessageViewStyle.titleColor(forMessage: message)
    }

    func bodyColor(forMessage message: MBIAMMessage) -> UIColor {
        return MBIAMMessageViewStyle.bodyColor(forMessage: message)
    }
    
    func closeButtonColor(forMessage message: MBIAMMessage) -> UIColor {
        return button1BackgroundColor(forMessage: message)
    }
    
    func button1BackgroundColor(forMessage message: MBIAMMessage) -> UIColor {
        return MBIAMMessageViewStyle.button1BackgroundColor(forMessage: message)
    }
    
    func button1TitleColor(forMessage message: MBIAMMessage) -> UIColor {
        return MBIAMMessageViewStyle.button1TitleColor(forMessage: message)
    }
    
    func button2BackgroundColor(forMessage message: MBIAMMessage) -> UIColor {
        return MBIAMMessageViewStyle.button2BackgroundColor(forMessage: message)
    }
    
    func button2TitleColor(forMessage message: MBIAMMessage) -> UIColor {
        return MBIAMMessageViewStyle.button2TitleColor(forMessage: message)
    }
    
    func button2BorderColor(forMessage message: MBIAMMessage) -> UIColor? {
        MBIAMMessageViewStyle.button2BorderColor(forMessage: message)
    }

    func titleFont(forMessage message: MBIAMMessage) -> UIFont {
        return MBIAMMessageViewStyle.titleFont(forMessage: message)
    }
    
    func bodyFont(forMessage message: MBIAMMessage) -> UIFont {
        return MBIAMMessageViewStyle.bodyFont(forMessage: message)
    }
    
    func buttonsTextFont(forMessage message: MBIAMMessage) -> UIFont {
        return MBIAMMessageViewStyle.buttonsTextFont(forMessage: message)
    }
}

// MARK: - MBInAppMessageView

class MBIAMMessageView: UIView {
    var message: MBIAMMessage!
    weak var delegate: MBIAMMessageViewDelegate?
    weak var styleDelegate: MBIAMMessageViewStyleDelegate?
    
    var contentView: UIView!

    var imageView: UIImageView?
    var titleLabel: UILabel?
    var bodyLabel: UILabel!
    var button1: UIButton?
    var button2: UIButton?

    init(message: MBIAMMessage,
         delegate: MBIAMMessageViewDelegate? = nil,
         styleDelegate: MBIAMMessageViewStyleDelegate? = nil) {
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
