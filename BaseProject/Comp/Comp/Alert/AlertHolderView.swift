//
//  AlertHolderView.swift
//  Comp
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import Common

//swiftlint:disable line_length
//swiftlint:disable closure_body_length

public class AlertHolderView: UIView, AlertViewDelegate {
    
    private var alertViews = [AlertView]()
    private var partialShowQueue = [AlertStyle]()
    private var alertViewCenterYConstraint: NSLayoutConstraint!
    private var blockerView: UIView!
    // MARK: This tag is required to define the component that touched to dismiss alert view. Number doesn't matter.
    private let touchDefineTag: Int = 483725

    init() {
        super.init(frame: .zero)
        backgroundColor = UIColor.clear
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(note:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(note:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func keyboardWillShow(note: Notification) {
        guard let currentAlertViewCenterYConstraint = alertViewCenterYConstraint else { return }
        let animData = extractAnimationDataFrom(notification: note)
        currentAlertViewCenterYConstraint.constant = -animData.2 / 2
        UIView.animate(withDuration: animData.0, delay: 0.0, options: animData.1, animations: { [weak self] in
            guard let self = self else { return }
            self.layoutIfNeeded()
            }, completion: nil)
    }
    
    @objc private func keyboardWillHide(note: Notification) {
        guard let currentAlertViewCenterYConstraint = alertViewCenterYConstraint else { return }
        let animData = extractAnimationDataFrom(notification: note)
        currentAlertViewCenterYConstraint.constant = 0.0
        UIView.animate(withDuration: animData.0, delay: 0.0, options: animData.1, animations: { [weak self] in
            guard let self = self else { return }
            self.layoutIfNeeded()
            }, completion: nil)
    }
    
    private func partialDismiss(_ completion: @escaping VoidHandler) {
        if let currentAlertViewCenterYConstraint = alertViewCenterYConstraint {
            currentAlertViewCenterYConstraint.constant = 40.0
        }
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: { [weak self] in
            guard let self = self, let currentAlertView = self.alertViews.last else { return }
            if self.alertViews.count > 1 {
                let previousAlertView = self.alertViews[self.alertViews.count - 2]
                previousAlertView.alpha = 1.0
                previousAlertView.isUserInteractionEnabled = true
                currentAlertView.alpha = 0.0
            }
            self.layoutIfNeeded()
        }) { [weak self] (_) in
            guard let self = self else { return }
            self.alertViewCenterYConstraint = nil
            if !self.alertViews.isEmpty {
                let currentAlertView = self.alertViews.removeLast()
                if let receivedDidDismissCallBack = currentAlertView.didDismissCallBack {
                    receivedDidDismissCallBack()
                }
                if let lastAlertView = self.alertViews.last {
                    self.alertViewCenterYConstraint = lastAlertView.selfYConstraint
                }
                currentAlertView.removeFromSuperview()
                currentAlertView.delegate = nil
                completion()
            }
        }
    }
    
    private func partialShow(style: AlertStyle, completion: ((AlertView?) -> Void)? = nil, didDismiss: VoidHandler? = nil, delay: Double? = nil) {
        let delayDuration = Double(partialShowQueue.count) * 0.3
        partialShowQueue.append(style)
        DispatchQueue.main.asyncAfter(deadline: .now() + delayDuration + delay~) { [weak self] in
            guard let self = self else { return }
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: { [weak self] in
                guard let self = self else { return }
                self.alertViews.forEach({ (alertView) in
                    alertView.alpha = 0.0
                    alertView.isUserInteractionEnabled = false
                })
                self.blockerView.alpha = 1.0
            }) { [weak self] (_) in
                guard let self = self else { return }
                if !self.partialShowQueue.isEmpty {
                    let removedStyle = self.partialShowQueue.removeFirst()
                    let alertView = AlertView(with: removedStyle)
                    alertView.didDismissCallBack = didDismiss
                    alertView.delegate = self
                    self.addSubview(alertView)
                    alertView.widthAnchor.constraint(greaterThanOrEqualToConstant: 10.0).isActive = true
                    alertView.heightAnchor.constraint(greaterThanOrEqualToConstant: 10.0).isActive = true
                    alertView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0.0).isActive = true
                    alertView.selfYConstraint = alertView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 40.0)
                    alertView.selfYConstraint.isActive = true
                    self.layoutIfNeeded()
                    alertView.selfYConstraint.constant = 0.0
                    self.alertViewCenterYConstraint = alertView.selfYConstraint
                    self.alertViews.append(alertView)
                    UIAccessibility.post(notification: .screenChanged, argument: alertView.subviews.first)
                    completion?(alertView)
                    UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: { [weak self] in
                        guard let self = self, let currentAlertView = self.alertViews.last else { return }
                        currentAlertView.alpha = 1.0
                        self.layoutIfNeeded()
                        }, completion: nil)
                }
            }
        }
    }
    
    func showAlertWith(style: AlertStyle, completion: ((AlertView?) -> Void)? = nil, didDismiss: VoidHandler? = nil, delay: Double? = nil) {
        if blockerView == nil {
            blockerView = UIView()
            blockerView.tag = touchDefineTag
            blockerView.alpha = 0.0
            blockerView.backgroundColor = UIColor.black.withAlphaComponent(0.75)
            blockerView.fitInto(view: self)
        }
        partialShow(style: style, completion: completion, didDismiss: didDismiss, delay: delay)
    }
    
    public func dismissAlert() {
        partialDismiss { [weak self] in
            guard let self = self else { return }
            if self.alertViews.isEmpty && self.partialShowQueue.isEmpty {
                UIView.animate(withDuration: 0.2, animations: { [weak self] in
                    guard let self = self, let currentBlockerView = self.blockerView else { return }
                    currentBlockerView.alpha = 0.0
                }) { [weak self] (_) in
                    guard let self = self, let currentBlockerView = self.blockerView else { return }
                    currentBlockerView.removeFromSuperview()
                    self.partialShowQueue.removeAll()
                    self.blockerView = nil
                    self.removeFromSuperview()
                    publicResponder = nil
                }
            }
        }
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let firstTouch = touches.first, let touchedView = firstTouch.view else { return }
        if touchedView.tag == touchDefineTag {
            if let lastAlertView = self.alertViews.last {
                if lastAlertView.shouldDismissWhenTappedAround {
                    dismissAlert()
                } else {
                    findFirstResponderAndDismiss()
                }
            }
        }
    }
    
    private func findFirstResponderAndDismiss() {
        if let alertView = self.subviews.filter({ $0.isKind(of: AlertView.self)}).first as? AlertView {
            alertView.dismissFirstResponder()
        }
    }
}

// MARK: Private helper

private extension AlertHolderView {
    //swiftlint:disable large_tuple
    func extractAnimationDataFrom(notification: Notification) -> (TimeInterval, UIView.AnimationOptions, CGFloat) {
        var animDuration: TimeInterval = 0.25
        var animOption: UIView.AnimationOptions = .curveEaseInOut
        var keyboardHeight: CGFloat = 0.0
        if let userInf = notification.userInfo,
            let animationDuration = userInf[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
            let animationCurveInt = userInf[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int,
            let frameEndUser = userInf[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            animDuration = TimeInterval(animationDuration)
            if let animationCurve = UIView.AnimationCurve(rawValue: animationCurveInt) {
                switch animationCurve {
                case .easeInOut:
                    animOption = .curveEaseInOut
                case .easeIn:
                    animOption = .curveEaseIn
                case .easeOut:
                    animOption = .curveEaseOut
                case .linear:
                    animOption = .curveLinear
                default:
                    animOption = .curveEaseOut
                }
            }
            keyboardHeight = frameEndUser.size.height
        }
        return (animDuration, animOption, keyboardHeight)
    }
    
}
