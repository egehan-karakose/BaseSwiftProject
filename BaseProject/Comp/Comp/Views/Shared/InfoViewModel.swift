//
//  InfoViewModel.swift
//  Comp
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import Foundation
import Common

public class InfoViewModel: InfoViewModelProtocol {
    public var text: String? {
        didSet {
            let attributedText = AttributedStringBuilder()
                .setForegroundColor(.appDarkGray)
                .setFont(.regular(of: 12))
                .setTextAlignment(.left)
                .setLineSpacing(lineSpacing)
                .build(with: text)
            self.attributedText = attributedText
        }
    }
    
    public var attributedText: NSAttributedString?
    public var lineSpacing: CGFloat? = 4
    
    public var hasInfoIcon: Bool = true
    public var seperatorVisible: Bool = true

    public init() { }
    
}
