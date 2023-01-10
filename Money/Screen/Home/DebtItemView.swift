//
//  DebtItemView.swift
//  Money
//
//  Created by Tuan Si Ho (3406) on 10/01/2023.
//

import Foundation
import SwiftUI

struct DebtItemView: View {
    var index: Int
    var item: DebtItem
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text("\(index + 1). \(item.person)")
                        .font(.title2)
                        .bold()
                    Spacer()
                }

                
                Text("Amount: \(item.amount.toCurrenctString())")
                    .font(.title2)
                Text("Issue date: \(item.borrowDate.toString())")
                    .font(.callout)
                Text("Expect date: \(item.expectDate?.toString() ?? "---")")
                    .font(.callout)
                HStack(alignment: .center) {
                    statusView(status: item.payStatus())
                        .padding(.top, 10)
                    if let paidDate = item.paidDate, item.payStatus() == .paid {
                        Text("Finish date: \(paidDate.toString())")
                            .font(.callout)
                    }
                }
                
            }
            debtTypeView(type: item.debtType())
        }
    }
    
    func debtTypeView(type: DebtType) -> some View {
        Text(type.title)
            .font(.callout)
            .bold()
            .padding(4)
            .padding(.horizontal, 4)
            .background(type.color)
            .cornerRadius(10)
    }
    func statusView(status: PayStatus) -> some View {
        Text(status.title)
            .font(.callout)
            .bold()
            .padding(4)
            .padding(.horizontal, 4)
            .background(status.color)
            .cornerRadius(10)
    }
}
