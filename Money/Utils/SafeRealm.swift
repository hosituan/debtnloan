//
//  SafeRealm.swift
//  Money
//
//  Created by Tuan Si Ho (3406) on 25/12/2022.
//

import Foundation
import RealmSwift

extension Results {
    func toArray<T>(ofType: T.Type) -> [T] {
        var array = [T]()
        for i in 0 ..< count {
            if let result = self[i] as? T {
                array.append(result)
            }
        }
        return array
    }
}

extension Realm {
    static func writeValue(_ block: () -> ()) {
        guard let realm = self.safeInit() else { return }
        realm.safeWrite {
            block()
        }
    }
    
    static func safeInit() -> Realm? {
        do {
            let config = Realm.Configuration(
                        // Set the new schema version. This must be greater than the previously used
                        // version (if you've never set a schema version before, the version is 0).
                        schemaVersion: 2,
                        
                        // Set the block which will be called automatically when opening a Realm with
                        // a schema version lower than the one set above
                        migrationBlock: { migration, oldSchemaVersion in
                            // We haven’t migrated anything yet, so oldSchemaVersion == 0
                            if (oldSchemaVersion < 1) {
                                // Nothing to do!
                                // Realm will automatically detect new properties and removed properties
                                // And will update the schema on disk automatically
                            }
                    })
            let realm = try Realm(configuration: config)
            return realm
        }
        catch let error {
            print(error.localizedDescription)
        }
        return nil
    }

    func safeWrite(_ block: () -> ()) {
        do {
            // Async safety, to prevent "Realm already in a write transaction" Exceptions
            if !isInWriteTransaction {
                try write(block)
            }
        } catch {
            // LOG ERROR
        }
    }
}
