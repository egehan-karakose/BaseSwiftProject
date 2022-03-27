//
//  PrimaryButton.swift
//  Comp
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import Foundation

public class PrimaryButton: UIButton {
    
    private var buttonActionClosure: ((UIButton) -> Void)?
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8.0
        view.clipsToBounds = true
        view.isUserInteractionEnabled = false
        return view
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.isUserInteractionEnabled = false
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setStyle()
        addTarget(self, action: #selector(touchDownAction(button:)), for: .touchDown)
        addTarget(self, action: #selector(touchUpInsideAction(button:)), for: .touchUpInside)
        addTarget(self, action: #selector(touchUpOutsideCanceled(button:)), for: .touchUpInside)
        addTarget(self, action: #selector(touchUpOutsideCanceled(button:)), for: .touchUpOutside)
        addTarget(self, action: #selector(touchUpOutsideCanceled(button:)), for: .touchCancel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
        setStyle()
        if !(title(for: .normal) ?? "").isEmpty {
            label.text = self.title(for: .normal)
            setTitle("", for: .normal)
            accessibilityLabel = label.text
        }
        addTarget(self, action: #selector(touchDownAction(button:)), for: .touchDown)
        addTarget(self, action: #selector(touchUpInsideAction(button:)), for: .touchUpInside)
        addTarget(self, action: #selector(touchUpOutsideCanceled(button:)), for: .touchUpInside)
        addTarget(self, action: #selector(touchUpOutsideCanceled(button:)), for: .touchUpOutside)
        addTarget(self, action: #selector(touchUpOutsideCanceled(button:)), for: .touchCancel)
    }
    
    private func setupUI() {
        contentView.fitInto(view: self)
        label.fitInto(view: contentView, paddings: UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4))
    }
    
    private var _buttonText: String = ""
    public var buttonText: String {
        get {
            return _buttonText
        }
        set {
            _buttonText = newValue.uppercased(with: Locale(identifier: "tr"))
            label.text = _buttonText
            accessibilityLabel = newValue
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
    
    public func setStyle() {
        if isEnabled {
            label.textColor = .white
            contentView.backgroundColor = .appYellow
            contentView.layer.borderColor = UIColor.clear.cgColor
            contentView.layer.borderWidth = 0.0
            contentView.alpha = 1.0
        } else {
            updateEnableState()
        }
    }
    
    public func buttonAction(closure: ((UIButton) -> Void)?) {
        buttonActionClosure = closure
    }
    
    private func updateEnableState() {
        isUserInteractionEnabled = isEnabled
        if isEnabled {
            setStyle()
        } else {
            label.textColor = .white
            contentView.backgroundColor = .appDisableGray
            contentView.layer.borderColor = UIColor.clear.cgColor
            contentView.layer.borderWidth = 0.0
            contentView.alpha = 1.0
        }
    }
    
    @objc func touchUpInsideAction(button: UIButton) {
        guard let receivedButtonActionClosure = buttonActionClosure else { return }
        receivedButtonActionClosure(button)
    }
    
    @objc func touchDownAction(button: UIButton) {
        if isEnabled {
            label.textColor = .white
            contentView.backgroundColor = .appYellow
            contentView.layer.borderColor = UIColor.clear.cgColor
            contentView.layer.borderWidth = 0.0
            contentView.alpha = 0.3
        }
    }
    
    @objc func touchUpOutsideCanceled(button: UIButton) {
        if isEnabled {
            setStyle()
        }
    }
    
}
