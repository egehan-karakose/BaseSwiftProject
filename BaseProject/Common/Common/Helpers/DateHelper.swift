//
//  DateHelper.swift
//  Common
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import Foundation
//FIXME: TEST YAZILACAK
public class DateHelper {
    
    public class func isDateToday(_ date: String, formatter dateFormat: DateStringType) -> Bool {
        let calendar = Calendar.current
        let date = date.toDate(with: dateFormat)
        guard let convertedDate = date else { return false }
        return calendar.isDateInToday(convertedDate)
    }
    
    public class func isDateTomorrow(_ date: String, formatter dateFormat: DateStringType) -> Bool {
        let calendar = Calendar.current
        let date = date.toDate(with: dateFormat)
        guard let convertedDate = date else { return false }
        return calendar.isDateInTomorrow(convertedDate)
    }
  
    public class func isDateToday(date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDateInToday(date)
    }
    
    public class func isDateInYesterday(date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDateInYesterday(date)
    }
    
    public class func isDateWeekend(date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDateInWeekend(date)
    }
    
    public class func lastDateOfCurrentYear() -> Date {
        let year = Calendar.current.component(.year, from: Date())
        let firstDateOfNextYear = Calendar.current.date(from: DateComponents(year: year + 1, month: 1, day: 1))
        guard let firstDayOfNextYear = firstDateOfNextYear else { return Date() }
        let lastOfYear = Calendar.current.date(byAdding: .day, value: -1, to: firstDayOfNextYear) ?? Date()
        return lastOfYear
    }
    
    public class func firstDayOfGivenYear(date: Date) -> Date {
        let year  = Calendar.current.component(.year, from: date)
        let firstDateOfYear = Calendar.current.date(from: DateComponents(year: year, month: 1, day: 1))
        guard let firstDayOfYear = firstDateOfYear else { return Date() }
        return firstDayOfYear
    }
    
    public class func lastDayOfGivenYear(date: Date) -> Date {
        let year = Calendar.current.component(.year, from: date)
        let firstDateOfNextYear = Calendar.current.date(from: DateComponents(year: year, month: 1, day: 1))
        guard let firstDayOfNextYear = firstDateOfNextYear else { return Date() }
        let lastOfYear = Calendar.current.date(byAdding: .day, value: -1, to: firstDayOfNextYear) ?? Date()
        return lastOfYear
    }
    
    public class func createDate(dateString: String, with format: DateStringType) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        let formattedDate = formatter.date(from: dateString)
        if let date = formattedDate {
            return date
        }
        return Date()
    }
    
    public class func getNthPreviousDay(_ day: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .day, value: -day, to: Date()) ?? Date()
    }
    
    public class func getNthPreviousMonth(_ month: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .month, value: -month, to: Date()) ?? Date()
    }
    
    public class func getNthPreviousWeek(_ week: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .weekOfYear, value: -week, to: Date()) ?? Date()
    }
    
    public class func getNthPreviousYear(_ year: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .year, value: -year, to: Date()) ?? Date()
    }
    
    public class func getNthLastYear(_ year: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .year, value: year, to: Date()) ?? Date()
    }
    
}
