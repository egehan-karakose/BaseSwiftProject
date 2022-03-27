//
//  SearchEmptyContentView.swift
//  Comp
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import UIKit

public protocol SearchEmptyContentViewModelDataSource {
    var title: String? { get }
    var shouldSetGenericTitle: Bool? { get set }
}

public protocol SearchEmptyContentViewModelDataProtocol: SearchEmptyContentViewModelDataSource { }

public class SearchEmptyContentView: UIView {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var labelTopConstraint: NSLayoutConstraint!
    public var navigationBarHeight: CGFloat = 0.0 {
        didSet {
            let statusBarHeight = navigationBarHeight + UIApplication.shared.statusBarFrame.size.height + 60.0
            labelTopConstraint.constant = statusBarHeight + 35
            layoutIfNeeded()
        }
    }
    override public func awakeFromNib() {
        super.awakeFromNib()
        setupStyle()
    }
    
    public func populate(with viewModel: SearchEmptyContentViewModelDataProtocol) {
        titleLabel.text = viewModel.title
    }
    
    private func setupStyle() {
        titleLabel.font = .regular(of: 14)
        titleLabel.textColor = .appGray
        backgroundColor = .clear
    }
    
}

extension SearchEmptyContentView: NibLoadable { }
