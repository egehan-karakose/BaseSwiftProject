//
//  BaseTextField.swift
//  Comp
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import Foundation

public protocol Verifiable {
    func verify() -> Bool
}

public class BaseTextField: SkyFloatingLabelTextField {

    public var maxLenght: Int = 10
    
    var padding: CGFloat = 0.0
    
    // MARK: - Initialization
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        style()
        setFeatures()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        style()
        setFeatures()
    }
    
    // MARK: - Private UI Helpers
    
    private func style() {
        backgroundColor = .white
        tintColor = .appOrange
        textColor = .defaultTextColor
        lineColor = .appLightGray
        selectedTitleColor = .appOrange
        selectedLineColor = .appOrange
        errorColor = .appRed
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: 20))
        leftView = paddingView
        leftViewMode = .always
        font = UIFont.systemFont(ofSize: 14)
        titleFont = UIFont.systemFont(ofSize: 12)
    }
    
    private func setFeatures() {
        autocorrectionType = .no
    }
    
    public override var canBecomeFirstResponder: Bool {
        return true
    }
    
    // MARK: - Public Overrides to customize BaseTextField
    
    override public func titleLabelRectForBounds(_ bounds: CGRect, editing: Bool) -> CGRect {
        let top: CGFloat = padding / 2
        if editing {
            return CGRect(x: padding, y: top, width: bounds.size.width - padding, height: titleHeight())
        }
        return CGRect(x: padding, y: titleHeight(), width: bounds.size.width - padding, height: titleHeight())
    }
    
    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        let superRect = super.textRect(forBounds: bounds)
        
        let padding = UIEdgeInsets(top: 4, left: self.padding, bottom: 0, right: 0)
        superRect.inset(by: padding)
        
        return superRect
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.placeholderRect(forBounds: bounds)
        rect.origin.x = padding
        return rect
    }
    
    public override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.rightViewRect(forBounds: bounds)
        rect.origin.x -= 8
        return rect
    }
    
}
