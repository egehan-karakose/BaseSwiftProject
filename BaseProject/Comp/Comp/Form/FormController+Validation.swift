//
//  FormController+Validation.swift
//  Comp
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import Foundation

extension FormController {
    
    public var isValid: Bool {
        guard let rowsToValidate = getEnabledRows()?.filter({ !$0.validators.isEmpty }) else { return true }
        let unvalidRows = rowsToValidate.filter({ !$0.validate(setErrorText: false) })
        return unvalidRows.isEmpty
    }
    
    @discardableResult
    public func validate() -> Bool {
        guard let rowsToValidate = getEnabledRows()?.filter({ !$0.validators.isEmpty }) else { return true }
        let unvalidRows = rowsToValidate.filter({ !$0.validate() })
        
        if unvalidRows.isEmpty {
            return true
        } else {
            handleValidationFailForRows(unvalidRows)
            return false
        }
    }
    
    public func clearValidationFails() {
        guard let rowsToCheck = getEnabledRows()?.filter({ !$0.validators.isEmpty }) else { return }
        for row in rowsToCheck where !row.isValid {
            row.clearValidationState()
            row.validationStateChanged()
        }
    }
    
    private func handleValidationFailForRows(_ unvalidRows: [FormRowDataSource]) {
        view.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.tableView.reloadData()
        }, completion: { [weak self] _ in
            self?.view.isUserInteractionEnabled = true
            self?.scrollToFirstInvalidRow(unvalidRows)
        })
    }
    
    private func scrollToFirstInvalidRow(_ unvalidRows: [FormRowDataSource]) {
        guard let cell = unvalidRows.first?.getCell(tableView, reuse: false) else { return }
        guard let indexPath = tableView.indexPathForRow(at: cell.center) else { return }
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.tableView.scrollToRow(at: indexPath, at: .middle, animated: false)
        }, completion: { _ in
            cell.shake()
        })
    }
    
}
