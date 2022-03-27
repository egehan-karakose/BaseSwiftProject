//
//  UICollectionView+Extensions.swift
//  Comp
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import Foundation
import UIKit

public extension UICollectionView {
    
    var isScrolling: Bool {
        return isDragging || isDecelerating
    }
    
    func register(_ cell: UICollectionViewCell.Type) {
        if cell.bundle?.path(forResource: cell.defaultNibName, ofType: "nib") != nil {
            register(cell.defaultNib, forCellWithReuseIdentifier: cell.defaultNibName)
        } else {
            register(cell, forCellWithReuseIdentifier: cell.defaultNibName)
        }
    }
    
    // swiftlint:disable force_cast
    func dequeue<T: UICollectionViewCell>(cell: T.Type, indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: cell.defaultNibName, for: indexPath) as! T
    }
    // swiftlint:enable force_cast
    
}
