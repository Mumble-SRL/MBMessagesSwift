//
//  MBInAppMessageViewStyle.swift
//  MBurgerInAppMessage
//
//  Created by Lorenzo Oliveto on 17/03/2020.
//  Copyright © 2020 Lorenzo Oliveto. All rights reserved.
//

import UIKit

enum MBInAppMessageViewBackgroundStyle {
    case solid
    case translucent
}

internal class MBInAppMessageViewStyle {
    static func backgroundStyle(forMessage message: MBInAppMessage) -> MBInAppMessageViewBackgroundStyle {
        if message.style == .center {
            return .solid
        } else {
            return .translucent
        }
    }
    
    static func backgroundColor(forMessage message: MBInAppMessage) -> UIColor {
        return UIColor.systemBackground
    }
    
    static func textColor(forMessage message: MBInAppMessage) -> UIColor {
        return UIColor(dynamicProvider: { traitCollection in
            if traitCollection.userInterfaceStyle == .dark {
                return UIColor.white
            } else {
                return UIColor.black
            }
        })
    }
    
    static func buttonsBackgroundColor(forMessage message: MBInAppMessage) -> UIColor {
        return UIColor(dynamicProvider: { traitCollection in
            if traitCollection.userInterfaceStyle == .dark {
                return UIColor.white
            } else {
                return UIColor.black
            }
        })
    }
    
    static internal func button(forMessageButton messageButton: MBInAppMessageButton,
                                message: MBInAppMessage,
                                styleDelegate: MBInAppMessageViewStyleDelegate?,
                                height: CGFloat) -> UIButton {
        let button = UIButton(type: .system)
        
        UIView.performWithoutAnimation {
            button.setTitle(messageButton.title, for: .normal)
            button.layoutIfNeeded()
        }
        
        button.titleLabel?.font = styleDelegate?.buttonsTextFont(forMessage: message) ?? self.buttonsTextFont(forMessage: message)
        button.backgroundColor = styleDelegate?.buttonsBackgroundColor(forMessage: message) ?? self.buttonsBackgroundColor(forMessage: message)
        button.tintColor = styleDelegate?.buttonsTextColor(forMessage: message) ?? self.buttonsTextColor(forMessage: message)
        button.layer.cornerRadius = height / 2

        return button
    }

    static func buttonsTextColor(forMessage message: MBInAppMessage) -> UIColor {
        return UIColor(dynamicProvider: { traitCollection in
            if traitCollection.userInterfaceStyle == .dark {
                return UIColor.black
            } else {
                return UIColor.white
            }
        })
    }
    
    static func titleFont(forMessage message: MBInAppMessage) -> UIFont {
        return UIFont.preferredFont(forTextStyle: .headline)
    }
    
    static func bodyFont(forMessage message: MBInAppMessage) -> UIFont {
        return UIFont.preferredFont(forTextStyle: .body)
    }
    
    static func buttonsTextFont(forMessage message: MBInAppMessage) -> UIFont {
        return UIFont.preferredFont(forTextStyle: .body)
    }

}
