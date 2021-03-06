//
//  MBInAppMessage.swift
//  MBInAppMessage
//
//  Created by Lorenzo Oliveto on 17/03/2020.
//  Copyright © 2020 Lorenzo Oliveto. All rights reserved.
//

import UIKit
import MBurgerSwift

/// The presentation style of the message, this enum represents the style in which the message will appear
public enum MBInAppMessageStyle: Int {
    /// Messages with this style will appear as a banner from the top
    case bannerTop
    /// Messages with this style will appear as a banner from the bottom
    case bannerBottom
    /// Messages with this style will appear as a center message
    case center
    /// Messages with this style will appear as fullscreen images
    case fullscreenImage
    
    /// Returns a `MBInAppMessageStyle` given a `String`, typically coming from APIs.
    /// - Parameters:
    ///   - string: The string to convert.
    /// - Returns: the style corrispondent to the string. If no style matches it returns `MBInAppMessageStyle.center`
    static func styleFromString(_ string: String) -> MBInAppMessageStyle {
        switch string {
        case "banner_top":
            return bannerTop
        case "banner_bottom":
            return bannerBottom
        case "center":
            return center
        case "fullscreen_image":
            return fullscreenImage
        default:
            return center
        }
    }
}

/// This class represents an in app message retrieved by the MBurger in app messages APIs
public class MBInAppMessage: NSObject {
    /// The id of the message
    public let id: Int!
    /// The style of the message
    public let style: MBInAppMessageStyle!
    /// If this is true the message blocks the user from navigating the app
    public let isBlocking: Bool
    /// The duration it will be on screen, after this duration the message will disappear automatically, by default it stays on screen until the user closes it.
    public let duration: TimeInterval!
    /// The title of the message, it's optional and defaults to nil.
    public let title: String?
    /// An optional color for the title, defaults to nil.
    public let titleColor: UIColor?
    /// The body of the message
    public let body: String!
    /// An optional color for the body, defaults to nil.
    public let bodyColor: UIColor?
    /// An optional image of the message, defaults to nil.
    public let image: String?
    /// An optional background color, defaults to nil.
    public let backgroundColor: UIColor?
    /// An array of buttons, max 2 elements
    public let buttons: [MBInAppMessageButton]?
    
    /// Initializes a message with the parameters passed
    public init(id: Int,
                style: MBInAppMessageStyle!,
                isBlocking: Bool,
                duration: TimeInterval? = -1,
                title: String? = nil,
                titleColor: UIColor? = nil,
                body: String!,
                bodyColor: UIColor? = nil,
                image: String? = nil,
                backgroundColor: UIColor? = nil,
                buttons: [MBInAppMessageButton]? = nil) {
        self.id = id
        self.style = style
        self.isBlocking = isBlocking
        self.duration = duration ?? -1
        self.title = title
        self.titleColor = titleColor
        self.body = body
        self.bodyColor = bodyColor
        self.image = image
        self.backgroundColor = backgroundColor
        self.buttons = buttons
    }
    
