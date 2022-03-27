//
//  FormBasicPickerCellTableViewCell.swift
//  Comp
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import UIKit

public protocol FormBasicPickerCellViewModelDataSource {
    var isEnabled: Bool { get set }
    var title: String { get set }
    var valueText: String? { get set }
    var errorText: String? { get }
    var shouldUpdateTableViw: Bool { get set }
    var titleColor: UIColor? { get }
    var valueColor: UIColor? { get }
    var seperatorVisible: Bool? { get }
    var lineVisible: Bool? { get }
    var isTitleHidden: Bool? { get set }
    var accessoryImage: UIImage? { get set }
    var enumValue: Any? { get set }
}

public protocol FormBasicPickerCellViewModelProtocol: CellViewModelProtocol, FormBasicPickerCellViewModelDataSource {
    
}

public class FormBasicPickerCell: UITableViewCell {

    @IBOutlet private weak var mainStackView: UIStackView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var valueLabel: UILabel!
    @IBOutlet private weak var lineView: UIView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet weak var accesoryView: UIImageView!
    
    @IBOutlet private weak var mainStackViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var mainStackViewBottomConstraint: NSLayoutConstraint!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        valueLabel.font = .regular(of: 14)
        valueLabel.textColor = .appBlack2
    }
    
    private var viewModel: FormBasicPickerCellViewModelProtocol?
    
    public func populate(with viewModel: FormBasicPickerCellViewModelProtocol?) {
        self.viewModel = viewModel
        if viewModel?.shouldUpdateTableViw ?? false {
            beginUpdatesIfAvailable()
        }
        
        super.populate(with: viewModel)
        
        isUserInteractionEnabled = viewModel?.isEnabled ?? false ? true : false
        
        if viewModel?.isEnabled == false {
            selectionStyle = .none
        }
        
        if let image = viewModel?.accessoryImage {
            accesoryView.image = image
        }
        
        titleLabel.text = viewModel?.title
        titleLabel.isHidden = viewModel?.isTitleHidden ?? false
        
        if let valueText = viewModel?.valueText {
            titleLabel.font = UIFont.regular(of: 12)
            titleLabel.textColor = .appGray
            valueLabel.isHiddenInStackView = false
            mainStackViewTopConstraint.constant = 18
            valueLabel.text = valueText
            if #available(iOS 11.0, *) {
                mainStackView.setCustomSpacing(5, after: titleLabel)
                mainStackView.setCustomSpacing(8, after: valueLabel)
            }
        } else {
            titleLabel.font = UIFont.regular(of: 14)
            titleLabel.textColor = .appGray
            valueLabel.isHiddenInStackView = true
            mainStackViewTopConstraint.constant = 36
            valueLabel.text = nil
            if #available(iOS 11.0, *) {
                mainStackView.setCustomSpacing(8, after: titleLabel)
            }
        }
        
        if viewModel?.isEnabled == true {
            valueLabel.textColor = UIColor.appBlack2
            accesoryView.alpha = 1
            accesoryView.isHidden = false
        } else {
            valueLabel.textColor = UIColor.appGray
            accesoryView.alpha = 0.5
            accesoryView.isHidden = true
        }
        if accessoryView != nil {
            accesoryView.isHidden = true
        }
        
        if viewModel?.errorText != nil {
            lineView.backgroundColor = .appRed
            descriptionLabel.textColor = .appRed
            descriptionLabel.text = viewModel?.errorText
            descriptionLabel.isHiddenInStackView = false
            mainStackViewBottomConstraint.constant = 3

        } else {
            //dispatch koymamın tek nedeni bu olmadan tablette renk kırmızı kalması. Muhtemelen apple bugı bu durum.
            lineView.backgroundColor = .appLightGray
            descriptionLabel.isHiddenInStackView = true
            mainStackViewBottomConstraint.constant = 0
        }
        
        if viewModel?.shouldUpdateTableViw ?? false {
            endUpdatesIfAvailable()
        }
        
        self.viewModel?.shouldUpdateTableViw = false
        
        if let titleColor = viewModel?.titleColor {
            titleLabel.textColor = titleColor
        }
        if let valueColor = viewModel?.valueColor {
            valueLabel.textColor = valueColor
        }
        
        if viewModel?.lineVisible == false {
            lineView.isHidden = true
        } else {
            lineView.isHidden = false
        }
    }
    
    public override func setSelected(_ selected: Bool, animated: Bool) {
        if !selected {
            super.setSelected(selected, animated: false)
        } else {
            super.setSelected(selected, animated: animated)
        }
        
        if !selected && animated {
            if self.viewModel?.errorText != nil {
                self.lineView.backgroundColor = .appRed
            } else {
                self.lineView.backgroundColor = .appLightGray
            }
        }
    }
    
    private func beginUpdatesIfAvailable() {
        guard let controller = findViewController() as? CustomTableViewController else { return }
        guard let tableView = controller.tableView else { return }
        tableView.beginUpdates()
    }
    
    private func endUpdatesIfAvailable() {
        guard let controller = findViewController() as? CustomTableViewController else { return }
        guard let tableView = controller.tableView else { return }
        layoutIfNeeded()
        tableView.endUpdates()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        if viewModel?.seperatorVisible == false {
            hideSeperator()
        }
    }
    
}
