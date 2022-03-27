//
//  FormController+EmptyData.swift
//  Comp
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import Foundation

extension FormController {
    
    private func showEmptyDataView() {
        guard let viewModel = emptyDataViewModel else { return }
        let view = FormEmptyDataView.loadFromNib()
        view.populate(with: viewModel)
        tableView.backgroundView = view
    }
    
    public func handleEmptyDataViewVisibility() {
        guard let show = shouldShowEmptyDataView() else { return }
        if show == true {
            showEmptyDataView()
        } else {
            tableView.backgroundView = nil
        }
    }
    
}
