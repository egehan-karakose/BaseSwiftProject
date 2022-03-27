//
//  BadgeBarButtonItem.swift
//  Comp
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import UIKit
import Common

public protocol BadgeBarButtonItemViewModelEventSource {
    var tapHandler: VoidHandler? { get }
}

public protocol BadgeBarButtonItemViewModelDataSource {
    var badge: Int { get }
    var buttonHeight: CGFloat { get }
    var buttonWidth: CGFloat { get }
    var buttonImage: UIImage? { get }
    var hasShadow: Bool { get }
}

public protocol BadgeBarButtonItemViewModelProtocol: BadgeBarButtonItemViewModelDataSource, BadgeBarButtonItemViewModelEventSource {
    var accessibilityLabel: String? { get }
}

public class BadgeBarButtonItemViewModel: BadgeBarButtonItemViewModelProtocol {
    
    public var badge: Int = 0
    public var buttonHeight: CGFloat = 32
    public var buttonWidth: CGFloat = 32
    public var buttonImage: UIImage?
    public var tapHandler: VoidHandler?
    public var accessibilityLabel: String?
    public var hasShadow: Bool = false
    
    public init() { }
    
}

public class BadgeBarButtonItem: UIBarButtonItem {
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override init() {
        super.init()
    }
    
    var viewModel: BadgeBarButtonItemViewModelProtocol?
    
    // swiftlint:disable function_body_length
    public func populate(with viewModel: BadgeBarButtonItemViewModelProtocol) {
        self.viewModel = viewModel
        
        let size: CGFloat = (viewModel.buttonHeight * 0.6)
        let fontColor: UIColor = .white
        let backgroundColor: UIColor = .appRed
        let button = UIButton(type: .custom)
        button.setImage(viewModel.buttonImage, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(didTap(_:)), for: .touchUpInside)
        
        if viewModel.hasShadow {
            button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            button.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
            button.layer.shadowOpacity = 0.75
            button.layer.shadowRadius = 3.0
            button.layer.masksToBounds = false
        }
        
        customView = button

        if let parrentView = self.customView {
            parrentView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                parrentView.widthAnchor.constraint(equalToConstant: viewModel.buttonWidth),
                parrentView.heightAnchor.constraint(equalToConstant: viewModel.buttonHeight)
                ])
            parrentView.accessibilityLabel = viewModel.accessibilityLabel
            if viewModel.badge > 0 {
                
                var badgeSize: CGSize = CGSize(width: size, height: size)
                let textFont = UIFont.systemFont(ofSize: floor(size * 0.6))
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .center
                let textFontAttributes: [NSAttributedString.Key: Any] = [
                    NSAttributedString.Key.font: textFont,
                    NSAttributedString.Key.foregroundColor: fontColor,
                    NSAttributedString.Key.paragraphStyle: paragraphStyle
                ]
                
                var badgeText: String = "\(viewModel.badge)"
                if viewModel.badge >= 99 {
                    badgeText = "99+"
                }
                parrentView.accessibilityLabel = "\(viewModel.accessibilityLabel.withDefault("")) \(badgeText) \("bildirim".localized)" 
                let calculatedTextSize = (badgeText as NSString).size(withAttributes: textFontAttributes)
                if calculatedTextSize.width > size {
                    badgeSize = CGSize(width: calculatedTextSize.width, height: size)
                }
                let attributedText = NSAttributedString(string: badgeText, attributes: textFontAttributes)
                let holderView: UIView = UIView()
                holderView.isUserInteractionEnabled = false
                holderView.backgroundColor = backgroundColor
                holderView.layer.cornerRadius = badgeSize.width * 0.5
                holderView.translatesAutoresizingMaskIntoConstraints = false
                parrentView.addSubview(holderView)
                NSLayoutConstraint.activate([
                    holderView.widthAnchor.constraint(equalToConstant: badgeSize.width),
                    holderView.heightAnchor.constraint(equalToConstant: badgeSize.height),
                    holderView.trailingAnchor.constraint(equalTo: parrentView.trailingAnchor, constant: (badgeSize.width * 0.4)),
                    holderView.topAnchor.constraint(equalTo: parrentView.topAnchor, constant: -(badgeSize.height * 0.2))
                    ])
                let badge = UILabel()
                badge.attributedText = attributedText
                badge.translatesAutoresizingMaskIntoConstraints = false
                holderView.addSubview(badge)
                NSLayoutConstraint.activate([
                    badge.widthAnchor.constraint(equalToConstant: badgeSize.width),
                    badge.heightAnchor.constraint(equalToConstant: badgeSize.height),
                    badge.centerXAnchor.constraint(equalTo: holderView.centerXAnchor),
                    badge.centerYAnchor.constraint(equalTo: holderView.centerYAnchor)
                    ])
                parrentView.layoutIfNeeded()
                
            }
        }
            
    }
    // swiftlint:enable function_body_length
    
    @objc private func didTap(_ sender: UIButton) {
        viewModel?.tapHandler?()
    }
    
}
