//
//  DataManager.swift
//  Money
//
//  Created by Tuan Si Ho (3406) on 25/12/2022.
//

import Foundation
import RealmSwift

class DataManager {
    static let shared = DataManager()
    private let userStandard = UserDefaults.standard
    
    func saveLoan(item: DebtItem) {
        guard let realm = Realm.safeInit() else {
            print("Init realm error")
            return
        }
        realm.safeWrite {
            realm.add(item)
        }
    }
    
    func loadDebt() -> [DebtItem] {
        guard let realm = Realm.safeInit() else {
            print("Init realm error")
            return []
        }
        return realm.objects(DebtItem.self).toArray(ofType: DebtItem.self)
    }
    
    func updateStatus(item: DebtItem, status: String) {
        guard let realm = Realm.safeInit() else {
            print("Init realm error")
            return
        }
        realm.safeWrite {
            item.status = status
        }
    }
}
