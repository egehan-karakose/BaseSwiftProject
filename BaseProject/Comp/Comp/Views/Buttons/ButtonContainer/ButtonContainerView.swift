//
//  ButtonContainer.swift
//  Comp
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import Foundation

public class ButtonContainerView: UIView {
    
    @IBOutlet var contentView: UIView!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        Bundle.uiComp!.loadNibNamed("ButtonContainerView", owner: self, options: nil)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.height(constant: 52)
        contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        addSubview(contentView)
    }
    
    public func addButton(button: UIButton, constraintValue: CGFloat = 16.0) {
        contentView.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: constraintValue).isActive = true
        button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -constraintValue).isActive = true
        button.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 1).isActive = true
        button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 1).isActive = true
    }
}
