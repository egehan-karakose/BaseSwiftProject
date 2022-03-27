//
//  InfoView.swift
//  Comp
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import UIKit
import Common

public protocol HandleTapOnLabelProtocol {
    func handleUrlTapOnLabel(_ recognizer: UITapGestureRecognizer)
}

public protocol InfoViewModelDataSource {
    var attributedText: NSAttributedString? { get }
    var hasInfoIcon: Bool { get }
    var lineSpacing: CGFloat? { get set }
    var seperatorVisible: Bool { get }
    }

public protocol InfoViewModelProtocol: InfoViewModelDataSource { }

public class InfoView: UIView {
    
    @IBOutlet private weak var infoButton: UIButton!
    @IBOutlet private weak var textLabel: UILabel!
    
    public var url: String?
    public var html: String?
    
    @available(*, unavailable)
    init() { fatalError() }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func populate(with viewModel: InfoViewModelProtocol) {
        backgroundColor = .clear
        
        textLabel.isUserInteractionEnabled = true
        textLabel.attributedText = viewModel.attributedText
        
        if let htmlAttributedText = html?.htmlAsMutableAttributed {
            htmlAttributedText.addAttribute(.font, value: UIFont.regular(of: 12),
                                            range: NSRange(location: 0, length: htmlAttributedText.string.count))
            htmlAttributedText.addAttribute(.foregroundColor, value: UIColor.appBlack1,
                                            range: NSRange(location: 0, length: htmlAttributedText.string.count))
            textLabel.attributedText = htmlAttributedText
            textLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleUrlTapOnLabel(_:))))
        }
        
        infoButton.isHidden = !viewModel.hasInfoIcon
        infoButton.setImage(UIImage(named: "info_orange", in: .uiComp, compatibleWith: nil), for: .normal)
    }
}

extension InfoView: HandleTapOnLabelProtocol {
    @objc public func handleUrlTapOnLabel(_ recognizer: UITapGestureRecognizer) {
         guard let url = URL(string: url ?? "") else { return }
         guard let text = textLabel?.attributedText?.string else { return }
                
         if let range = text.range(of: NSLocalizedString(text, comment: "")),
             recognizer.didTapAttributedTextInLabel(label: textLabel, inRange: NSRange(range, in: text)) {
             navigateToLink(url: url)
         }
    }
    
    private func navigateToLink(url: URL) {
        UIApplication.shared.open(url)
    }
}

extension InfoView: NibLoadable { }
