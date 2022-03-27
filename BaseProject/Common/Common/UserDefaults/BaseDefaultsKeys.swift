//
//  BaseDefaultsKeys.swift
//  Common
//
// Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import Foundation

public enum BaseDefaultsKeys {
    case isShowCaseShowed
    case environment
    case languageKey
    case lastLoggedInUsers
	case lastSelectedActivationType
    case kobilUsers
    case offlineOtpCount
    case pushToken
    case profileImages
    case cardCampaignBadgeCount
    case searchHistory
    case onboardingShowed
    case plannedWorkScheduleMaxIndividualId
    case plannedWorkScheduleMaxCorporateId
    case qrOperationAmount
    case hasAlreadyDigitalPassword
    case hasAlreadyCorpDigitalPassword
    case isDigitalPasswordShowCaseShowed
    case isCorpDigitalPasswordShowCaseShowed
    case payWithQr
    case sendMoneyWithQr
    case showQr
    case isShowedOnBoardingFXProtectedAccount
    case isShowedOnBoardingFXForeignCurrency
    
    case string(value: String)
}

extension BaseDefaultsKeys: RawRepresentable {
    
    public typealias RawValue = String
    
    public init?(rawValue: String) {
        fatalError("this enum should not be initialized.")
    }
    
    public var rawValue: String {
        switch self {
        case .string(let value):
            return value
        default:
            return String(describing: self)
        }
    }

}
