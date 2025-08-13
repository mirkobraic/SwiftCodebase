//
//  CacheManager.swift
//  RAWGExplorer
//
//  Created by Mirko Braić on 16.03.2023..
//

import Foundation

class Cache<Key: Hashable, Value> {
    private let inner = NSCache<WrappedKey, Entry>()
    
    func insert(_ value: Value, forKey key: Key) {
        inner.setObject(Entry(value: value), forKey: WrappedKey(key))
    }

    func value(forKey key: Key) -> Value? {
        let entry = inner.object(forKey: WrappedKey(key))
        return entry?.value
    }

    func removeValue(forKey key: Key) {
        inner.removeObject(forKey: WrappedKey(key))
    }
    
    subscript(key: Key) -> Value? {
        get { return value(forKey: key) }
        set {
            guard let newValue else {
                removeValue(forKey: key)
                return
            }

            insert(newValue, forKey: key)
        }
    }
}

extension Cache {
    class WrappedKey: NSObject {
        let key: Key
        override var hash: Int { key.hashValue }
        
        init(_ key: Key) {
            self.key = key
        }
        
        override func isEqual(_ object: Any?) -> Bool {
            guard let value = object as? WrappedKey else { return false }
            return value.key == key
        }
    }
    
    class Entry {
        let value: Value
        
        init(value: Value) {
            self.value = value
        }
    }
}

class CacheManager {
    static let shared = CacheManager()
    private init() { }
    
    private var gameDetailsCache = Cache<Int, GameDetails>()
    
    func getGameDetails(forId id: Int) -> GameDetails? {
        return gameDetailsCache[id]
    }
    
    func setGameDetails(_ gameDetails: GameDetails) {
        gameDetailsCache[gameDetails.id] = gameDetails
    }
}
