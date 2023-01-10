//
//  BaseState.swift
//  Money
//
//  Created by Tuan Si Ho (3406) on 10/01/2023.
//

import Foundation
import SwiftUI
import Combine

protocol BaseStateProtocol: ObservableObject {
    func subscribe()
    func unsubsribe()
}

class BaseState: BaseStateProtocol {
    func subscribe() {
        
    }
    
    func unsubsribe() {
        subscription.forEach {
            $0.cancel()
        }
    }
    
    var subscription = Set<AnyCancellable>()
    init() {
        print("Init \(String(describing: self))")
    }
    
    deinit {
        print("Deinit \(String(describing: self))")
        self.unsubsribe()
    }
    
}

