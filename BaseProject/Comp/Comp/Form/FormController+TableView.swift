//
//  FormController+TableView.swift
//  Comp
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import Foundation
import Common

extension FormController: UITableViewDataSource, UITableViewDelegate {
    
    open func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let rowCount = self.tableView(tableView, numberOfRowsInSection: section)
        if rowCount == 0 && showEmptySectionTitles == false { return nil }
        let section = data?.filter({ $0.isEnabled })[section]
        
        return section?.title
    }
    
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let rowCount = self.tableView(tableView, numberOfRowsInSection: section)
        let formSection = data?.filter({ $0.isEnabled })[section]
        if rowCount == 0 && showEmptySectionTitles == false { return nil }
        if formSection?.title == nil
            && formSection?.accessoryView == nil
            && formSection?.leftView == nil
            && formSection?.headerView == nil {
                return nil
        }
        
        if let sectionHeaderView = formSection?.headerView, !(formSection?.isTitleChanged)~ {
            return sectionHeaderView
        }
        
        if let leftView = formSection?.leftView {
            let sectionHeaderView = FormSectionHeaderView.loadFromNib()
            sectionHeaderView.backgroundColor = formSection?.backGroundColor
            let viewModel = FormSectionHeaderViewModel()
            viewModel.leftView = leftView
            viewModel.accessoryView = formSection?.accessoryView
            sectionHeaderView.populate(with: viewModel)
            if !reuseHeaders { formSection?.headerView = sectionHeaderView }
            return sectionHeaderView
        } else {
            let sectionHeaderView = FormSectionHeaderView.loadFromNib()
            sectionHeaderView.backgroundColor = formSection?.backGroundColor
            let viewModel = FormSectionHeaderViewModel()
            let titleLabel = UILabel()
            titleLabel.font = .light(of: 16)
            titleLabel.textColor = .appGray
            titleLabel.text = formSection?.title
            titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
            titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
            titleLabel.numberOfLines = 0
            viewModel.leftView = titleLabel
            viewModel.accessoryView = formSection?.accessoryView
            sectionHeaderView.populate(with: viewModel)
            if !reuseHeaders { formSection?.headerView = sectionHeaderView }
            return sectionHeaderView
        }
    }
    
    public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            let backgroundView = UIView()
			backgroundView.backgroundColor = shouldShowEmptyDataView() ?? false ? .clear : .appBackgroundGray 
            headerView.backgroundView = backgroundView
        }
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let formSection = getFormSection(for: section) else { return nil }
        if let footerView = formSection.footerView {
            footerView.setNeedsLayout()
            footerView.layoutIfNeeded()
            return footerView
        } else {
            let formSection = getFormSection(for: section)
            let lastRow = formSection?.rows?.filter({ $0.isEnabled }).last
            if lastRow as? FormTextFieldRow != nil {
                let view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 20))
                view.backgroundColor = .white
                return view
            }
        }
        return nil
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionCount = data?.filter({ $0.isEnabled }).count ?? 0
        guard sectionCount >= section + 1 else { return 0 }
        let formSection = data?.filter({ $0.isEnabled })[section]
        return formSection?.rows?.filter({ $0.isEnabled }).count ?? 0
    }
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        return data?.filter({ $0.isEnabled }).count ?? 0
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = getRow(at: indexPath)
        if row?.isEnabled == true &&
            (row as? FormTextFieldRow != nil) {
            
            if let indexField = textFieldIndexArray.filter({ $0.index == indexPath }).first {
                row?.tag = indexField.value
            } else {
                var nextIndex = 33000
                if let lastIndex = textFieldIndexArray.last {
                    nextIndex = (lastIndex.value ?? 33000) + 1
                }
                var indexField = TextFieldTagIndex(index: indexPath, value: nextIndex)
                textFieldIndexArray.append(indexField)
                row?.tag = indexField.value
            }
        }
        
        let cell = row?.getCell(tableView, reuse: reuseCells) ?? UITableViewCell()
        return cell
    }
    
    open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.size.height
    }
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = getRow(at: indexPath)
        guard row?.isSelectable == true else { return }
        row?.rowSelected?()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let view = self.tableView(tableView, viewForHeaderInSection: section) {
            return view.frame.height
        } else {
            let formSection = getFormSection(for: section)
            if let emptyHeaderHeight = formSection?.emptyHeaderHeight {
                return emptyHeaderHeight
            }
            let hasTableHeaderView = tableView.tableHeaderView != nil
            let isTableHeaderViewInitialView = tableView.tableHeaderView?.tag == initialTableHeaderViewTag
            if hasTableHeaderView && !isTableHeaderViewInitialView {
                return 0.01
            } else {
                return 25
            }
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if let view = self.tableView(tableView, viewForFooterInSection: section) {
            let smallestSize = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            return smallestSize.height
        } else {
            return 0.01
        }
    }
    
    //ios 10 & jumping bug fix
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath] ?? 500
    }
    
    private func getFormSection(for section: Int) -> FormSection? {
        guard let filteredSections = data?.filter({ $0.isEnabled }) else { return nil }
        guard filteredSections.count >= section + 1 else { return nil }
        return filteredSections[section]
    }
    
    private func getRow(at indexPath: IndexPath) -> FormRowDataSource? {
        let section = data?.filter({ $0.isEnabled })[indexPath.section]
        guard let filteredSectionRows = section?.rows?.filter({ $0.isEnabled }) else { return nil }
        guard filteredSectionRows.count >= indexPath.row + 1 else { return nil }
        return filteredSectionRows[indexPath.row]
    }
    
    // MARK: Delete Row
    open func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        let row = getRow(at: indexPath)
        return row?.rowDeleted == nil ? .none : .delete
    }
    
    open func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let row = getRow(at: indexPath)
        row?.rowDeleted?()
    }
    
    @available(iOS 11.0, *)
    open func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt
        indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let row = getRow(at: indexPath)
        if let rowDeleted = row?.rowDeleted {
            let deleteAction = UIContextualAction(style: .normal, title: nil) { _, _, success in
                rowDeleted()
                success(true)
            }
            deleteAction.image = UIImage(named: "trash")
            deleteAction.backgroundColor = .appRed
            return UISwipeActionsConfiguration(actions: [deleteAction])
        } else if let rowEditingAction = row?.rowEditingAction {
            let action = UIContextualAction(style: .normal, title: nil) { _, _, success in
                rowEditingAction.handler()
                success(true)
            }
            
            /*
             *WARNING: If title and image will be shown together, cell height must be min 91 pt.
             *This is Apple rule/bug
             */
            if let title = rowEditingAction.title {
                action.title = title
            }
            
            if let iconName = rowEditingAction.iconName {
                if #available(iOS 13.0, *) {
                    action.image = UIImage(named: iconName)?.withTintColor(.white, renderingMode: .alwaysTemplate)
                } else {
                    action.image = UIImage(named: iconName)
                }
            }
            
            action.backgroundColor = rowEditingAction.backgroundColor
            return UISwipeActionsConfiguration(actions: [action])
        } else {
            return nil
        }
    }
    
}

extension FormController {

    public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if let tmp = data?[sourceIndexPath.section].rows[safe: sourceIndexPath.row] {
            data?[sourceIndexPath.section].rows?.remove(at: sourceIndexPath.row)
            data?[sourceIndexPath.section].rows?.insert(tmp, at: destinationIndexPath.row)
            tableViewOrderChanged(moveRowAt: sourceIndexPath, to: destinationIndexPath)
        }
    }
    
    public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    @objc open func tableViewOrderChanged(moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {}
}
