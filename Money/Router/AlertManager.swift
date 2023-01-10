//
//  AlertManager.swift
//  Money
//
//  Created by Tuan Si Ho (3406) on 10/01/2023.
//

import Foundation
import SwiftUI

class AlertManager: ObservableObject {
    @Published var isShowingAlert = false
   
    @Published var alertTitle: String? = "Error"
    @Published var alertMessage: String?
    @Published var okButtonTitle: String?
    var primaryAction: (() -> Void)?
    
    @Published var alert: Alert?
    
    func show(title: String?, message: String?) {
        self.alertTitle = title
        self.alertMessage = message
        self.isShowingAlert = true
    }
    
    func hide() {
        isShowingAlert = false
    }
}
