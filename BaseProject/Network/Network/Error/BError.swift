//
//  BError.swift
//  Network
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import Foundation

public enum BError: Error {
    case undefined
    case authentication
    case badRequest
    case notFound
    case internalError
    case noData
    case connection
    case unableToDecode
    case requestCannotBeBuilt
    case statusHasError(errorPair: [ErrorPair]?)
}

extension BError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .authentication:
            return "Yetkinlendirme hatası oluştu.".localized
        case .badRequest:
            return "Yapılan işlemde sistemsel bir eksik mevcut.".localized
        case .notFound:
            return "Aranılan öğe bulunamadı.".localized
        case .internalError:
            return "Sistem kaynaklı bir hata oluştu.".localized
        case .noData:
            return "Yapılan işlem sonucunda gösterilecek bir öğe bulunamadı.".localized
        case .connection:
            return "Şu anda işleminizi gerçekleştiremiyoruz. Lütfen daha sonra tekrar deneyin".localized
        case .unableToDecode:
            return "Şu anda işleminizi gerçekleştiremiyoruz. Lütfen daha sonra tekrar deneyin".localized
        case .requestCannotBeBuilt:
            return "İşlemin gerçekleşmesi için çağrı oluşturulamadı.".localized
        case .statusHasError(let errorPair):
            return errorPair?.first?.message ?? "Bilinmeyen bir hata oluştu.".localized
        default:
            return "Bilinmeyen bir hata oluştu.".localized
        }
    }
}
