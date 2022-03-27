//
//  FormTextFieldCell.swift
//  Comp
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import UIKit

public class FormTextFieldCell: UITableViewCell {

    @IBOutlet private weak var stackView: UIStackView!
    private var textField: FormTextField!
    private var viewModel: FormTextFieldViewModelProtocol?
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        textField = FormTextField.loadFromNib()
        stackView.addArrangedSubview(textField)
    }
    
    public func populate(with viewModel: FormTextFieldViewModelProtocol, tag: Int?) {
        textField.populate(with: viewModel)
        selectionStyle = .none
        selectedBackgroundView = nil
        self.viewModel = viewModel
        if let tag = tag {
            textField.setTag(tag: tag)
        }
    }
    
    public override func setSelected(_ selected: Bool, animated: Bool) {
        if selected {
            textField.handleTap(nil)
            guard let tableView = findSuperview(of: UITableView.self) else { return }
            guard let selectedIndexPath = tableView.indexPathForSelectedRow else { return }
            tableView.deselectRow(at: selectedIndexPath, animated: false)
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        if viewModel?.seperatorVisible == false {
            hideSeperator()
        }
    }
    
}
