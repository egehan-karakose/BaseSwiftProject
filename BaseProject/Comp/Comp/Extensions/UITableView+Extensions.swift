//
//  UITableView+Extensions.swift
//  Comp
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import Foundation
import Common

public extension UITableView {
    
    func register(_ cell: UITableViewCell.Type) {
        if cell.bundle?.path(forResource: cell.defaultNibName, ofType: "nib") != nil {
            register(cell.defaultNib, forCellReuseIdentifier: cell.defaultNibName)
        } else {
            register(cell, forCellReuseIdentifier: cell.defaultNibName)
        }
    }
    
    // swiftlint:disable force_cast
    func dequeue<T: UITableViewCell>(cell: T.Type, indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: cell.defaultNibName, for: indexPath) as! T
    }
    
    func dequeue<T: UITableViewCell>(cell: T.Type) -> T {
        return dequeueReusableCell(withIdentifier: cell.defaultNibName) as! T
    }
    
    // swiftlint:enable force_cast
 
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.sizeToFit()
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        backgroundView = messageLabel
        backgroundView?.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        backgroundView?.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        backgroundView?.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        backgroundView?.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
    }
    
    func removeEmptyView() {
        backgroundView = nil
        separatorStyle = .singleLine
    }
    
    func setTableHeaderView(headerView: UIView) {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        tableHeaderView = headerView
        headerView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        headerView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        headerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
    }
    
    func shouldUpdateHeaderViewFrame() -> Bool {
        guard let headerView = self.tableHeaderView else { return false }
        let oldSize = headerView.bounds.size
        headerView.layoutIfNeeded()
        let newSize = headerView.bounds.size
        return oldSize.height != newSize.height
    }
    
    func scroll(to direction: ScrollDirection, animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
            let numberOfSections = self.numberOfSections
            if numberOfSections <= 0 {
                return
            }
            let numberOfRows = self.numberOfRows(inSection: numberOfSections - 1)
            switch direction {
            case .top:
                if numberOfRows > 0 {
                    let indexPath = IndexPath(row: 0, section: 0)
                    self.scrollToRow(at: indexPath, at: .top, animated: animated)
                }
            case .bottom:
                if numberOfRows > 0 {
                    let indexPath = IndexPath(row: numberOfRows-1, section: (numberOfSections-1))
                    self.scrollToRow(at: indexPath, at: .bottom, animated: animated)
                }
            }
        }
    }
    
    func reloadData(completion: @escaping VoidHandler) {
        UIView.animate(withDuration: 0, animations: {
            self.reloadData()
        }) { _ in
            completion()
        }
    }
    
    enum ScrollDirection {
        case top, bottom
    }
}
