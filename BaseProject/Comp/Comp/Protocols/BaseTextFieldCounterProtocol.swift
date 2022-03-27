//
//  BaseTextFieldCounterProtocol.swift
//  Comp
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import UIKit

public class BaseTextFieldCounterRightView: UIView {
    
    var counterMaxValue: Int = 200
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 9.0)
        label.textColor = .appLightGray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(label)
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0.0).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0.0).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0.0).isActive = true
        layoutIfNeeded()
    }

    func updateCounter(value: Int) {
        var calculatedValue = counterMaxValue
        if value <= counterMaxValue {
            calculatedValue = counterMaxValue - value
        } else {
            calculatedValue = 0
        }
        label.text = "\(calculatedValue)/\(counterMaxValue)"
    }
    
}

public protocol BaseTextFieldCounterProtocol {
    var maxCharachterCount: Int { get }
    func initiateCounter()
    func updateCounter(_ count: Int)
}

public extension BaseTextFieldCounterProtocol where Self: BaseTextField {
    
    func initiateCounter() {
        guard let rightView = getRightView() else { return }
        rightView.counterMaxValue = maxCharachterCount
        rightView.updateCounter(value: 0)
    }
    
    func updateCounter(_ count: Int) {
        guard let rightView = getRightView() else { return }
        rightView.updateCounter(value: count)
    }

}

// MARK: RightView helper
public extension BaseTextFieldCounterProtocol where Self: BaseTextField {
    @discardableResult
    private func getRightView() -> BaseTextFieldCounterRightView? {
        guard let foundView = subviews.filter({
            $0.isKind(of: BaseTextFieldCounterRightView.self)
        }).first else { return createRightView() }
        return foundView as? BaseTextFieldCounterRightView
    }
    
    private func createRightView() -> BaseTextFieldCounterRightView {
        let view = BaseTextFieldCounterRightView(frame: CGRect(origin: .zero, size: CGSize(width: 40.0, height: 30.0)))
        view.counterMaxValue = maxCharachterCount
        rightViewMode = .always
        rightView = view
        return view
    }
}
