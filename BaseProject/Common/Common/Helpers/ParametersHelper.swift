//
//  ParametersHelper.swift
//  Common
//
//  Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//
import Foundation

open class ParametersHelper {
    
    // converts keyPath objects
    // a.b = 1 => a = { b = { 1 } }
    private class func setDictionaryValue( dictionary: inout [String: Any], value: Any, keys: ArraySlice<String>) {
        switch keys.count {
        case 1:
            return dictionary[keys.first!] = value
        case (2..<Int.max):
            let key = keys.first!
            var subDictionary = (dictionary[key] as? [String: Any]) ?? [:]
            setDictionaryValue(dictionary: &subDictionary, value: value, keys: keys.dropFirst())
            dictionary[key] = subDictionary as AnyObject
            return
        default:
            return
        }
    }
    
    private class func setParameters(_ dictionary: inout [String: Any], value: Any, forKeyPath keyPath: String) {
        let keys = keyPath.components(separatedBy: ".")
        setDictionaryValue(dictionary: &dictionary, value: value, keys: ArraySlice(keys))
    }
    
    // convert key path list to parameters
    public class func getDotNotationedParameters(_ parameters: Parameters) -> Parameters {
        var dictionary: Parameters = [:]
        
        for (key, value) in parameters {
            setParameters(&dictionary, value: value, forKeyPath: key)
        }
        
        return dictionary
    }
    
}
