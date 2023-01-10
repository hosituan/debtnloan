//
//  HomeRouter.swift
//  Money
//
//  Created by Tuan Si Ho (3406) on 10/01/2023.
//

import Foundation
import SwiftUI

final class HomeRouter: ObservableObject {
    static let shared: HomeRouter = .init()
    @Published var isShowingAddDebt = false
    @Published var isShowingDetail = false
    @Published var needUpdateList = false
}
