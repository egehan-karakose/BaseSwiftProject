//
//  FormController+Visibility.swift
//  Comp
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import Foundation

extension FormController {
    
    public func setRowVisibility(_ show: Bool, row: FormRowDataSource?,
                                 animation: UITableView.RowAnimation = .fade,
                                 completion: (() -> Void)? = nil) {
        guard let row = row else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [weak self] in
            if row.isEnabled == show { return }
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                if let receivedCompletion = completion {
                    receivedCompletion()
                }
            }
            if show {
                self?.showRow(row, animation: animation)
            } else {
                self?.hideRow(row, animation: animation)
            }
            CATransaction.commit()
        }
    }
    
    public func reloadRow(_ row: FormRowDataSource?, animation: UITableView.RowAnimation = .fade) {
        guard let row = row else { return }
        guard let indexPath = findSuitableIndexPath(row) else { return }
        if animation == .none {
            UIView.performWithoutAnimation { [weak self] in
                self?.tableView.reloadRows(at: [indexPath], with: animation)
            }
        } else {
            tableView.reloadRows(at: [indexPath], with: animation)
        }
    }
    
    public func reloadSection(_ section: FormSection?, animation: UITableView.RowAnimation = .middle, completion: (() -> Void)? = nil) {
        guard let section = section else { return }
        guard let sectionIndex = data?
            .filter({ $0.isEnabled || $0 === section })
            .firstIndex(where: { $0 === section }) else { return }
        let indexSet = IndexSet(arrayLiteral: sectionIndex)
        reloadSections(indexSet, with: animation, completion: completion)
    }
    
    private func reloadSections(_ indexSet: IndexSet, with animation: UITableView.RowAnimation, completion: (() -> Void)? = nil) {
        func operation() {
            if animation == .none {
                UIView.performWithoutAnimation { [weak self] in
                    self?.tableView.reloadSections(indexSet, with: animation)
                }
            } else {
                tableView.reloadSections(indexSet, with: animation)
            }
        }
        
        if let receivedCompletion = completion {
            DispatchQueue.main.async {
                CATransaction.begin()
                CATransaction.setCompletionBlock {
                    receivedCompletion()
                }
                operation()
                CATransaction.commit()
            }
        } else {
            operation()
        }
    }
    
    public func setSectionVisibility(_ show: Bool, section: FormSection?, animation: UITableView.RowAnimation = .middle) {
        guard let section = section else { return }
        
        if section.isEnabled == show { return }
        if show {
            self.showSection(section, animation: animation)
        } else {
            self.hideSection(section, animation: animation)
        }
    }
        
    public func reloadDataWithoutScrolling() {
        let offset = tableView.contentOffset
        textFieldIndexArray.removeAll()
        tableView.reloadData()
        tableView.layoutIfNeeded()
        tableView.setContentOffset(offset, animated: false)
    }
    
    private func hideSection(_ section: FormSection, animation: UITableView.RowAnimation) {
        guard let sectionIndex = data?
            .filter({ $0.isEnabled || $0 === section })
            .firstIndex(where: { $0 === section }) else {
                section.isEnabled = false
                return
            }
        let indexSet = IndexSet(arrayLiteral: sectionIndex)
        section.isEnabled = false
        if animation == .none {
            UIView.performWithoutAnimation { [weak self] in
                self?.tableView.deleteSections(indexSet, with: animation)
            }
        } else {
            tableView.deleteSections(indexSet, with: animation)
        }
    }
    
    private func showSection(_ section: FormSection, animation: UITableView.RowAnimation) {
        guard let sectionIndex = data?
            .filter({ $0.isEnabled || $0 === section })
            .firstIndex(where: { $0 === section }) else {
                section.isEnabled = true
                return
            }
        let indexSet = IndexSet(arrayLiteral: sectionIndex)
        section.isEnabled = true
        if animation == .none {
            UIView.performWithoutAnimation { [weak self] in
                self?.tableView.insertSections(indexSet, with: animation)
            }
        } else {
            tableView.insertSections(indexSet, with: animation)
        }
    }
    
    private func hideRow(_ row: FormRowDataSource, animation: UITableView.RowAnimation) {
        if !row.isEnabled { return }
        guard let indexPath = findSuitableIndexPath(row) else {
            row.isEnabled = false
            return
        }
        row.isEnabled = false
        if animation == .none {
            UIView.performWithoutAnimation { [weak self] in
                self?.tableView.deleteRows(at: [indexPath], with: animation)
            }
        } else {
            tableView.deleteRows(at: [indexPath], with: animation)
        }
    }
    
    private func showRow(_ row: FormRowDataSource, animation: UITableView.RowAnimation) {
        if row.isEnabled { return }
        guard let suitableIndexPath = findSuitableIndexPath(row) else {
            row.isEnabled = true
            return
        }
        if animation == .none {
            UIView.performWithoutAnimation { [weak self] in
                self?.tableView.beginUpdates()
                self?.tableView.insertRows(at: [suitableIndexPath], with: animation)
                row.isEnabled = true
                self?.tableView.endUpdates()
            }
        } else {
            tableView.beginUpdates()
            tableView.insertRows(at: [suitableIndexPath], with: animation)
            row.isEnabled = true
            tableView.endUpdates()
        }
    }
    
    private func findSuitableIndexPath(_ row: FormRowDataSource) -> IndexPath? {
        guard let data = data else { return nil }
        // section ı bul
        // swiftlint:disable early_guard
        guard let section = data.first(where: {
            return $0.rows?.firstIndex(where: { $0 === row }) != nil
        }) else { return nil }
        // swiftlint:enable early_guard
        guard let sectionIndex = data.filter({ $0.isEnabled }).firstIndex(where: { $0 === section })
            else { return nil }
        
        let rows = section.rows?.filter({ $0.isEnabled || $0 === row })
        guard let rowIndex = rows?.firstIndex(where: { $0 === row }) else { return nil }
        
        let indexPath = IndexPath(row: rowIndex, section: sectionIndex)
        return indexPath
    }
    
}
