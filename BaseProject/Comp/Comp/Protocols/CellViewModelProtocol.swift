//
//  CellViewModelProtocol.swift
//  Comp
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import Foundation

public protocol CellViewModelProtocol {
    
    var selectionStyle: UITableViewCell.SelectionStyle { get }
    var separatorInset: UIEdgeInsets? { get }
    var accessoryType: UITableViewCell.AccessoryType { get }
    var accessoryView: UIView? { get }

}
