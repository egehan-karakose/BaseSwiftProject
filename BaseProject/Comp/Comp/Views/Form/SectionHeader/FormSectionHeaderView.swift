//
//  FormSectionHeader.swift
//  Comp
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import UIKit

public protocol FormSectionHeaderViewModelDataSource {
    var leftView: UIView? { get }
    var accessoryView: UIView? { get }
}

public protocol FormSectionHeaderViewModelProtocol: FormSectionHeaderViewModelDataSource { }

public class FormSectionHeaderViewModel: FormSectionHeaderViewModelProtocol {
    
    public var leftView: UIView?
    public var accessoryView: UIView?
    
    public init() { }
    
}

public class FormSectionHeaderView: UIView {

    @IBOutlet private weak var leftStackView: UIStackView!
    @IBOutlet private weak var rightStackView: UIStackView!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
    }
    
    public func populate(with viewModel: FormSectionHeaderViewModelProtocol) {
        
        leftStackView.clearArrangedSubviews()
        rightStackView.clearArrangedSubviews()
        
        if let leftView = viewModel.leftView {
            if let superStackView = leftView.superview as? UIStackView {
                superStackView.removeArrangedSubview(leftView)
            }
            leftView.removeFromSuperview()
            leftStackView.addArrangedSubview(leftView)
        }
        
        if let rightView = viewModel.accessoryView {
            if let superStackView = rightView.superview as? UIStackView {
                superStackView.removeArrangedSubview(rightView)
            }
            rightView.removeFromSuperview()
            rightStackView.addArrangedSubview(rightView)
        }
        
    }
    
}

extension FormSectionHeaderView: NibLoadable { }
