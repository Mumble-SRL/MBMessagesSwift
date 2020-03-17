//
//  MBInAppMessageView.swift
//  MBurgerInAppMessage
//
//  Created by Lorenzo Oliveto on 17/03/2020.
//  Copyright © 2020 Lorenzo Oliveto. All rights reserved.
//

import UIKit

class MBInAppMessageView: UIView {
    var message: MBInAppMessage!
    
    var contentView: UIView!

    var imageView: UIImageView?
    var titleLabel: UILabel?
    var bodyLabel: UILabel!
    var button1: UIButton?
    var button2: UIButton?

    init(message: MBInAppMessage) {
        super.init(frame: .zero)
        self.message = message
        configure(withMessage: message)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(withMessage message: MBInAppMessage) {
        fatalError("Implement in subclasses")
    }
    
    func present(overViewController viewController: UIViewController) {
        fatalError("Implement in subclasses")
    }
    
    func hideWithDuration(duration: TimeInterval) {
        performHide(duration: duration)
    }
    
    @objc func hide() {
        performHide(duration: 0.3)
    }
    
    func performHide(duration: TimeInterval) {
        fatalError("Implement in subclasses")
    }
    
    static internal func button(forMessageButton messageButton: MBInAppMessageButton) -> UIButton {
        let button = UIButton(type: .system)
        
        UIView.performWithoutAnimation {
            button.setTitle(messageButton.title, for: .normal)
            button.layoutIfNeeded()
        }
        
        button.layer.cornerRadius = 15
        button.backgroundColor = UIColor(dynamicProvider: { traitCollection in
            if traitCollection.userInterfaceStyle == .dark {
                return UIColor.white
            } else {
                return UIColor.black
            }
        })
        button.tintColor = UIColor(dynamicProvider: { traitCollection in
            if traitCollection.userInterfaceStyle == .dark {
                return UIColor.black
            } else {
                return UIColor.white
            }
        })
        return button
    }
    
    @objc func buttonPressed(_ sender: UIButton) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(hide), object: nil)
        hide()
        if sender == button1 {
            print("call delegate button1")
        } else if sender == button2 {
            print("call delegate button2")
        }
    }

}
