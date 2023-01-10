//
//  DebtObject.swift
//  Money
//
//  Created by Tuan Si Ho (3406) on 10/01/2023.
//

import Foundation
import RealmSwift
import SwiftUI

enum DebtType: String, CaseIterable {
    case borrow
    case lend
    var title: String {
        switch self {
        case .borrow: return "Mượn"
        case .lend: return "Cho mượn"
        }
    }
    var color: Color {
        switch self {
        case .borrow: return .yellow
        case .lend: return .green
        }
    }
}
class DebtItem: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var person: String = ""
    @objc dynamic var amount: Double = 0.0
    @objc dynamic var expectAmount: Double = 0.0
    @objc dynamic var borrowDate: Date = Date()
    @objc dynamic var expectDate: Date?
    @objc dynamic var paidAmount: Double = 0.0
    @objc dynamic var paidDate: Date?
    @objc dynamic var status: String?
    @objc dynamic var note: String?
    @objc dynamic var type: String?
    
    var remainAmount: Double {
        return expectAmount - paidAmount
    }
    
    func debtType() -> DebtType {
        return DebtType(rawValue: type ?? "") ?? .borrow
    }
    
    func payStatus() -> PayStatus {
        let status = PayStatus(rawValue: status ?? "") ?? .unknown
        let expectDate = expectDate ?? Date()
        let diff = (expectDate - Date()).day ?? 0
        
        let start = (Date() - borrowDate).day ?? 0
        if self.remainAmount > 0, paidAmount > 0 {
            return .notEnough
        }
        if diff < 0 {
            return .over
        }
        if start < 5 {
            return .new
        }
        if diff < 5 {
            return .near
        }
        if diff > 5 {
            return .new
        }

        return .unknown
    }
}
