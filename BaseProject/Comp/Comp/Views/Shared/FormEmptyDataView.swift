//
//  FormEmptyDataView.swift
//  Comp
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import UIKit
import Common

public protocol FormEmptyDataViewModelDataSource {
    var title: String? { get }
    var views: [UIView]? { get }
    var image: UIImage? { get }
}

public protocol FormEmptyDataViewModelProtocol: FormEmptyDataViewModelDataSource { }

public class FormEmptyDataView: UIView {

    @IBOutlet private weak var bottomStackView: UIStackView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var emptyImageView: UIImageView!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        setupStyle()
    }

    public func populate(with viewModel: FormEmptyDataViewModelProtocol) {
        
        titleLabel.attributedText = AttributedStringBuilder()
            .setFont(.regular(of: 14))
            .setLineSpacing(4)
            .setTextAlignment(.center)
            .setForegroundColor(.appBlack1)
            .build(with: viewModel.title)
        
        emptyImageView.image = viewModel.image ?? UIImage(named: "noItem", in: .uiComp, compatibleWith: nil)
        
        for view in bottomStackView.arrangedSubviews {
            bottomStackView.removeArrangedSubview(view)
        }
        
        if let views = viewModel.views {
            for view in views {
                bottomStackView.addArrangedSubview(view)
            }
        }
        
    }
    
    private func setupStyle() {
        titleLabel.font = .regular(of: 14)
        titleLabel.textColor = .black
    }
    
}

extension FormEmptyDataView: NibLoadable { }
