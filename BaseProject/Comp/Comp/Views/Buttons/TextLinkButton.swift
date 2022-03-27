//
//  TextLinkButton.swift
//  Comp
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import UIKit

public class TextLinkButton: UIButton {
    
    private var buttonActionClosure: ((UIButton) -> Void)?
    
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 14.0)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.isUserInteractionEnabled = false
        return label
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        updateEnableState()
        addTarget(self, action: #selector(touchDownAction(button:)), for: .touchDown)
        addTarget(self, action: #selector(touchUpInsideAction(button:)), for: .touchUpInside)
        addTarget(self, action: #selector(touchUpOutsideCanceled(button:)), for: .touchUpInside)
        addTarget(self, action: #selector(touchUpOutsideCanceled(button:)), for: .touchUpOutside)
        addTarget(self, action: #selector(touchUpOutsideCanceled(button:)), for: .touchCancel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(label)
        label.fitInto(view: self)
    }
    
    private var _buttonText: String = ""
    public var buttonText: String {
        get {
            return _buttonText
        }
        set {
            _buttonText = newValue
            label.text = _buttonText
            accessibilityLabel = _buttonText.replacingOccurrences(of: "/", with: ",")
        }
    }
    
    private var _enabled: Bool = true
    override public var isEnabled: Bool {
        get {
            return _enabled
        }
        set {
            _enabled = newValue
            updateEnableState()
        }
    }
    
    public func buttonAction(closure: ((UIButton) -> Void)?) {
        buttonActionClosure = closure
    }
    
    private func updateEnableState() {
        isUserInteractionEnabled = isEnabled
        isAccessibilityElement = isEnabled
        if isEnabled {
            label.textColor = .appDarkOrange
        } else {
            label.textColor = .appDisableGray
        }
    }
    
    @objc func touchUpInsideAction(button: UIButton) {
        guard let receivedButtonActionClosure = buttonActionClosure else { return }
        receivedButtonActionClosure(button)
        label.textColor = isEnabled ? .appDarkOrange : .appDisableGray
        label.alpha = 1.0
    }
    
    @objc func touchDownAction(button: UIButton) {
        if isEnabled {
            label.alpha = 0.3
        }
    }
    
    @objc func touchUpOutsideCanceled(button: UIButton) {
        label.textColor = isEnabled ? .appDarkOrange : .appDisableGray
        label.alpha = 1.0
    }
    
}
