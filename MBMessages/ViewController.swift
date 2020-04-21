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
        MBInAppMessageManager.presentMessages([MBInAppMessage.demoMessage(style: .bannerTop)])
    }
    
    @IBAction func bottomBannerTapped() {
        MBInAppMessageManager.presentMessages([MBInAppMessage.demoMessage(style: .bannerBottom)])
    }
    
    @IBAction func centerTapped() {
        MBInAppMessageManager.presentMessages([MBInAppMessage.demoMessage(style: .center)])
    }
    
    @IBAction func fullscreenImageTapped() {
        MBInAppMessageManager.presentMessages([MBInAppMessage.demoMessage(style: .fullscreenImage)])
    }
}
