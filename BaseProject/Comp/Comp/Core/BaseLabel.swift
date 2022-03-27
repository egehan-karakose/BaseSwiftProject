//
//  BaseLabel.swift
//  Comp
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import UIKit

public enum LabelType: Int {
    case normal = 0
    case grayRegularText = 1
    case semiBoldNormal = 2
}

@IBDesignable
public class BaseLabel: UILabel {

    var labelType: LabelType = .normal

    @IBInspectable var labelTypeValue: Int = 0 {
        didSet {
            self.labelType = LabelType(rawValue: labelTypeValue) ?? .normal
            switch self.labelType {
            case .normal:
                self.font = UIFont.systemFont(ofSize: 18)
            case .grayRegularText:
                self.font = UIFont.systemFont(ofSize: 14)
                self.textColor = UIColor.gray
            case .semiBoldNormal:
                self.font = UIFont.boldSystemFont(ofSize: 14)
                self.textColor = UIColor.black
            }
            self.setNeedsLayout()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
