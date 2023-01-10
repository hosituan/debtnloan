//
//  View+.swift
//  Money
//
//  Created by Tuan Si Ho (3406) on 09/01/2023.
//

import Foundation
import SwiftUI
import UIKit

extension View {
    func hideKeyboardWhenTapAround() -> some View {
        self.onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
    
    func hasAlert(_ manager: AlertManager) -> some View {
        let alertBinding = Binding(
            get: {
                manager.isShowingAlert
            },
            set: {
                manager.isShowingAlert = $0
            }
        )
        return self.alert(manager.alertTitle ?? "", isPresented: alertBinding, actions: {
            Button {
                manager.primaryAction?()
            } label: {
                Text("OK")
            }
        }, message: {
            Text(manager.alertMessage ?? "")
        })
    }
    
    func addDoneToolBar() -> some View {
        self.toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button {
                    UIApplication.shared.endEditing()
                } label: {
                    Text("Done")
                }
                
            }
        }
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension Double {
    func toString() -> String {
        return String(self)
    }
    
    func toInt() -> Int {
        return Int(self)
    }
    
    func toCurrenctString(decimal: Int = 0) -> String {
        return self.grouped(decimal: decimal) + " VND"
    }
    
    func grouped(decimal: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.groupingSeparator = ","
        numberFormatter.groupingSize = 3
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.decimalSeparator = "."
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = decimal
        return numberFormatter.string(from: self as NSNumber) ?? "0"
    }
}

extension String {
    func toDoubleFromCurrency() -> Double {
        let value = self.replacingOccurrences(of: ",", with: "").replacingOccurrences(of: "VND", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        return Double(value) ?? 0
    }
}

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY"
        return dateFormatter.string(from: self)
    }
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
    
    static func -(recent: Date, previous: Date) -> (month: Int?, day: Int?, hour: Int?, minute: Int?, second: Int?) {
            let day = Calendar.current.dateComponents([.day], from: previous, to: recent).day
            let month = Calendar.current.dateComponents([.month], from: previous, to: recent).month
            let hour = Calendar.current.dateComponents([.hour], from: previous, to: recent).hour
            let minute = Calendar.current.dateComponents([.minute], from: previous, to: recent).minute
            let second = Calendar.current.dateComponents([.second], from: previous, to: recent).second

            return (month: month, day: day, hour: hour, minute: minute, second: second)
        }
}
