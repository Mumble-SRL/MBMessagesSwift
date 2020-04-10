//
//  INAppMessage.swift
//  MBurgerInAppMessage
//
//  Created by Lorenzo Oliveto on 17/03/2020.
//  Copyright © 2020 Lorenzo Oliveto. All rights reserved.
//

import UIKit

enum MBInAppMessageStyle {
    case bannerTop
    case bannerBottom
    case center
    case fullscreenImage
}

class MBInAppMessage: NSObject {
    let style: MBInAppMessageStyle!
    let duration: TimeInterval!
    let title: String?
    let body: String!
    let image: String?
    let backgroundImage: String?
    let buttons: [MBInAppMessageButton]?
    
    init(style: MBInAppMessageStyle!,
         duration: TimeInterval = 5,
         title: String? = nil,
         body: String!,
         image: String? = nil,
         backgroundImage: String? = nil,
         buttons: [MBInAppMessageButton]? = nil) {
        self.style = style
        self.duration = duration
        self.title = title
        self.body = body
        self.image = image
        self.backgroundImage = backgroundImage
        self.buttons = buttons
    }
    
    //TODO remove
    
    static func demoMessage(style: MBInAppMessageStyle) -> MBInAppMessage {
        let buttons = [
            MBInAppMessageButton(title: "Button1", link: "https://www.google.it"),
            MBInAppMessageButton(title: "Button2", link: "https://www.mumbleideas.com"),
        ]
        return MBInAppMessage(style: style,
                              title: "Demo title",
                              body: "Lorem Ipsum è un testo segnaposto utilizzato nel settore della tipografia e della stampa. Lorem Ipsum è considerato il testo segnaposto standard sin dal sedicesimo secolo, quando un anonimo tipografo prese",
                              image: "https://www.vegascreativesoftware.com/fileadmin/user_upload/products/vegas_post/1/vegas_image/vegas-image-luminence-key-a-int.jpg",
                              //backgroundImage: "https://cdn.pixabay.com/photo/2015/02/24/15/41/dog-647528__340.jpg",
                              buttons: buttons)
    }
    
    
}

class MBInAppMessageButton: NSObject {
    let title: String!
    let link: String!
    
    init(title: String, link: String) {
        self.title = title
        self.link = link
    }
}
