//
//  MBInAppMessage.swift
//  MBInAppMessage
//
//  Created by Lorenzo Oliveto on 17/03/2020.
//  Copyright © 2020 Lorenzo Oliveto. All rights reserved.
//

import UIKit

public enum MBInAppMessageStyle {
    case bannerTop
    case bannerBottom
    case center
    case fullscreenImage
}

public class MBInAppMessage: NSObject {
    let style: MBInAppMessageStyle!
    let duration: TimeInterval!
    let title: String?
    let titleColor: UIColor?
    let body: String!
    let bodyColor: UIColor?
    let image: String?
    let backgroundColor: UIColor?
    let buttons: [MBInAppMessageButton]?
    
    init(style: MBInAppMessageStyle!,
         duration: TimeInterval = 5,
         title: String? = nil,
         titleColor: UIColor? = nil,
         body: String!,
         bodyColor: UIColor? = nil,
         image: String? = nil,
         backgroundColor: UIColor? = nil,
         buttons: [MBInAppMessageButton]? = nil) {
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
    
    //TODO remove
    
    public static func demoMessage(style: MBInAppMessageStyle) -> MBInAppMessage {
        let buttons = [
            MBInAppMessageButton(title: "Button1", link: "https://www.google.it"),
            MBInAppMessageButton(title: "Button2", link: "https://www.mumbleideas.com"),
        ]
        return MBInAppMessage(style: style,
                              title: "Demo title",
                              body: "Lorem Ipsum è un testo segnaposto utilizzato nel settore della tipografia e della stampa. Lorem Ipsum è considerato il testo segnaposto standard sin dal sedicesimo secolo, quando un anonimo tipografo prese",
                              image: "https://www.vegascreativesoftware.com/fileadmin/user_upload/products/vegas_post/1/vegas_image/vegas-image-luminence-key-a-int.jpg",
                              buttons: buttons)
    }
    
    
}

public class MBInAppMessageButton: NSObject {
    let title: String!
    let titleColor: UIColor?
    let backgroundColor: UIColor?
    let link: String!
    
    init(title: String,
         titleColor: UIColor? = nil,
         backgroundColor: UIColor? = nil,
         link: String) {
        self.title = title
        self.titleColor = titleColor
        self.backgroundColor = backgroundColor
        self.link = link
    }
}