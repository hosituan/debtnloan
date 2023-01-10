//
//  PayStatus.swift
//  Money
//
//  Created by Tuan Si Ho (3406) on 10/01/2023.
//

import Foundation
import SwiftUI

enum PayStatus: String, CaseIterable {
    case new
    case near
    case over
    case paid
    case notEnough
    case unknown
    
    static var allCaseString: [String] {
        var array = [String]()
        PayStatus.allCases.forEach {
            array.append($0.title)
        }
        return array
    }
    var title: String {
        switch self {
        case .new:
            return "Vừa mới mượn"
        case .near:
            return "Sắp tới ngày trả"
        case .over:
            return "Quá hạn"
        case .paid:
            return "Xong"
        case .unknown:
            return "Không rõ"
        case .notEnough:
            return "Trả chưa hết"
        }
    }
    
    var color: Color {
        switch self {
        case .new:
            return .blue.opacity(0.6)
        case .near, .notEnough:
            return .yellow
        case .over:
            return .red
        case .paid:
            return .green
        case .unknown:
            return .gray
        }
    }
}