    /// Initializes a message with the dictionary returned by the APIs
    convenience init(dictionary: [String: Any]) {
        let id = dictionary["id"] as? Int ?? 0
        let styleString = dictionary["type"] as? String ?? ""
        let style = MBInAppMessageStyle.styleFromString(styleString)
        let isBlocking = dictionary["is_blocking"] as? Bool ?? false
        let duration = !(dictionary["duration"] is NSNull) ? dictionary["duration"] as? Int : nil
        let title = dictionary["title"] as? String
        let titleColor = MBInAppMessage.colorFromField(dictionary: dictionary, key: "title_color")
        let body = dictionary["content"] as? String
        let bodyColor = MBInAppMessage.colorFromField(dictionary: dictionary, key: "content_color")
        let backgroundColor = MBInAppMessage.colorFromField(dictionary: dictionary, key: "background_color")
        let image = dictionary["image"] as? String
        let button1Title = !(dictionary["cta_text"] is NSNull) ? dictionary["cta_text"] as? String : nil
        let button1TitleColor = MBInAppMessage.colorFromField(dictionary: dictionary, key: "cta_text_color")
        let button1BackgroundColor = MBInAppMessage.colorFromField(dictionary: dictionary, key: "cta_background_color")
        let button1Link = !(dictionary["cta_action"] is NSNull) ? dictionary["cta_action"] as? String : nil
        let button1LinkType = !(dictionary["cta_action_type"] is NSNull) ? dictionary["cta_action_type"] as? String : nil
        var buttons = [MBInAppMessageButton]()
        if let button1Title = button1Title,
            let button1LinkType = button1LinkType {
            let linkType = MBInAppMessageButtonLinkType.butttonLinkType(button1LinkType)
            var sectionId: Int?
            var blockId: Int?
            if linkType == .section {
                (sectionId, blockId) = MBInAppMessage.sectionBlockIdFromField(dictionary: dictionary, key: "cta_action")
            }
            buttons.append(MBInAppMessageButton(title: button1Title,
                                                titleColor: button1TitleColor,
                                                backgroundColor: button1BackgroundColor,
                                                link: button1Link,
                                                linkType: linkType,
                                                sectionId: sectionId,
                                                blockId: blockId))
        }
        let button2Title = !(dictionary["cta2_text"] is NSNull) ? dictionary["cta2_text"] as? String : nil
        let button2TitleColor = MBInAppMessage.colorFromField(dictionary: dictionary, key: "cta2_text_color")
        let button2BackgroundColor = MBInAppMessage.colorFromField(dictionary: dictionary, key: "cta2_background_color")
        let button2Link = !(dictionary["cta2_action"] is NSNull) ? dictionary["cta2_action"] as? String : nil
        let button2LinkType = !(dictionary["cta2_action_type"] is NSNull) ? dictionary["cta2_action_type"] as? String : nil
        if let button2Title = button2Title,
            let button2LinkType = button2LinkType {
            let linkType = MBInAppMessageButtonLinkType.butttonLinkType(button2LinkType)
            var sectionId: Int?
            var blockId: Int?
            if linkType == .section {
                (sectionId, blockId) = MBInAppMessage.sectionBlockIdFromField(dictionary: dictionary, key: "cta2_action")
            }
            buttons.append(MBInAppMessageButton(title: button2Title,
                                                titleColor: button2TitleColor,
                                                backgroundColor: button2BackgroundColor,
                                                link: button2Link,
                                                linkType: linkType,
                                                sectionId: sectionId,
                                                blockId: blockId))
        }
        self.init(id: id,
                  style: style,
                  isBlocking: isBlocking,
                  duration: duration != nil ? TimeInterval(duration!) : nil,
                  title: title,
                  titleColor: titleColor,
                  body: body,
                  bodyColor: bodyColor,
                  image: image,
                  backgroundColor: backgroundColor,
                  buttons: buttons.count != 0 ? buttons : nil)
    }
    
    /// Parse the field of the dictionary with the key and returns sectionId/blockId if present
    private static func sectionBlockIdFromField(dictionary: [String: Any],
                                                key: String) -> (Int?, Int?) {
        var sectionId: Int?
        var blockId: Int?
        if let sectionIdInt = dictionary[key] as? Int {
            sectionId = sectionIdInt
        } else if let actionString = dictionary[key] as? String {
            if let sectionIdInt = Int(actionString) {
                sectionId = sectionIdInt
            } else if let data = actionString.data(using: .utf8) {
                do {
                    if let actionDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        sectionId = actionDictionary["section_id"] as? Int
                        blockId = actionDictionary["block_id"] as? Int
                    }
                } catch {}
            }
        }
        return (sectionId, blockId)
    }
    
    /// Returns a color from the field of the dictionary with the key passed
    private static func colorFromField(dictionary: [String: Any], key: String) -> UIColor? {
        if dictionary[key] is NSNull {
            return nil
        }
        guard let stringValue = dictionary[key] as? String else {
            return nil
        }
        return MBUtilities.colorWithHexString(hexString: stringValue)
    }
}

/// This class represents the type of link attttached to a button
public enum MBInAppMessageButtonLinkType: Int {
    /// A web link
    case link
    /// An in app link
    case inApp
    /// A link to a section of MBurger
    case section
    
    /// No action
    case noAction

    /// Returns a MBInAppMessageButtonLinkType given a string, ttipically from the APIs
    /// - Parameters:
    ///   - string: The string to convert.
    /// - Returns: the link type corrispondent to the string. If no style matches it returns `MBInAppMessageButtonLinkType.link`
    static func butttonLinkType(_ string: String) -> MBInAppMessageButtonLinkType {
        switch string {
        case "link":
            return link
        case "in_app", "inapp":
            return inApp
        case "section":
            return section
        case "no-action":
            return noAction
        default:
            return noAction
        }
    }
}

/// This class represent a button of an in app message
public class MBInAppMessageButton: NSObject {
    /// The title of the button
    public let title: String!
    /// An optional color for the title
    public let titleColor: UIColor?
    /// An optional background color
    public let backgroundColor: UIColor?
    /// The link of the button
    public let link: String?
    /// The type of link of the button
    public let linkType: MBInAppMessageButtonLinkType!
    /// If the link is a section link, the id of the section
    public let sectionId: Int?
    /// If the link is a section link, the id of the block
    public let blockId: Int?

    /// Initializes a button with the parameters passed
    public init(title: String,
                titleColor: UIColor? = nil,
                backgroundColor: UIColor? = nil,
                link: String?,
                linkType: MBInAppMessageButtonLinkType,
                sectionId: Int?,
                blockId: Int?) {
        self.title = title
        self.titleColor = titleColor
        self.backgroundColor = backgroundColor
        self.link = link
        self.linkType = linkType
        self.sectionId = sectionId
        self.blockId = blockId
    }
}
