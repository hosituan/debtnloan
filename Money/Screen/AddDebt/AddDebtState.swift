//
//  AddDebtState.swift
//  Money
//
//  Created by Tuan Si Ho (3406) on 10/01/2023.
//

import Foundation
import SwiftUI
import Combine
import RealmSwift

class AddDebtState: BaseState {
    override func subscribe() {
        $person.sink { value in
            Realm.writeValue {
                self.item.person = value
            }
        }.store(in: &subscription)
        $amount.sink { value in
            Realm.writeValue {
                self.item.amount = value
                if self.type == .add {
                    self.expectAmount = value
                }
            }
        }.store(in: &subscription)
        $issueDate.sink { value in
            Realm.writeValue {
                self.item.borrowDate = value
            }
        }.store(in: &subscription)
        $expectDate.sink { value in
            guard let value = value else { return }
            Realm.writeValue {
                self.item.expectDate = value
            }
        }.store(in: &subscription)
        $expectAmount.sink { value in
            Realm.writeValue {
                self.item.expectAmount = value
            }
        }.store(in: &subscription)
        $returnDate.sink { value in
            guard let value = value else { return }
            Realm.writeValue {
                self.item.paidDate = value
            }
        }.store(in: &subscription)
        $returnAmount.sink { value in
            Realm.writeValue {
                self.item.paidAmount = value
            }
        }.store(in: &subscription)
        $pickerSelectedIndex.sink { index in
            Realm.writeValue {
                self.item.status = PayStatus.allCases[index].rawValue
            }
        }.store(in: &subscription)
        $pickerTypeIndex.sink { index in
            Realm.writeValue {
                self.item.type = DebtType.allCases[index].rawValue
            }
        }.store(in: &subscription)
        formValidPublisher
            .receive(on: RunLoop.main)
            .map {
                return !$0
            }
            .assign(to: \.buttonDisable, on: self)
            .store(in: &subscription)
        $note.sink { value in
            Realm.writeValue {
                self.item.note = value
            }
        }.store(in: &subscription)
        
    }
    
    @Published var person: String = ""
    @Published var amount: Double = 0.0
    @Published var issueDate = Date()
    @Published var expectAmount: Double = 0.0
    @Published var expectDate: Date?
    @Published var returnDate: Date?
    @Published var returnAmount: Double = 0.0
    @Published var pickerSelectedIndex = 0
    @Published var pickerTypeIndex = 0
    @Published var note: String = ""
    @Published var buttonDisable = true
    
    var item = DebtItem() {
        didSet {
            self.person = item.person
            self.amount = item.amount
            self.issueDate = item.borrowDate
            self.expectAmount = item.expectAmount
            self.expectDate = item.expectDate
            self.returnDate = item.paidDate
            self.pickerSelectedIndex = PayStatus.allCases.firstIndex(where: {
                $0.rawValue == item.status
            }) ?? 0
            self.pickerTypeIndex = DebtType.allCases.firstIndex(where: {
                $0.rawValue == item.type
            }) ?? 0
        }
    }
    var type: AddDebtView.ViewType = .add
    
    private var isValidNamePublisher: AnyPublisher<Bool, Never> {
        $person
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { input in
                return !input.isEmpty
            }
            .eraseToAnyPublisher()
    }
    private var isValidAmountPublisher: AnyPublisher<Bool, Never> {
        $amount
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { amount in
                return amount > 0
            }
            .eraseToAnyPublisher()
    }
    private var formValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(isValidNamePublisher, isValidAmountPublisher)
            .map { isValidName, isValidAmount in
                return isValidName && isValidAmount
            }
            .eraseToAnyPublisher()
     }
}
