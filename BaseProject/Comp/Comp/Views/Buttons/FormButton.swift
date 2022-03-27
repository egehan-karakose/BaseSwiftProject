//
//  FormButton.swift
//  Comp
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import Foundation
import Common

public enum FormButtonStyle: Int {
    case primary = 1
    case secondary = 2
    case secondaryClear = 3
    case form = 4
}

public protocol FormButtonViewModelEventSource {
    var handler: VoidHandler? { get }
}

public protocol FormButtonViewModelDataSource {
    var style: FormButtonStyle { get }
    var title: String { get }
    var isEnabled: Bool { get }
}

public protocol FormButtonViewModelProtocol: FormButtonViewModelDataSource, FormButtonViewModelEventSource { }

public class FormButtonViewModel: FormButtonViewModelProtocol {
    
    public var style: FormButtonStyle
    public var title: String
    public var isEnabled: Bool = true
    public var handler: VoidHandler?
    
    public init(title: String, isEnabled: Bool = true, style: FormButtonStyle) {
        self.title = title
        self.isEnabled = isEnabled
        self.style = style
    }
    
}

public class FormButton: UIButton {
    
    var viewModel: FormButtonViewModelProtocol?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    init() {
        super.init(frame: CGRect.zero)
        setup()
    }
    
    private func setup() {
        adjustsImageWhenHighlighted = false
        if frame == CGRect.zero {
            let heightConstraint = NSLayoutConstraint(item: self, attribute: .height,
                                                             relatedBy: .equal, toItem: nil,
                                                             attribute: .notAnAttribute, multiplier: 1, constant: 50)
            addConstraint(heightConstraint)
        }
        addTarget(self, action: #selector(touchDownAction(button:)), for: .touchDown)
        addTarget(self, action: #selector(touchUpInsideAction(button:)), for: .touchUpInside)
        addTarget(self, action: #selector(touchUpOutsideCanceled(button:)), for: .touchUpOutside)
        addTarget(self, action: #selector(touchUpOutsideCanceled(button:)), for: .touchCancel)
    }
    
    public func populate(with viewModel: FormButtonViewModelProtocol) {
        self.viewModel = viewModel
        setTitle(viewModel.title, for: .normal)
        isEnabled = viewModel.isEnabled
        if viewModel.style == .primary {
            applyPrimaryStyle()
            setTitle(viewModel.title.uppercased(with: Locale(identifier: "tr")), for: .normal)
        } else if viewModel.style == .secondary {
            applySecondaryStyle()
        } else if viewModel.style == .secondaryClear {
            applySecondaryClearStyle()
        } else if viewModel.style == .form {
            applyFormStyle()
        }
    }
    
    private func applyPrimaryStyle() {
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        setTitleColor(.backgroundWhite, for: .normal)
        setTitleColor(.backgroundWhite, for: .disabled)
        setBackgroundImage(UIImage(color: .appYellow), for: .normal)
//        setBackgroundImage(UIImage(color: .appOrange), for: .highlighted)
        setBackgroundImage(UIImage(color: .appLightGray), for: .disabled)
        layer.borderWidth = 0
        layer.cornerRadius = 8
        clipsToBounds = true
    }
    
    private func applySecondaryStyle() {
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        setTitleColor(.appYellow, for: .normal)
//        setTitleColor(.appOrange, for: .highlighted)
        setTitleColor(.appLightGray, for: .disabled)
        
        setBackgroundImage(UIImage(color: .appBackgroundGray), for: .normal)
        setBackgroundImage(UIImage(color: .appBackgroundGray), for: .highlighted)
        
        layer.borderWidth = 2.0
        layer.cornerRadius = 8
        clipsToBounds = true
        
        if isEnabled {
            layer.borderColor = UIColor.appYellow.cgColor
        } else {
            layer.borderColor = UIColor.appLightGray.cgColor
        }
    }
    
      private func applySecondaryClearStyle() {
            titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            setTitleColor(.appYellow, for: .normal)
    //        setTitleColor(.appOrange, for: .highlighted)
            setTitleColor(.appLightGray, for: .disabled)
            
        setBackgroundImage(UIImage(color: .clear), for: .normal)
            setBackgroundImage(UIImage(color: .clear), for: .highlighted)
            
            layer.borderWidth = 2.0
            layer.cornerRadius = 8
            clipsToBounds = true
            
            if isEnabled {
                layer.borderColor = UIColor.appYellow.cgColor
            } else {
                layer.borderColor = UIColor.appLightGray.cgColor
            }
        }
    
    private func applyFormStyle() {
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        setTitleColor(.backgroundWhite, for: .normal)
        setTitleColor(.backgroundWhite, for: .disabled)
        setBackgroundImage(UIImage(color: UIColor(rgb: 0x131313, alpha: 1)), for: .normal)
        setBackgroundImage(UIImage(color: .appBlack1), for: .highlighted)
        setBackgroundImage(UIImage(color: .appLightGray), for: .disabled)
        layer.borderWidth = 0
        layer.cornerRadius = 0
        clipsToBounds = true
    }
    
    @objc func touchUpInsideAction(button: UIButton) {
        viewModel?.handler?()
        alpha = 1.0
    }
    
    @objc func touchDownAction(button: UIButton) {
        alpha = 0.3
    }
    
    @objc func touchUpOutsideCanceled(button: UIButton) {
        alpha = 1.0
    }
    
}
