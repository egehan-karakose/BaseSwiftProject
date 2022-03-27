//
//  TextButton.swift
//  Comp
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import UIKit
import Common

public protocol TextButtonViewModelEventSource {
    var handler: VoidHandler? { get }
}

public protocol TextButtonViewModelDataSource {
    var title: String? { get set }
    var isSelectAll: Bool { get set }
    var attributedString: NSMutableAttributedString? { get set }
}

public protocol TextButtonViewModelProtocol: TextButtonViewModelDataSource, TextButtonViewModelEventSource {  }

public class TextButtonViewModel: TextButtonViewModelProtocol {
    
    public var handler: VoidHandler?
    public var title: String?
    public var isSelectAll: Bool = true
    public var attributedString: NSMutableAttributedString?
    
    public init() { }
    
}

public class TextButton: UIButton {

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var viewModel: TextButtonViewModelProtocol?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup() {
        addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        setTitleColor(.appOrange, for: .normal)
        titleLabel?.font = .medium(of: 14)
        titleLabel?.setContentCompressionResistancePriority(.required, for: .vertical)
        titleLabel?.setContentCompressionResistancePriority(.required, for: .horizontal)
        setContentCompressionResistancePriority(.required, for: .vertical)
        setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    public func populate(with viewModel: TextButtonViewModelProtocol) {
        self.viewModel = viewModel
        setTitle(viewModel.title, for: .normal)
        
        if let attributedString = viewModel.attributedString {
            setAttributedTitle(attributedString, for: .normal)
        }
    }
    
    @objc func buttonTapped(_ sender: Any?) {
        viewModel?.handler?()
    }
    
}
