//
//  MBIAMMessageViewStyle.swift
//  MBInAppMessage
//
//  Created by Lorenzo Oliveto on 17/03/2020.
//  Copyright © 2020 Lorenzo Oliveto. All rights reserved.
//

import UIKit

public enum MBIAMMessageViewBackgroundStyle {
    case solid
    case translucent
}

internal class MBIAMMessageViewStyle {
    static func backgroundStyle(forMessage message: MBIAMMessage) -> MBIAMMessageViewBackgroundStyle {
        if message.style == .center {
            return .solid
        } else {
            return .translucent
        }
    }
    
    static func backgroundColor(forMessage message: MBIAMMessage) -> UIColor {
        if let backgroundColor = message.backgroundColor {
            return backgroundColor
        }
        if #available(iOS 13.0, *) {
            return UIColor.systemBackground
        } else {
            return UIColor.white
        }
    }
    
    static func titleColor(forMessage message: MBIAMMessage) -> UIColor {
        if let titleColor = message.titleColor {
            return titleColor
        }
        return textColor()
    }
    
    static func bodyColor(forMessage message: MBIAMMessage) -> UIColor {
        if let bodyColor = message.bodyColor {
            return bodyColor
        }
        return textColor()
    }

    private static func textColor() -> UIColor {
        return color(lightColor: UIColor.black, darkColor: UIColor.white)
    }
    
    static func button1BackgroundColor(forMessage message: MBIAMMessage) -> UIColor {
        if let firstButton = message.buttons?.first,
            let firstButtonBackgroundColor = firstButton.backgroundColor {
            return firstButtonBackgroundColor
        }
        return color(lightColor: UIColor.black, darkColor: UIColor.white)
    }
    
    static func button1TitleColor(forMessage message: MBIAMMessage) -> UIColor {
        if let firstButton = message.buttons?.first,
            let firstButtonTitleColor = firstButton.titleColor {
            return firstButtonTitleColor
        }
        return color(lightColor: UIColor.white, darkColor: UIColor.black)
    }
    
    static func button2BackgroundColor(forMessage message: MBIAMMessage) -> UIColor {
        if message.buttons?.count ?? 0 >= 2 {
            let secondButton = message.buttons![1]
            if let secondButtonBackgroundColor = secondButton.backgroundColor {
                return secondButtonBackgroundColor
            }
        }
        return color(lightColor: UIColor.white, darkColor: UIColor.black)
    }
    
    static func button2TitleColor(forMessage message: MBIAMMessage) -> UIColor {
        if message.buttons?.count ?? 0 >= 2 {
            let secondButton = message.buttons![1]
            if let secondButtonTitleColor = secondButton.titleColor {
                return secondButtonTitleColor
            }
        }
        return color(lightColor: UIColor.black, darkColor: UIColor.white)
    }
    
    static func button2BorderColor(forMessage message: MBIAMMessage) -> UIColor? {
        button2TitleColor(forMessage: message)
    }

    static func titleFont(forMessage message: MBIAMMessage) -> UIFont {
        return UIFont.preferredFont(forTextStyle: .headline)
    }
    
    static func bodyFont(forMessage message: MBIAMMessage) -> UIFont {
        return UIFont.preferredFont(forTextStyle: .body)
    }
    
    static func buttonsTextFont(forMessage message: MBIAMMessage) -> UIFont {
        return UIFont.preferredFont(forTextStyle: .body)
    }
    
    static private func color(lightColor: UIColor, darkColor: UIColor) -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor(dynamicProvider: { traitCollection in
                if traitCollection.userInterfaceStyle == .dark {
                    return darkColor
                } else {
                    return lightColor
                }
            })
        } else {
            return lightColor
        }
    }
    
    static internal func button(forMessageButton messageButton: MBIAMMessageButton,
                                backgroundColor: UIColor,
                                titleColor: UIColor,
                                borderColor: UIColor? = nil,
                                font: UIFont,
                                height: CGFloat) -> UIButton {
        let button = UIButton(type: .system)
        
        UIView.performWithoutAnimation {
            button.setTitle(messageButton.title, for: .normal)
            button.layoutIfNeeded()
        }
        
        button.titleLabel?.font = font
        button.backgroundColor = backgroundColor
        button.tintColor = titleColor
        if let borderColor = borderColor {
            button.layer.borderWidth = 1
            button.layer.borderColor = borderColor.cgColor
        }
        button.layer.cornerRadius = height / 2

        return button
    }

}
