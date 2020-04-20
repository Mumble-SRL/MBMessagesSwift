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
        MBIAMMessageManager.presentMessage(MBIAMMessage.demoMessage(style: .bannerTop), delegate: self, overViewController: self)
    }
    
    @IBAction func bottomBannerTapped() {
        MBIAMMessageManager.presentMessage(MBIAMMessage.demoMessage(style: .bannerBottom), delegate: self, overViewController: self)
    }
    
    @IBAction func centerTapped() {
        MBIAMMessageManager.presentMessage(MBIAMMessage.demoMessage(style: .center), delegate: self, overViewController: self)
    }
    
    @IBAction func fullscreenImageTapped() {
        MBIAMMessageManager.presentMessage(MBIAMMessage.demoMessage(style: .fullscreenImage), delegate: self, overViewController: self)
    }
}

extension ViewController: MBIAMMessageViewDelegate {
    func buttonPressed(view: MBIAMMessageView, button: MBIAMMessageButton) {
        if let link = button.link, let url = URL(string: link) {
            let safariViewController = SFSafariViewController(url: url)
            present(safariViewController, animated: true, completion: nil)
        }
    }
}
