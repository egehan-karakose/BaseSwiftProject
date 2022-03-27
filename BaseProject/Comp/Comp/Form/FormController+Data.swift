//
//  FormController+Data.swift
//  Comp
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import Foundation
import Common

extension FormController {
    
    public func insertSection(_ section: FormSection, at index: Int? = nil, animation: UITableView.RowAnimation = .automatic) {
        tableView.beginUpdates()
        var indexAdded = 0
        if let index = index {
            data?.insert(section, at: index)
            indexAdded = index
        } else {
            indexAdded = (data?.count)~
            data?.insert(section, at: indexAdded)
        }
        tableView.insertSections(IndexSet.init(arrayLiteral: indexAdded), with: animation)
        tableView.endUpdates()
    }
    
    public func deleteSection(at index: Int? = nil, animation: UITableView.RowAnimation = .automatic) {
        var indexRemoved = 0
        if let index = index {
            indexRemoved = index
        } else {
            indexRemoved = (data?.count)~ - 1
        }
        if (data?.count)~ > indexRemoved {
            tableView.beginUpdates()
            data?.remove(at: indexRemoved)
            tableView.deleteSections(IndexSet.init(arrayLiteral: indexRemoved), with: animation)
            tableView.endUpdates()
        }
    }
    
    public func insertRow(_ row: FormRowDataSource?, at rowIndex: Int, sectionIndex: Int, animation: UITableView.RowAnimation = .automatic) {
        guard let row = row else { return }
        tableView.beginUpdates()
        
        if let section = data?[sectionIndex] {
            section.rows?.insert(row, at: rowIndex)
            tableView.insertRows(at: [IndexPath(row: rowIndex, section: sectionIndex)], with: animation)
        }
        
        tableView.endUpdates()
    }
    
    public func scrollTo(sectionIndex: Int, animated: Bool = true) {
        if (data?.count)~ > sectionIndex {
            tableView.scrollToRow(at: IndexPath(item: 0, section: sectionIndex), at: .bottom, animated: animated)
        }
    }

    public func deleteRow(at rowIndex: Int, sectionIndex: Int, animation: UITableView.RowAnimation = .automatic) {
        if (data?.count)~ <= sectionIndex { return }
        guard let section = data?[sectionIndex] else { return }
        if (section.rows?.count)~ <= rowIndex { return }
        
        tableView.beginUpdates()
        section.rows?.remove(at: rowIndex)
        tableView.deleteRows(at: [IndexPath.init(row: rowIndex, section: sectionIndex)], with: animation)
        tableView.endUpdates()
    }
    
}
