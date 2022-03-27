//
//  ErrorMessageDisplayProtocol.swift
//  Comp
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import UIKit
import Common

class ErrorMessageDisplayLabel: UILabel {
    // Intentionally unimplemented...
}
class ErrorMessageDisplayMaskView: UIView {
    // Intentionally unimplemented...
}

public protocol ErrorMessageDisplayProtocol {
    var errorLabelPaddings: UIEdgeInsets { get }
    func setErrorMessage(errorDescription: String)
    func animateMe()
    func dismissMe()
}

// MARK: Public methods
public extension ErrorMessageDisplayProtocol where Self: UIView {
    
    func setErrorMessage(errorDescription: String) {
        errorLabelManager(errorDescription: errorDescription)
    }
    
    func animateMe() {
        guard let label = getLabel() else { return }
        animationManager(label: label, shouldRemove: false)
    }
    
    func dismissMe() {
        errorLabelManager()
        guard let label = getLabel() else { return }
        animationManager(label: label, shouldRemove: true)
    }
    
}

// MARK: Managers
public extension ErrorMessageDisplayProtocol where Self: UIView {
    
    private func errorLabelManager(errorDescription: String? = nil) {
        guard let label = getLabel() else { return }
        animationManager(label: label, shouldRemove: true)
        if let receivedErrorDescription = errorDescription {
            label.text = receivedErrorDescription
            label.alpha = 0.0
        }
        layoutIfNeeded()
        label.sizeToFit()
    }
    
    private func animationManager(label: UILabel, shouldRemove: Bool) {
        var labelHeight: CGFloat = -errorLabelPaddings.bottom
        if !shouldRemove {
            labelHeight = label.frame.size.height + errorLabelPaddings.top
        }
        getConstraintsBetweenLabelAndMaskView().forEach { (constraint) in
            constraint.constant = labelHeight
        }
        getBottomConstraintsFromParentView().forEach { (constraint) in
            constraint.constant = (labelHeight + errorLabelPaddings.bottom)
        }
        getBottomConstraintsToParentView().forEach { (constraint) in
            constraint.constant = -(labelHeight + errorLabelPaddings.bottom)
        }
        guard let strongSuperview = self.superview else { return }
        label.alpha = shouldRemove ? 0.0 : 1.0
        layoutIfNeeded()
        layoutSubviews()
        strongSuperview.layoutIfNeeded()
        strongSuperview.layoutSubviews()
        label.sizeToFit()
    }
    
}

// MARK: Constraint extraction helper
extension ErrorMessageDisplayProtocol where Self: UIView {
    
    func getBottomConstraintsFromParentView() -> [NSLayoutConstraint] {
        let filtered = constraints.filter { (constraint) -> Bool in
            guard let firstItem = constraint.firstItem, let secondItem = constraint.secondItem else { return false }
            return (!secondItem.isKind(of: ErrorMessageDisplayLabel.self) &&
                !firstItem.isKind(of: ErrorMessageDisplayLabel.self) &&
                firstItem === self &&
                constraint.firstAnchor == self.bottomAnchor)
        }
        return filtered
    }
    
    func getBottomConstraintsToParentView() -> [NSLayoutConstraint] {
        let filtered = constraints.filter { (constraint) -> Bool in
            guard let firstItem = constraint.firstItem, let secondItem = constraint.secondItem else { return false }
            return (!firstItem.isKind(of: ErrorMessageDisplayLabel.self) &&
                !secondItem.isKind(of: ErrorMessageDisplayLabel.self) &&
                secondItem === self &&
                constraint.secondAnchor == self.bottomAnchor)
        }
        return filtered
    }
    
    func getConstraintsBetweenLabelAndMaskView() -> [NSLayoutConstraint] {
        return self.constraints.filter { constraint in
            guard let strongFirstItem = constraint.firstItem, let strongSecondItem = constraint.secondItem else { return false }
            return (strongFirstItem.isKind(of: ErrorMessageDisplayMaskView.self) &&
                strongSecondItem.isKind(of: ErrorMessageDisplayLabel.self)) ||
                (strongFirstItem.isKind(of: ErrorMessageDisplayLabel.self) &&
                    strongSecondItem.isKind(of: ErrorMessageDisplayMaskView.self))
        }
    }
    
}

// MARK: Label helper
extension ErrorMessageDisplayProtocol where Self: UIView {
    
    private func getLabel() -> ErrorMessageDisplayLabel? {
        guard let foundLabel = subviews.filter({
            $0.tag == 5463 && $0.isKind(of: ErrorMessageDisplayLabel.self)
        }).first else { return createLabel() }
        return foundLabel as? ErrorMessageDisplayLabel
    }
    
    private func createLabel() -> ErrorMessageDisplayLabel {
        let label = ErrorMessageDisplayLabel()
        label.tag = 5463
        label.alpha = 0.0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .appRed
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.numberOfLines = 0
        guard let maskView = getMaskView() else { return label }
        insertSubview(label, belowSubview: maskView)
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: errorLabelPaddings.left).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -errorLabelPaddings.right).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -errorLabelPaddings.bottom).isActive = true
        label.bottomAnchor.constraint(equalTo: maskView.bottomAnchor, constant: -errorLabelPaddings.bottom).isActive = true
        return label
    }
    
    private func removeLabel() {
        guard let label = getLabel() else { return }
        label.removeFromSuperview()
    }
}

// MARK: MaskView helper
extension ErrorMessageDisplayProtocol where Self: UIView {
    
    private func getMaskView() -> ErrorMessageDisplayMaskView? {
        guard let foundMaskView = subviews.filter({
            $0.tag == 5462 && $0.isKind(of: ErrorMessageDisplayMaskView.self)
        }).first else { return createMaskView() }
        return foundMaskView as? ErrorMessageDisplayMaskView
    }
    
    private func createMaskView() -> ErrorMessageDisplayMaskView {
        clipsToBounds = true
        let view = ErrorMessageDisplayMaskView()
        view.backgroundColor = .white
        view.tag = 5462
        view.translatesAutoresizingMaskIntoConstraints = false
        if let firstObject = subviews.first {
            insertSubview(view, belowSubview: firstObject)
        } else {
            addSubview(view)
        }
        view.topAnchor.constraint(equalTo: topAnchor, constant: 0.0).isActive = true
        let heightAnchor = view.heightAnchor.constraint(equalToConstant: frame.size.height)
        heightAnchor.priority = UILayoutPriority(999)
        heightAnchor.isActive = true
        view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0.0).isActive = true
        view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0.0).isActive = true
        layoutIfNeeded()
        return view
    }
    
}
