//
//  MBInAppMessageFullscreenImageView.swift
//  MBurgerInAppMessage
//
//  Created by Lorenzo Oliveto on 10/04/2020.
//  Copyright © 2020 Lorenzo Oliveto. All rights reserved.
//

import UIKit

class MBInAppMessageFullscreenImageView: MBInAppMessageView {
    var backgroundView: UIView?
    
    var bottomConstraintHidden: NSLayoutConstraint?
    var centerConstraintNotHidden: NSLayoutConstraint?
    
    var closeButton: UIButton!

    override func configure() {
        layer.cornerRadius = 8
        clipsToBounds = true
        guard let messageImage = message.image else {
            configure(image: nil)
            return
        }
        MBInAppMessageImageLoader.loadImage(url: messageImage) { [weak self] image in
            if let strongSelf = self {
                strongSelf.configure(image: image)
            }
        }
    }
    
    private func configure(image: UIImage?) {
        let padding: CGFloat = 20

        contentView = UIView(frame: .zero)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        contentView.backgroundColor = UIColor.clear
        
        if let image = image {
            let imageView = UIImageView(frame: .zero)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            contentView.addSubview(imageView)
            let aspectRatio = image.size.width / image.size.height
            NSLayoutConstraint.activate([
                imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
                imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: aspectRatio)
            ])
            imageView.image = image
            self.imageView = imageView
        }

        let closeButton = UIButton(type: .system)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(closeButton)
        closeButton.tintColor = styleDelegate?.closeButtonColor(forMessage: message) ?? MBInAppMessageViewStyle.button1BackgroundColor(forMessage: message)
        
        UIView.performWithoutAnimation {
            closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
            closeButton.layoutIfNeeded()
        }
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            closeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            closeButton.widthAnchor.constraint(equalToConstant: 44),
            closeButton.heightAnchor.constraint(equalTo: closeButton.widthAnchor)
        ])
        closeButton.addTarget(self, action: #selector(closePressed), for: .touchUpInside)
        self.closeButton = closeButton
        
        if let buttons = message.buttons {
            if buttons.count > 2 {
                fatalError("Are allowed only a max of 2 buttons")
            }
            var lastButton: UIView?
            for (index, button) in buttons.enumerated().reversed() {
                let font = styleDelegate?.buttonsTextFont(forMessage: message) ?? MBInAppMessageViewStyle.buttonsTextFont(forMessage: message)
                var backgroundColor: UIColor! = UIColor.white
                var textColor: UIColor! = UIColor.white
                var borderColor: UIColor?
                if index == 0 {
                    backgroundColor = styleDelegate?.button1BackgroundColor(forMessage: message) ??
                        MBInAppMessageViewStyle.button1BackgroundColor(forMessage: message)
                    textColor = styleDelegate?.button1TextColor(forMessage: message) ?? MBInAppMessageViewStyle.button1TextColor(forMessage: message)
                } else {
                    backgroundColor = styleDelegate?.button2BackgroundColor(forMessage: message) ??
                        MBInAppMessageViewStyle.button2BackgroundColor(forMessage: message)
                    textColor = styleDelegate?.button2TextColor(forMessage: message) ?? MBInAppMessageViewStyle.button2TextColor(forMessage: message)
                    borderColor = styleDelegate?.button2BorderColor(forMessage: message) ?? MBInAppMessageViewStyle.button2BorderColor(forMessage: message)
                }
                let button = MBInAppMessageViewStyle.button(forMessageButton: button, backgroundColor: backgroundColor, textColor: textColor, borderColor: borderColor, font: font, height: 44)
                button.translatesAutoresizingMaskIntoConstraints = false
                contentView.addSubview(button)
                NSLayoutConstraint.activate([
                    button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
                    button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
                    button.heightAnchor.constraint(equalToConstant: 44),
                    button.bottomAnchor.constraint(equalTo: lastButton?.topAnchor ?? contentView.bottomAnchor, constant: index != 0 ? -padding : -8)
                ])
                if index == 0 {
                    self.button1 = button
                }
                if index == 1 {
                    self.button2 = button
                }
                lastButton = button
            }
        }
        
        button1?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        button2?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
    }
    
    override func present(overViewController viewController: UIViewController) {
        let backgroundView = UIView(frame: .zero)
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        viewController.view.addSubview(backgroundView)
        backgroundView.alpha = 0
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundView = backgroundView
        
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor),
            backgroundView.topAnchor.constraint(equalTo: viewController.view.topAnchor)
        ])

        viewController.view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        
        let bottomConstraintHidden = self.topAnchor.constraint(equalTo: viewController.view.bottomAnchor)
        let centerConstraintNotHidden = self.centerYAnchor.constraint(equalTo: viewController.view.centerYAnchor)
        
        self.bottomConstraintHidden = bottomConstraintHidden
        self.centerConstraintNotHidden = centerConstraintNotHidden
        
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor, constant: 20),
            trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor, constant: -20),
            bottomConstraintHidden,
            heightAnchor.constraint(greaterThanOrEqualToConstant: 60)
        ])
        
        viewController.view.layoutIfNeeded()
        
        bottomConstraintHidden.isActive = false
        centerConstraintNotHidden.isActive = true
        delegate?.viewWillAppear(view: self)
        UIView.animate(withDuration: 0.3, animations: {
            viewController.view.layoutIfNeeded()
            backgroundView.alpha = 1
        }, completion: { _ in
            self.delegate?.viewDidAppear(view: self)
        })
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(backgroundViewPressed))
        backgroundView.addGestureRecognizer(tap)
        
        if message.duration != -1 {
            self.perform(#selector(hide), with: nil, afterDelay: message.duration)
        }
    }
    
    override func performHide(duration: TimeInterval) {
        centerConstraintNotHidden?.isActive = false
        bottomConstraintHidden?.isActive = true
        
        delegate?.viewWillDisappear(view: self)
        UIView.animate(withDuration: duration, animations: {
            self.superview?.layoutIfNeeded()
            self.backgroundView?.alpha = 0
        }, completion: { _ in
            self.delegate?.viewDidDisappear(view: self)
            self.removeFromSuperview()
            self.backgroundView?.removeFromSuperview()
            self.backgroundView = nil
        })
    }
    
    @objc func backgroundViewPressed() {
        hide()
    }

    @objc func closePressed() {
        hide()
    }

}
