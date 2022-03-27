//
//  ImageButton.swift
//  Comp
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import UIKit
import Common

public protocol ImageButtonViewModelEventSource {
    var handler: VoidHandler? { get }
}

public protocol ImageButtonViewModelDataSource {
    var image: UIImage? { get }
    var title: String? { get }
    var scaleType: UIView.ContentMode? { get }
    var color: UIColor? { get }
    var rightToLeft: Bool? { get }
}

public protocol ImageButtonViewModelProtocol: ImageButtonViewModelDataSource, ImageButtonViewModelEventSource {  }

public class ImageButtonViewModel: ImageButtonViewModelProtocol {
    
    public var handler: VoidHandler?
    public var image: UIImage?
    public var title: String?
    public var scaleType: UIView.ContentMode?
    public var color: UIColor?
    public var rightToLeft: Bool?
    
    public init() { }
}

public class ImageButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var viewModel: ImageButtonViewModelProtocol?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup() {
        addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -8, bottom: 0, right: 0)
        showsTouchWhenHighlighted = false
        adjustsImageWhenHighlighted = false
        titleLabel?.font = .medium(of: 14)
    }
    
    public func populate(with viewModel: ImageButtonViewModelProtocol) {
        self.viewModel = viewModel
        setTitleColor(viewModel.color ?? .appOrange, for: .normal)
        setImage(viewModel.image, for: .normal)
        setTitle(viewModel.title, for: .normal)
        if viewModel.rightToLeft~ {
            imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 7, bottom: 0, right: 0)
            self.semanticContentAttribute = .forceRightToLeft
        }
        if let contentMode = viewModel.scaleType {
            self.imageView?.contentMode = contentMode
        }
    }
    
    @objc func buttonTapped(_ sender: Any?) {
        viewModel?.handler?()
    }
    
}
