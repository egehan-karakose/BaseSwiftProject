//
//  BaseDefaults.swift
//  Common
//
// Created by Egehan KARAKÖSE (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 27.03.2022.
//

import Foundation

private var baseDefaultsSharedInstance: BaseDefaults!

public enum PersistentDomain: String {
    case test
    case production
}

public class BaseDefaults {
    
    private var config: PersistentDomain!
    private let defaults: UserDefaults!
    
    public class func setup(with config: PersistentDomain) {
        baseDefaultsSharedInstance = BaseDefaults(config: config)
    }
    
    public class var shared: BaseDefaults {
        if baseDefaultsSharedInstance == nil {
            // FIXME: fix it for different targets
            BaseDefaults.setup(with: .production)
        }
        return baseDefaultsSharedInstance
    }
    
    init(config: PersistentDomain) {
        self.config = config
        defaults = UserDefaults(suiteName: config.rawValue)
    }
    
    // MARK: - Public Helper Methods
    
    public func store<T>(with key: BaseDefaultsKeys, value: T) {
        defaults.set(value, forKey: key.rawValue)
    }
    
    public func store<T: Codable>(with key: BaseDefaultsKeys, value: T) {
        guard let data = try? JSONEncoder().encode(value) else { return }
        defaults.set(data, forKey: key.rawValue)
    }
    
	public func storeString(with key: BaseDefaultsKeys, value: String) {
		defaults.set(value, forKey: key.rawValue)
	}
	
    public func storeInt(with key: BaseDefaultsKeys, value: Int) {
        defaults.set(value, forKey: key.rawValue)
    }
    
    public func storeFlag(with key: BaseDefaultsKeys, value: Bool) {
        defaults.set(value, forKey: key.rawValue)
    }

    public func retrieve<T>(with key: BaseDefaultsKeys) -> T? {
        return defaults.object(forKey: key.rawValue) as? T
    }
    
    public func retrieveFlag(with key: BaseDefaultsKeys) -> Bool? {
        return defaults.object(forKey: key.rawValue) as? Bool
    }
    
    public func retrieveInt(with key: BaseDefaultsKeys) -> Int? {
        return defaults.integer(forKey: key.rawValue)
    }
    
    public func retrieveString(with key: BaseDefaultsKeys) -> String? {
        return defaults.string(forKey: key.rawValue)
    }

    public func retrieve<T: Codable>(with key: BaseDefaultsKeys) -> T? {
        
        guard
            let data = defaults.object(forKey: key.rawValue) as? Data,
            let model = try? JSONDecoder().decode(T.self, from: data) else { return nil }

        return model
    }
    
    public func clear(key: BaseDefaultsKeys) {
        defaults.removeObject(forKey: key.rawValue)
    }
    
    public func clearAll() {
        defaults.removePersistentDomain(forName: config.rawValue)
        defaults.synchronize()
    }
}
