//
//  CharacterSet+Extensions.swift
//  Common
//
// Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.

import Foundation

extension CharacterSet {
    
    public static var lettersWithSpace: CharacterSet {
        var characterSet = CharacterSet.letters
        characterSet.insert(charactersIn: " ")
        return characterSet
    }
    
    public static var alphanumericsWithSpace: CharacterSet {
        var characterSet = CharacterSet.alphanumerics
        characterSet.insert(charactersIn: " ")
        return characterSet
    }
    
    public static var moneyTransferLargeCharacterSet: CharacterSet {
        var characterSet = alphanumericsWithSpace
        characterSet.insert(charactersIn: ".,-()*+[]:;")
        return characterSet
    }
    
    public static var adressCharacterSet: CharacterSet {
        var characterSet = alphanumericsWithSpace
        characterSet.insert(charactersIn: "./-")
        return characterSet
    }
    
    public static var alphaNumericswithSpecialCharacters: CharacterSet {
        var characterSet = alphanumericsWithSpace
        characterSet.insert(charactersIn: "!;,.:()[]/")
        return characterSet
    }
    
    public static var swiftTransferLetterCharacterSet: CharacterSet {
        var characterSet = alphanumericsWithSpace
        characterSet.insert(charactersIn: "+|'`/()?-.,:")
        return characterSet
    }
}
