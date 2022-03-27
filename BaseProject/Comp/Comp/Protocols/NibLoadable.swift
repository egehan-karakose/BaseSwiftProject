//
//  NibLoadable.swift
//  Comp
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import UIKit

// MARK: - UIView

public protocol NibLoadable: class {
    static var defaultNibName: String { get }
    static var bundle: Bundle? { get }
    static func loadFromNib() -> Self
}

extension NibLoadable {
    
    public static var bundle: Bundle? {
        return Bundle(for: self)
    }
}

// MARK: - UIView

extension NibLoadable where Self: UIView {
    
    public static var defaultNibName: String {
        return String(describing: self)
    }
    
    public static var defaultNib: UINib {
        return UINib(nibName: defaultNibName, bundle: bundle)
    }
    
    public static func loadFromNib() -> Self {
        guard let nib = bundle?.loadNibNamed(defaultNibName,
                                             owner: nil,
                                             options: nil)?.first as? Self
            else {
                fatalError("[NibLoadable] Cannot load view from nib.")
        }
        return nib
    }
}

// MARK: - UIViewController

extension NibLoadable where Self: UIViewController {
    
    static var defaultNibName: String {
        return String(describing: self)
    }
    
    static var defaultNib: UINib {
        return UINib(nibName: defaultNibName, bundle: bundle)
    }
    
    static func loadFromNib() -> Self {
        return self.init(nibName: defaultNibName, bundle: bundle)
    }
}
