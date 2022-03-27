//
//  SecondaryButton.swift
//  Comp
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import Foundation

public class SecondaryButton: UIButton {
    
    private var buttonActionClosure: ((UIButton) -> Void)?
    public var textPadding = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4) {
        didSet {
            setupUI()
        }
    }
    
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
        initialization()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialization()
    }
    
    private func initialization() {
        setupUI()
        setStyle()
        if !(title(for: .normal) ?? "").isEmpty {
            label.text = self.title(for: .normal)
            setTitle("", for: .normal)
            setTitle("", for: .normal)
        }
        addTarget(self, action: #selector(touchDownAction(button:)), for: .touchDown)
        addTarget(self, action: #selector(touchUpInsideAction(button:)), for: .touchUpInside)
        addTarget(self, action: #selector(touchUpOutsideCanceled(button:)), for: .touchUpInside)
        addTarget(self, action: #selector(touchUpOutsideCanceled(button:)), for: .touchUpOutside)
        addTarget(self, action: #selector(touchUpOutsideCanceled(button:)), for: .touchCancel)
    }
    
    private func setupUI() {
        contentView.fitInto(view: self)
        label.fitInto(view: contentView, paddings: textPadding)
    }
    
    private var _buttonColor: UIColor = .appYellow
    public var buttonColor: UIColor {
        get {
            return _buttonColor
        }
        set {
            _buttonColor = newValue
            label.textColor = _buttonColor
        }
    }
    
    private var _buttonActiveColor: UIColor = .appOrange
    public var buttonActiveColor: UIColor {
        get {
            return _buttonActiveColor
        }
        set {
            _buttonActiveColor = newValue
        }
    }
    
    private var _buttonText: String = ""
    public var buttonText: String {
        get {
            return _buttonText
        }
        set {
            _buttonText = newValue
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
            label.textColor = buttonColor
            contentView.backgroundColor = .clear
            contentView.layer.borderColor = buttonColor.cgColor
            contentView.layer.borderWidth = 1.0
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
            label.textColor = .appDisableGray
            contentView.backgroundColor = .clear
            contentView.layer.borderColor = UIColor.appDisableGray.cgColor
            contentView.layer.borderWidth = 1.0
            contentView.alpha = 1.0
        }
    }
    
    @objc func touchUpInsideAction(button: UIButton) {
        guard let receivedButtonActionClosure = buttonActionClosure else { return }
        receivedButtonActionClosure(button)
    }
    
    @objc func touchDownAction(button: UIButton) {
        if isEnabled {
            label.textColor = buttonActiveColor
            contentView.backgroundColor = .clear
            contentView.layer.borderColor = buttonActiveColor.cgColor
            contentView.layer.borderWidth = 1.0
            contentView.alpha = 0.3
        }
    }
    
    @objc func touchUpOutsideCanceled(button: UIButton) {
        if isEnabled {
            setStyle()
        }
    }
    
}
