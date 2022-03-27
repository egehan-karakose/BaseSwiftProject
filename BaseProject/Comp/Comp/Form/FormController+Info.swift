//
//  FormController+Info.swift
//  Comp
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import Foundation

extension FormController {
    
    public func setInfoText(_ infoText: String?) {
        guard let infoText = infoText else { return }
        let infoView = InfoView.loadFromNib()
        let viewModel = InfoViewModel()
        viewModel.text = infoText
        infoView.populate(with: viewModel)
        setHeaderViews([infoView])
    }

    public func setHeaderViews(_ views: [UIView]) {
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill

        for subview in stackView.arrangedSubviews {
            stackView.removeArrangedSubview(subview)
        }

        for view in views {
            stackView.addArrangedSubview(view)
        }

        UIView.performWithoutAnimation {
            tableView.setTableHeaderView(headerView: stackView)
        }
    }
    
    public func removeHeaderView() {
        UIView.performWithoutAnimation {
            tableView.tableHeaderView?.frame = CGRect.zero
        }
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if tableView.shouldUpdateHeaderViewFrame() {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
}
