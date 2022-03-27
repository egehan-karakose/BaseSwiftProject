//
//  FormController.swift
//  Comp
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

extension FormController {

    public func setTopStackViewInsets(insets: UIEdgeInsets?) {
        let insets: UIEdgeInsets = insets ?? .zero
        topStackView.isLayoutMarginsRelativeArrangement = true
        if #available(iOS 11.0, *) {
            topStackView.directionalLayoutMargins = .init(top: insets.top,
                                                          leading: insets.left,
                                                          bottom: insets.bottom,
                                                          trailing: insets.right)
        } else {
            topStackView.layoutMargins = .init(top: insets.top,
                                               left: insets.left,
                                               bottom: insets.bottom,
                                               right: insets.right)
        }
    }
    
    public func clearTopStackView() {
        for view in topStackView.arrangedSubviews {
            view.removeFromSuperview()
        }
        for view in topStackView.subviews {
            view.removeFromSuperview()
        }
    }
    
}

extension FormController {
    
    public class TopStackViewModel {
        
        public static var defaultInsets = UIEdgeInsets(top: 10, left: 16, bottom: 24, right: 16)
        
        public var insets: UIEdgeInsets?
        public var views: [UIView] = []
        public var backgroundColor: UIColor?
        public var spacing: CGFloat = 4
        public var height: CGFloat = 0

        public init() { }
        
    }
    
    func populateTopStackView() {
        clearTopStackView()
        guard let topStackViewModel = topStackViewModel else { return }
        topStackViewHeightConstraint?.constant = topStackViewModel.height
        for view in topStackViewModel.views {
            topStackView.addArrangedSubview(view)
        }
        
        setTopStackViewInsets(insets: topStackViewModel.insets)
        if let backgroundColor = topStackViewModel.backgroundColor {
            topStackView.layer.backgroundColor = backgroundColor.cgColor
        }
        topStackView.spacing = topStackViewModel.spacing
        topStackView.superview?.layoutIfNeeded()
    }

}
