//
//  String+Extension.swift
//  Common
//
// Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.

import Foundation

//swiftlint:disable file_length
public extension String {
    
    subscript (offset: Int) -> Character {
        if offset > self.count {
            return " "
        }
        return self[index(startIndex, offsetBy: offset)]
    }
    
    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }
    
    var maskedPattern: String? {
        if self.isEmpty {
            return nil
        }
        var pattern = ""
        var maskCharacter = "#"
        for index in 0 ..< self.count {
            pattern.append(maskCharacter)
            if maskCharacter == "#" {
                maskCharacter = "*"
            } else {
                maskCharacter = "#"
            }
        }
        
        return pattern
    }
    
    var maskedForTextfield: String {
        return self.replacingOccurrences(of: "9", with: "-")
                .replacingOccurrences(of: "0", with: "-")
    }
    
    var letters: String {
        return String(unicodeScalars.filter(CharacterSet.letters.contains))
    }
    
    var trimWhitespaces: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func capitalizeFirst() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
    func containsLowerCased(_ stringSearch: String) -> Bool {
        return self.lowercased().contains(stringSearch.lowercased())
    }
    
    func containsLowerCasedWithLocale(_ stringSearch: String, locale: Locale? = nil) -> Bool {
        return self.lowercased(with: locale ?? Locale.current).contains(stringSearch.lowercased(with: locale ?? Locale.current))
    }
    
    func longDateStringToShortDateString(dateType: DateStringType = .yyyyMMdd) -> String {
        var formatter: DateFormatter?
        formatter = DateFormatter()
        formatter?.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let newString = self.replacingOccurrences(of: "T", with: " ")
        if let date: Date = formatter?.date(from: newString) {
            return date.string(dateType)
        } else {
            return Date.minDate.string(dateType)
        }
    }
    
    func toDate() -> Date {
        var formatter: DateFormatter?
        formatter = DateFormatter()
        formatter?.locale = Locale(identifier: "en-US")// 24 hour format
        formatter?.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let newString = self.replacingOccurrences(of: "T", with: " ")
        if let date: Date = formatter?.date(from: newString) {
            return date
        } else {
            return Date.minDate
        }
    }
    
    func toDate(with format: DateStringType) -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en-US")// 24 hour format
        formatter.dateFormat = format.rawValue
        if let date: Date = formatter.date(from: self) {
            return date
        }
        
        if format == .yyyyMMddTHHmmss {
            return toAlternateDate(with: .yyyyMMddTHHmmssZ)
        } else if format == .yyyyMMddTHHmmssZ {
            if let date = toAlternateDate(with: .yyyyMMddTHHmmss) {
                return date
            } else if let date = toAlternateDate(with: .yyyyMMddTHHmmssSSSSSSZ) {
                return date
            }
            return nil
        }
        return nil
    }
    
    func toAlternateDate(with format: DateStringType) -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en-US")// 24 hour format
        formatter.dateFormat = format.rawValue
        formatter.timeZone = .autoupdatingCurrent
        if let date: Date = formatter.date(from: self) {
            return date
        }
        return nil
    }
    
    func formattedDate(fromFormat: DateStringType, toFormat: DateStringType) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat.rawValue
        
        let date = dateFormatter.date(from: self)
        dateFormatter.dateFormat = toFormat.rawValue
        
        guard let formattedDate = date else { return "" }
        
        return dateFormatter.string(from: formattedDate)
    }
    
    func build(with params: String...) -> String {
        let str = self
        return String(format: str, params)
    }
    
    var getNumbers: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }
    
    var intValue: Int {
        return Int(self) ?? 0
    }
    
    func doubleValue() -> Double? {
        
       return NumberFormatter().number(from: self)?.doubleValue
    }
    
    var optionalIntValue: Int? {
        if let selfInDouble = Double(self) {
            return Int(selfInDouble)
        }
        return nil
    }
    
    func character(at position: Int) -> Character? {
        guard position >= 0, let indexPosition = index(at: position) else { return nil }
        return self[indexPosition]
    }
    
    func index(at position: Int, from start: Index? = nil) -> Index? {
        let startingIndex = start ?? startIndex
        return index(startingIndex, offsetBy: position, limitedBy: endIndex)
    }
    
    // Converts html string to attributed string.
    var htmlAsAttributed: NSAttributedString? {
        guard let htmlData = data(using: .unicode) else { return nil }
        let options = [NSAttributedString.DocumentReadingOptionKey.documentType:
            NSAttributedString.DocumentType.html]
        return try? NSAttributedString(data: htmlData, options: options, documentAttributes: nil)
    }
    
    var htmlAsMutableAttributed: NSMutableAttributedString? {
           guard let htmlData = data(using: .unicode) else { return nil }
           let options = [NSAttributedString.DocumentReadingOptionKey.documentType:
               NSAttributedString.DocumentType.html]
           return try? NSMutableAttributedString(data: htmlData, options: options, documentAttributes: nil)
       }
    
    var htmlDecoded: String {
        let decoded = try? NSAttributedString(data: Data(utf8), options: [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ], documentAttributes: nil).string
        
        return decoded ?? self
    }
    
    var divAlignRight: String {
        return "<div align=\"right\">\(self)</div>"
    }
    
    func separate(every stride: Int = 4, with separator: Character = " ") -> String {
        return String(enumerated().map { $0 > 0 && $0 % stride == 0 ? [separator, $1] : [$1]}.joined())
    }
    
    func labelHeight(constraintedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let label =  UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.text = self
        label.font = font
        label.sizeToFit()
        let height = label.frame.height
        return height
    }

    func substring(fromIndex: Int?, toIndex: Int?) -> String {
        if let start = fromIndex {
            guard start < self.count else { return "" }
        }
        
        if let end = toIndex {
            guard end >= 0 else { return "" }
        }
        
        if let start = fromIndex, let end = toIndex {
            guard end - start >= 0 else { return "" }
        }
        
        let startIndex: String.Index
        if let start = fromIndex, start >= 0 {
            startIndex = self.index(self.startIndex, offsetBy: start)
        } else {
            startIndex = self.startIndex
        }
        
        let endIndex: String.Index
        if let end = toIndex, end >= 0, end < self.count {
            endIndex = self.index(self.startIndex, offsetBy: end + 1)
        } else {
            endIndex = self.endIndex
        }
        
        return String(self[startIndex ..< endIndex])
    }
    
    func maskToString(mask: String) -> String {
        let cleanPhoneNumber = components(separatedBy: CharacterSet.decimalDigits.inverted).joined()

        var result = ""
        var index = cleanPhoneNumber.startIndex
        for character in mask where index < cleanPhoneNumber.endIndex {
            if character == "#" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(character)
            }
        }
        return result
    }
    
    func splitZeroNumberForNumberPad(text: String) -> String {
        var str = text
        str = str.replacingOccurrences(of: "0", with: "", options: [.anchored], range: nil)
        return str
    }
}

