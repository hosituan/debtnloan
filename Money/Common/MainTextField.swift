//
//  MainTextField.swift
//  Money
//
//  Created by Tuan Si Ho (3406) on 09/01/2023.
//

import Foundation
import SwiftUI

struct DateInputField: View {
    var title: String?
    @Binding var date: Date
    @State private var pickerId: UUID = UUID()
    var body: some View {
            DatePicker(selection: $date.onUpdate {
                
            }, displayedComponents: .date) {
                Text(title ?? "")
            }
            .id(pickerId)
            .padding(.horizontal, 24)
            .padding(.vertical, 6)
    }
}

struct NumberTextField: View {
    var title: String?
    var placeholder: String?
    var keyboardType: UIKeyboardType = .decimalPad
    @Binding var value: Double
    let formatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.groupingSeparator = ","
        numberFormatter.groupingSize = 3
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.decimalSeparator = "."
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 0
        return numberFormatter
    }()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title ?? "")
                .multilineTextAlignment(.leading)
                .padding(.bottom, 10)
            TextField(placeholder ?? "", value: $value, format: .currency(code: "VND"))
                .keyboardType(keyboardType)
                .frame(width: nil, height: 56, alignment: .leading)
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 6))
                .cornerRadius(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
            
        }
        .padding(.horizontal, 24)
        
    }
}

struct MainTextField: View {
    var title = ""
    var placeholder = ""
    var keyboardType: UIKeyboardType = .default
    @Binding var value: String
    @State var textValue: String = ""
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .multilineTextAlignment(.leading)
                .padding(.bottom, 10)
            TextField(placeholder, text: $value)
            .keyboardType(keyboardType)
            .frame(width: nil, height: 56, alignment: .leading)
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 6))
            .cornerRadius(5)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
            )
            
        }
        .padding(.horizontal, 24)
        
    }
}
