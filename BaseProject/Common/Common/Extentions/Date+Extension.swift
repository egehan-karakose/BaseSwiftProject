//
//  Date+Extension.swift
//  Common
//
// Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.

import UIKit

// swiftlint:disable identifier_name
public enum DateStringType: String {
    case yyyyMMdd = "yyyy-MM-dd"
    case ddMMyyyy = "dd/MM/yyyy"
    case ddMMyyyyHHmmssWithSlash = "dd/MM/yyyy HH:mm:ss"
    case ddMMyyyyWithDot = "dd.MM.yyyy"
    case ddMMyyyyHHmm = "dd.MM.yyyy HH:mm"
    case ddMMyyyyHHmmss = "dd.MM.yyyy HH:mm:ss"
    case d
    case dd
    case MM
    case MMM
    case MMMM
    case yyyy
    case hHmm = "HH:mm"
    case yyyyMMddHHmmss = "yyyy-MM-dd HH:mm:ss"
    case yyyyMMddTHHmmss = "yyyy-MM-dd'T'HH:mm:ss"
    case dd__mm__yyyy = "dd-mm-yyyy"
    case dd_mm_yyyy = "dd / mm / yyyy"
    case dd_MMMM_yyyy = "dd MMMM yyyy"
    case yyyyMMddTHHmmssSSSSSSZ = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
    case yyyyMMddTHHmmssZ = "yyyy-MM-dd'T'HH:mm:ssZ"
    case ddMMMM = "dd MMMM"
    case mm_yyyy = "MM-yyyy"
    case yyyyMM = "yyyyMM"
    case yyMMdd = "yyMMdd"
    case ddMMM = "dd MMM"
}
// swiftlint:enable identifier_name

public extension Date {

    func string(_ type: DateStringType = .ddMMyyyy, withToday: Bool = false) -> String {
        var formatter: DateFormatter?
        formatter = DateFormatter()
        formatter?.locale = Locale(identifier: Localization.currentLanguage.asParameter)
        formatter?.dateFormat = type.rawValue
        var returnValue: String?
        returnValue = formatter?.string(from: self)
        
        if let dateValue = returnValue, withToday, Calendar.current.isDate(self, inSameDayAs: Date()) {
            returnValue = dateValue + "  (Bugün)".localized
        }

        return "\(returnValue ?? "")"
    }
    
    // 2011-10-05T14:48:00.000Z
        // yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX
        var toIsoString: String {
            let dateFormatter = ISO8601DateFormatter()
            dateFormatter.timeZone = TimeZone.autoupdatingCurrent
            return dateFormatter.string(from: self)
        }
    
    var toDateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
    
    var toIsoFullDateString: String {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = .withFullDate
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        return dateFormatter.string(from: self)
    }
    
    static func maxDate(year: String? = nil) -> Date {
        let maxYear = Calendar.current.component(.year, from: Date()) + 21
        return DateHelper.createDate(dateString: "31/12/" + (year ?? String(maxYear)), with: .ddMMyyyy)
    }
    
    static var minDate: Date {
        return DateHelper.createDate(dateString: "31/12/1800", with: .ddMMyyyy)
    }
    
    func stripTime() -> Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        let date = Calendar.current.date(from: components)
        guard let rawDate = date else { return Date() }
        return rawDate
    }
    
    func getLocaleBaseDay() -> Date {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MMM-dd"
        dateformatter.locale = Locale(identifier: Localization.currentLanguage.asParameter)
        let stringFromDate = dateformatter.string(from: self)
        if let startOfToday = dateformatter.date(from: stringFromDate) {
            return startOfToday
        }
        return self
    }
    
    func subtract(years: Int = 0, months: Int = 0, days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date {
        let inverseYears = -1 * years
        let inverseMonths = -1 * months
        let inverseDays = -1 * days
        let inverseHours = -1 * hours
        let inverseMinutes = -1 * minutes
        let inverseSeconds = -1 * seconds
        return add(years: inverseYears, months: inverseMonths,
                   days: inverseDays, hours: inverseHours,
                   minutes: inverseMinutes, seconds: inverseSeconds)
    }
    
    func add(years: Int = 0, months: Int = 0, days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date {
        var targetDay: Date
        targetDay = Calendar.current.date(byAdding: .year, value: years, to: self)!
        targetDay = Calendar.current.date(byAdding: .month, value: months, to: targetDay)!
        targetDay = Calendar.current.date(byAdding: .day, value: days, to: targetDay)!
        targetDay = Calendar.current.date(byAdding: .hour, value: hours, to: targetDay)!
        targetDay = Calendar.current.date(byAdding: .minute, value: minutes, to: targetDay)!
        targetDay = Calendar.current.date(byAdding: .second, value: seconds, to: targetDay)!
        return targetDay
    }
}

extension Date {
   public var tomorrow: Date {
            return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
        }
    public var yesterday: Date {
            return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
        }
    public var noon: Date {
            return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
        }
    
    public func getLastYear() -> Date {
        return Calendar.current.date(
            byAdding: .year,
            value: -1, to: self)!
    }
    public func getLastMonth() -> Date {
        return Calendar.current.date(
            byAdding: .month,
            value: -1, to: Date())!
    }
    
    public func getLastThreeMonth() -> Date {
        return Calendar.current.date(
            byAdding: .month,
            value: -3, to: Date())!
    }
    public func getMonthText() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale =  Locale(identifier: Localization.currentLanguage.asParameter)
        dateFormatter.dateFormat = "LLLL"
        return dateFormatter.string(from: self)
    }
    public func getDayAndMonthText() -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .month], from: self)
        let dateFormatter = DateFormatter()
        dateFormatter.locale =  Locale(identifier: Localization.currentLanguage.asParameter)
        let monthName = dateFormatter.monthSymbols[(components.month ?? 1) - 1]
        return String(format: "%02d %@", components.day ?? 1, monthName)
    }
    public func getMonthAndYearText() -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month, .year], from: self)
        return String(format: "%02d/%d", components.month ?? 1, components.year ?? 1800)
    }
    public func getDateOfWeekDay(direction: Calendar.SearchDirection, weekDay: Int, considerToday consider: Bool = false) -> Date {
      let calendar = Calendar(identifier: .gregorian)
      if consider && calendar.component(.weekday, from: self) == weekDay {
        return self
      }
      var nextDateComponent = calendar.dateComponents([.hour, .minute, .second], from: self)
      nextDateComponent.weekday = weekDay
      let date = calendar.nextDate(after: self, matching: nextDateComponent, matchingPolicy: .nextTime, direction: direction)

      return date!
    }
    
    public func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    public func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
}
