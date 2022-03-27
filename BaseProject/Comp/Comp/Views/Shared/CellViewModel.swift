//
//  CellViewModel.swift
//  Comp
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import Foundation

open class CellViewModel: CellViewModelProtocol {
    
    open var selectionStyle: UITableViewCell.SelectionStyle = .default
    open var separatorInset: UIEdgeInsets?
    open var accessoryType: UITableViewCell.AccessoryType = .none
    open var accessoryView: UIView?
    
    public init() { }
}