// MARK: Search Extensions

extension String {
    
    public var searchCompatible: String {
        let charactersToRemove = "_-*?=+^'!\\/;{}[] #"
        
        var replaceDictionary: [String: String] = [:]
        replaceDictionary["ç"] = "c"
        replaceDictionary["ö"] = "o"
        replaceDictionary["ı"] = "i"
        replaceDictionary["İ"] = "i"
        replaceDictionary["ğ"] = "g"
        replaceDictionary["ü"] = "u"
        replaceDictionary["ş"] = "s"
        replaceDictionary["i̇"] = "i"
        
        var text = self.replacingOccurrences(of: "İ", with: "i")
        text = text.lowercased().removing(charactersOf: charactersToRemove)
        
        for(key, value) in replaceDictionary {
            text = text.replacingOccurrences(of: key, with: value)
        }
        
        return text
    }
    
    public var orderCompatible: String {
        let charactersToRemove = "_-*?=+^'!\\/;,.{}[] #"
        
        var replaceDictionary: [String: String] = [:]
        replaceDictionary["ç"] = "ca"
        replaceDictionary["ö"] = "oa"
        replaceDictionary["ı"] = "ia"
        replaceDictionary["I"] = "ia"
        replaceDictionary["İ"] = "iaa"
        replaceDictionary["i̇"] = "iaa"
        replaceDictionary["ğ"] = "ga"
        replaceDictionary["ü"] = "ua"
        replaceDictionary["ş"] = "sa"
        
        var text = self.lowercased().removing(charactersOf: charactersToRemove)
        
        for(key, value) in replaceDictionary {
            text = text.replacingOccurrences(of: key, with: value)
        }
        return text
    }
    
    public func search(searchText: String) -> Bool {
        return self.searchCompatible.contains(searchText.searchCompatible)
    }
    
    public func removing(charactersOf string: String) -> String {
        let characterSet = CharacterSet(charactersIn: string)
        let components = self.components(separatedBy: characterSet)
        return components.joined(separator: "")
    }
    
    public func replacingInverted(of characterSet: CharacterSet?, with string: String) -> String {
        guard let characterSet = characterSet else { return self }
        return self.components(separatedBy: characterSet.inverted).joined(separator: string)
    }

    public func replaceCharacter(at index: Int, with character: Character) -> String {
        var chars = Array(self)
        chars[index] = character
        let modifiedString = String(chars)
        return modifiedString
    }
    
    public var removingSpaces: String {
        return self.filter { !" \n\t\r".contains($0) }
    }
    
    public var removingWithSpace: String {
        return String(self.replacingOccurrences(of: " ", with: "").dropFirst(0))
    }
    
   public func maskPhoneNumberIfNeed(mask: String) -> String {
    if self.count != 13 {
        return self.substring(fromIndex: 1, toIndex: 10).maskToString(mask: mask)
    }
    return self
   }
}

// MARK: Mask Extension

extension StringProtocol where Index == String.Index {
    public func indexDistance(of string: Self) -> Int? {
        guard let index = range(of: string)?.lowerBound else { return nil }
        return distance(from: startIndex, to: index)
    }
}

// MARK: Image Extension

extension String {
    public var asUIImage: UIImage? {
        // Convert image base64 to UIImage
        guard let dataDecoded: Data = Data(base64Encoded: self, options: .ignoreUnknownCharacters) else { return nil }
        guard let decodedimage = UIImage(data: dataDecoded) else { return nil }
        return decodedimage
    }
}

// MARK: Accesibility

extension String {
    public var accesibilityString: String {
        let aString = self.replacingOccurrences(of: "/EFT", with: "/EFETE")
            .replacingOccurrences(of: "TCKN/VKN", with: "Türkiye cumhuriyeti kimlik numarası ya da vergi kimlik numarası".localized)
        return aString
    }
}

// MARK: Formatters

extension String {
    
    public var phoneNumberFormatted: String {
        if self.count < 10 {
            return self
        }
        let areaCode = self.substring(fromIndex: 0, toIndex: 2)
        let firstNumberPart = self.substring(fromIndex: 3, toIndex: 5)
        let secondNumberPart = self.substring(fromIndex: 6, toIndex: 7)
        let lastNumberPart = self.substring(fromIndex: 8, toIndex: self.count - 1)
        
        return String.init(format: "(%@) %@ %@ %@",
                           areaCode,
                           firstNumberPart,
                           secondNumberPart,
                           lastNumberPart)
    }
    
}
//swiftlint:enable file_length
