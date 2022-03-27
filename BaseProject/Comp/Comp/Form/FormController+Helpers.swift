//
//  FormController+Helpers.swift
//  Comp
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import Foundation
import Common

extension FormController {
    
    public func deselectSelectedRow() {
        if let selectedIndex = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndex, animated: true)
        }
    }
    
    public func rowAtIndexPath(indexPath: IndexPath) -> FormRowDataSource? {
        let sections = data?.filter({ $0.isEnabled })
        guard sections?.count ?? -1 >= indexPath.section else { return nil }
        let section = sections?[indexPath.section]
        let rows = section?.rows?.filter({ $0.isEnabled })
        guard rows?.count ?? -1 >= indexPath.row else { return nil }
        let row = rows?[indexPath.row]
        return row
    }
    
}
