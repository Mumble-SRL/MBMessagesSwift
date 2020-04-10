//
//  ViewController.swift
//  MBurgerInAppMessage
//
//  Created by Lorenzo Oliveto on 17/03/2020.
//  Copyright © 2020 Lorenzo Oliveto. All rights reserved.
//

import UIKit
import SafariServices

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "In app messages"
    }

    @IBAction func topBannerTapped() {
        MBInAppMessageManager.presentMessage(MBInAppMessage.demoMessage(style: .bannerTop), delegate: self, overViewController: self)
    }
    
    @IBAction func bottomBannerTapped() {
        MBInAppMessageManager.presentMessage(MBInAppMessage.demoMessage(style: .bannerBottom), delegate: self, overViewController: self)
    }
    
    @IBAction func centerTapped() {
        MBInAppMessageManager.presentMessage(MBInAppMessage.demoMessage(style: .center), delegate: self, overViewController: self)
    }
    
    @IBAction func fullscreenImageTapped() {
        MBInAppMessageManager.presentMessage(MBInAppMessage.demoMessage(style: .fullscreenImage), delegate: self, overViewController: self)
    }
}

extension ViewController: MBInAppMessageViewDelegate {
    func buttonPressed(view: MBInAppMessageView, button: MBInAppMessageButton) {
        if let link = button.link, let url = URL(string: link) {
            let safariViewController = SFSafariViewController(url: url)
            present(safariViewController, animated: true, completion: nil)
        }
    }
}
