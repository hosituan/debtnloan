//
//  HomeState.swift
//  Money
//
//  Created by Tuan Si Ho (3406) on 10/01/2023.
//

import Foundation
import SwiftUI
import Combine

class HomeState: BaseState {
    override func subscribe() {
        $debts
            .sink { items in
                var total = 0.0
                items.forEach { item in
                    let type = item.debtType()
                    let status = item.payStatus()
                    if type == .lend {
                        if status != .paid {
                            total += item.amount
                        }
                    } else {
                        if status != .paid {
                            total -= item.amount
                        }
                    }
                    self.total = "\(total.toCurrenctString())"
                }
            }
            .store(in: &subscription)
    }
    @Published var total: String = ""
    @Published var debts = [DebtItem]()
    
}
