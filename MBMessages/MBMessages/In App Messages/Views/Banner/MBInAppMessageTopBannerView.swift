//
//  MBInAppMessageTopBannerView.swift
//  MBInAppMessage
//
//  Created by Lorenzo Oliveto on 17/03/2020.
//  Copyright © 2020 Lorenzo Oliveto. All rights reserved.
//

import UIKit

public class MBInAppMessageTopBannerView: MBInAppMessageView {
    
    var topConstraintHidden: NSLayoutConstraint?
    var topConstraintNotHidden: NSLayoutConstraint?

    var gestureHandle: UIView!
    var content: MBInAppMessageBannerContent!
    
    override func configure() {
        layer.cornerRadius = 8
        clipsToBounds = true
                
        let backgroundStyle = styleDelegate?.backgroundStyle(forMessage: message) ?? MBInAppMessageViewStyle.backgroundStyle(forMessage: message)
        
        if backgroundStyle == .translucent {
            let blurEffect = UIBlurEffect(style: .regular)
            contentView = UIVisualEffectView(effect: blurEffect)
            contentView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(contentView)
            NSLayoutConstraint.activate([
                contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
                contentView.topAnchor.constraint(equalTo: topAnchor),
                contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        } else {
            contentView = UIView(frame: .zero)
            contentView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(contentView)
            NSLayoutConstraint.activate([
                contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
                contentView.topAnchor.constraint(equalTo: topAnchor),
                contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
            if let backgroundColor = styleDelegate?.backgroundColor(forMessage: message) {
                contentView.backgroundColor = backgroundColor
            } else {
                contentView.backgroundColor = MBInAppMessageViewStyle.backgroundColor(forMessage: message)
            }
        }

        var targetView = contentView ?? self
        if let contentView = contentView as? UIVisualEffectView {
            targetView = contentView.contentView
        }

        let contentView = MBInAppMessageBannerContent(message: message, styleDelegate: styleDelegate)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        targetView.addSubview(contentView)
        
        self.imageView = contentView.imageView
        self.titleLabel = contentView.titleLabel
        self.bodyLabel = contentView.bodyLabel
        self.button1 = contentView.button1
        self.button2 = contentView.button2
        
        button1?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        button2?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)

        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: targetView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: targetView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: targetView.topAnchor, constant: 0)
        ])

        let handleHeight: CGFloat = 5
        let gestureHandle = UIView(frame: .zero)
        gestureHandle.translatesAutoresizingMaskIntoConstraints = false
        gestureHandle.layer.cornerRadius = handleHeight / 2
        if #available(iOS 13.0, *) {
            gestureHandle.backgroundColor = UIColor.systemFill
        } else {
            gestureHandle.backgroundColor = UIColor.gray
        }
        targetView.addSubview(gestureHandle)
        
        NSLayoutConstraint.activate([
            gestureHandle.centerXAnchor.constraint(equalTo: targetView.centerXAnchor),
            gestureHandle.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 10),
            gestureHandle.widthAnchor.constraint(equalToConstant: 80),
            gestureHandle.heightAnchor.constraint(equalToConstant: handleHeight),
            gestureHandle.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
        self.gestureHandle = gestureHandle
        
        let panGesture = UIPanGestureRecognizer.init(target: self, action: #selector(handleDismiss(_:)))
        panGesture.delegate = self
        addGestureRecognizer(panGesture)
    }
    
    override func present() {
        guard let window = UIApplication.shared.windows.first else {
            return
        }
        window.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        
        let topConstraintHidden = self.bottomAnchor.constraint(equalTo: window.topAnchor)
        var topConstraintNotHidden: NSLayoutConstraint!
        if #available(iOS 11.0, *) {
            topConstraintNotHidden = self.topAnchor.constraint(equalTo: window.safeAreaLayoutGuide.topAnchor, constant: 8)
        } else {
            topConstraintNotHidden = self.topAnchor.constraint(equalTo: window.topAnchor, constant: 8)
        }

        self.topConstraintHidden = topConstraintHidden
        self.topConstraintNotHidden = topConstraintNotHidden

        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: 8),
            trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: -8),
            topConstraintHidden,
            heightAnchor.constraint(greaterThanOrEqualToConstant: 60)
        ])
                
        window.layoutIfNeeded()
        
        topConstraintHidden.isActive = false
        topConstraintNotHidden.isActive = true
        delegate?.viewWillAppear(view: self)
        UIView.animate(withDuration: 0.3, animations: {
            window.layoutIfNeeded()
        }, completion: { _ in
            self.delegate?.viewDidAppear(view: self)
        })
        
        if message.duration != -1 {
            self.perform(#selector(hide), with: nil, afterDelay: message.duration)
        }
    }
    
    override func performHide(duration: TimeInterval, callCompletionBlock: Bool) {
        topConstraintNotHidden?.isActive = false
        topConstraintHidden?.isActive = true
        delegate?.viewWillDisappear(view: self)
        UIView.animate(withDuration: duration, animations: {
            self.superview?.layoutIfNeeded()
        }, completion: { _ in
            self.delegate?.viewDidDisappear(view: self)
            if callCompletionBlock {
                if let completionBlock = self.completionBlock {
                    completionBlock()
                }
            }
            self.removeFromSuperview()
        })
    }
    
    // MARK: - Gesture
    
    var initialTouchPoint: CGPoint = CGPoint.zero
    
    @objc func handleDismiss(_ gesture: UIPanGestureRecognizer) {
        guard let view = gesture.view?.superview else {
            return
        }
        let touchPoint = gesture.location(in: view)
        
        switch gesture.state {
        case .began:
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(hide), object: nil)
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(hideWithoutCallingCompletionBlock), object: nil)
            initialTouchPoint = touchPoint
        case .changed:
            topConstraintNotHidden?.constant = min(8 - (initialTouchPoint.y - touchPoint.y), 8)
            self.superview?.layoutIfNeeded()
        case .ended, .cancelled:
            if initialTouchPoint.y - touchPoint.y > 30 {
                let height = self.frame.height + 8
                let remainingHeight = height - (initialTouchPoint.y - touchPoint.y)
                let perc = remainingHeight / height
                hideWithDuration(duration: TimeInterval(max(perc * 0.3, 0)))
            } else {
                topConstraintNotHidden?.constant = 8
                UIView.animate(withDuration: 0.2, animations: {
                    self.superview?.layoutIfNeeded()
                }, completion: { _ in
                    if self.message.duration != -1 {
                        self.perform(#selector(self.hide), with: nil, afterDelay: self.message
                            .duration)
                    }
                })
            }
        case .failed, .possible:
            break
        default:
            break
        }
    }

}

extension MBInAppMessageTopBannerView: UIGestureRecognizerDelegate {
    public override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        guard let topConstraintNotHidden = topConstraintNotHidden else {
            return false
        }
        return topConstraintNotHidden.isActive
    }
    
}
