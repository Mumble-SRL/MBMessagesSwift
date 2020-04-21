//
//  MBInAppMessage.swift
//  MBInAppMessage
//
//  Created by Lorenzo Oliveto on 17/03/2020.
//  Copyright © 2020 Lorenzo Oliveto. All rights reserved.
//

import UIKit
import MBurgerSwift

public enum MBInAppMessageStyle {
    case bannerTop
    case bannerBottom
    case center
    case fullscreenImage
    
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

public class MBInAppMessage: NSObject {
    let id: Int
    let style: MBInAppMessageStyle!
    let duration: TimeInterval!
    let title: String?
    let titleColor: UIColor?
    let body: String!
    let bodyColor: UIColor?
    let image: String?
    let backgroundColor: UIColor?
    let buttons: [MBInAppMessageButton]?
    
    init(id: Int,
         style: MBInAppMessageStyle!,
         duration: TimeInterval? = 5,
         title: String? = nil,
         titleColor: UIColor? = nil,
         body: String!,
         bodyColor: UIColor? = nil,
         image: String? = nil,
         backgroundColor: UIColor? = nil,
         buttons: [MBInAppMessageButton]? = nil) {
        self.id = id
        self.style = style
        self.duration = duration
        self.title = title
        self.titleColor = titleColor
        self.body = body
        self.bodyColor = bodyColor
        self.image = image
        self.backgroundColor = backgroundColor
        self.buttons = buttons
    }
    
    convenience init(dictionary: [String: Any]) {
        let id = dictionary["id"] as? Int ?? 0
        let styleString = dictionary["type"] as? String ?? ""
        let style = MBInAppMessageStyle.styleFromString(styleString)
        let duration = dictionary["duration"] as? Int
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
            let button1Link = button1Link,
            let button1LinkType = button1LinkType {
            buttons.append(MBInAppMessageButton(title: button1Title,
                                                titleColor: button1TitleColor,
                                                backgroundColor: button1BackgroundColor,
                                                link: button1Link,
                                                linkType: button1LinkType))
        }
        let button2Title = !(dictionary["cta2_text"] is NSNull) ? dictionary["cta2_text"] as? String : nil
        let button2TitleColor = MBInAppMessage.colorFromField(dictionary: dictionary, key: "cta2_text_color")
        let button2BackgroundColor = MBInAppMessage.colorFromField(dictionary: dictionary, key: "cta2_background_color")
        let button2Link = !(dictionary["cta2_action"] is NSNull) ? dictionary["cta2_action"] as? String : nil
        let button2LinkType = !(dictionary["cta2_action_type"] is NSNull) ? dictionary["cta2_action_type"] as? String : nil
        if let button2Title = button2Title,
            let button2Link = button2Link,
            let button2LinkType = button2LinkType {
            buttons.append(MBInAppMessageButton(title: button2Title,
                                                titleColor: button2TitleColor,
                                                backgroundColor: button2BackgroundColor,
                                                link: button2Link,
                                                linkType: button2LinkType))
        }
        self.init(id: id,
                  style: style,
                  duration: duration != nil ? TimeInterval(duration!) : nil,
                  title: title,
                  titleColor: titleColor,
                  body: body,
                  bodyColor: bodyColor,
                  image: image,
                  backgroundColor: backgroundColor,
                  buttons: buttons.count != 0 ? buttons : nil)
    }

    public static func demoMessage(style: MBInAppMessageStyle) -> MBInAppMessage {
        let buttons = [
            MBInAppMessageButton(title: "Button1", link: "https://www.google.it", linkType: "link"),
            MBInAppMessageButton(title: "Button2", link: "https://www.mumbleideas.com", linkType: "link")
        ]
        return MBInAppMessage(id: -1,
                              style: style,
                              title: "Demo title",
                              body: "Lorem Ipsum è un testo segnaposto utilizzato nel settore della tipografia e della stampa. Lorem Ipsum è considerato il testo segnaposto standard sin dal sedicesimo secolo, quando un anonimo tipografo prese",
                              image: "https://www.vegascreativesoftware.com/fileadmin/user_upload/products/vegas_post/1/vegas_image/vegas-image-luminence-key-a-int.jpg",
                              buttons: buttons)
    }
    
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

public enum MBInAppMessageButtonLinkType {
    case link
    case inApp
    
    static func butttonLinkType(_ string: String) -> MBInAppMessageButtonLinkType {
        switch string {
        case "link":
            return link
        case "in_app":
            return inApp
        default:
            return link
        }
    }
}

public class MBInAppMessageButton: NSObject {
    let title: String!
    let titleColor: UIColor?
    let backgroundColor: UIColor?
    let link: String!
    let linkType: MBInAppMessageButtonLinkType!
    
    init(title: String,
         titleColor: UIColor? = nil,
         backgroundColor: UIColor? = nil,
         link: String,
         linkType: String) {
        self.title = title
        self.titleColor = titleColor
        self.backgroundColor = backgroundColor
        self.link = link
        self.linkType = MBInAppMessageButtonLinkType.butttonLinkType(linkType)
    }
}
