//
//  WrongPasswordView.swift
//  UIComp
//
// Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import Foundation

public class WrongPasswordView: UIView, CustomableAlertViewProtocol {
    
    @IBOutlet weak var lblWrongPassword: UILabel!
    @IBOutlet weak var lblWrongPasswordMessage: UILabel!
    @IBOutlet var contentView: UIView!
    
    public var size = CGSize(width: 0, height: 60)
    public var onClose: (() -> Void)?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        Bundle.uiComp!.loadNibNamed("WrongPasswordView", owner: self, options: nil)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)
    }
    
    public func setWrongPasswordText(text: String) {
        lblWrongPassword.text = "Son Hatalı Giriş:".localized
        lblWrongPasswordMessage.text = text
    }
}

// MARK: - NibLoadable
extension WrongPasswordView: NibLoadable { }
