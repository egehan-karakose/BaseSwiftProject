//
//  CircleCloseButton.swift
//  Comp
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import Foundation

public class CircleCloseButton: UIButton {
    
    // MARK: - Object Lifecycle
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setView()
    }
    
}

// MARK: - Private UI Helpers

private extension CircleCloseButton {
    func setView() {
        setBackgroundColor()
        setImage()
    }
    
    func setImage() {
        let backgroundImage = UIImage(named: "lightGrayClose")
        setBackgroundImage(backgroundImage, for: .normal)
    }
    
    func setBackgroundColor() {
        backgroundColor = UIColor.clear
    }
    
}
