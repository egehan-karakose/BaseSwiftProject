//
//  SearchEmptyContentViewModel.swift
//  Comp
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import Foundation

public class SearchEmptyContentViewModel: SearchEmptyContentViewModelDataProtocol {
    
    private static let description = " ile ilgili kayıt bulunamadı.".localized
    
    public var title: String? {
        if shouldSetGenericTitle ?? false {
            return "“\(searchText ?? "")” \(SearchEmptyContentViewModel.description)"
        } else {
            return "\(searchText ?? "")"
        }
    }
    
    public var shouldSetGenericTitle: Bool?
    
    var searchText: String?
    
    public init(with searchText: String?, shouldSetGenericTitle: Bool? = nil) {
        self.searchText = searchText
        self.shouldSetGenericTitle = shouldSetGenericTitle
    }
    
}
