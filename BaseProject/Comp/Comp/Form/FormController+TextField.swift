//
//  FormController+TextField.swift
//  Comp
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import Foundation

extension FormController {
    
    func nextAvailableViewToFocus() -> UIView? {
        
        let firstResponder = tableView.findFirstResponder()
        let responderCell = firstResponder?.findSuperview(of: UITableViewCell.self)
        let cells = getEnabledRows()?.compactMap({ $0.tableViewCell })
        
        var isFound = false
        let laterCells = cells?.filter({ cell in
            if cell == responderCell {
                isFound = true
                return false
            }
            return isFound
        })
        
        let cellToMakeResponder = laterCells?.first(where: { cell in
            if let textField = cell.findSubview(of: UITextField.self) {
                if textField.isEnabled { return true }
            }
            return false
        })
        
        if cellToMakeResponder != nil {
            if let textField = cellToMakeResponder?.findSubview(of: UITextField.self) {
                return textField
            }
        }
        
        return nil
    }
    
}
