//
//  DetailView.swift
//  Money
//
//  Created by Tuan Si Ho (3406) on 10/01/2023.
//

import Foundation
import SwiftUI
import Combine

struct DetailView: View {
    var item: DebtItem
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var router: HomeRouter
    @State var isShowingEdit: Bool = false
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView {
                VStack(alignment: .leading) {
                    HStack(spacing: 0) {
                        Text("\(item.person)")
                            .font(.title2)
                            .bold()
                            .padding(.vertical, 12)
                        Spacer()
                        statusView(status: item.payStatus())
                            .padding(.horizontal, 6)
                        debtTypeView(type: item.debtType())
                    }
                    Text("\(item.amount.toCurrenctString())")
                        .font(.title2)
                    Text("Borrow date: \(item.borrowDate.toString())")
                        .font(.callout)
                    Text("Expect date: \(item.expectDate?.toString() ?? "---")")
                        .font(.callout)
                    Text("Expect amount: \(item.expectAmount.toCurrenctString())")
                        .font(.callout)
                    Text("Return amount: \(item.paidAmount.toCurrenctString())")
                        .font(.callout)
                    Text("Remain amount: \(item.remainAmount.toCurrenctString())")
                        .font(.callout)
                    Text("Note:\n\(item.note ?? "---")")
                        .multilineTextAlignment(.leading)
                        .padding(.vertical, 12)
                    Spacer()
                }
                .padding(.horizontal, 24)
            }
            .frame(width: UIScreen.main.bounds.width)
            buttonEdit
        }
        .toolbar {
            Button {
                isShowingEdit = true
            } label: {
                Text("Edit")
            }

        }
        .navigationTitle("Detail")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isShowingEdit, content: {
            AddDebtView(type: .edit, item: item)
                .environmentObject(AlertManager())
                //.environmentObject(router)
        })
        .onReceive(router.$needUpdateList) { value in
            if value {
                dismiss()
            }
        }

    }
    
    var buttonEdit: some View {
        VStack {
            Divider()
            Button {
                isShowingEdit = true
            } label: {
                Text("Edit")
                    .font(.system(size: 18))
                    .frame(width: 240, height: 56, alignment: .center)
                    .foregroundColor(Color.white)
                    .background(Color.accentColor)
                    .cornerRadius(12)
                    .padding(12)
            }
            .buttonStyle(BorderlessButtonStyle())
        }
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
    
    func debtTypeView(type: DebtType) -> some View {
        Text(type.title)
            .font(.callout)
            .bold()
            .padding(4)
            .padding(.horizontal, 4)
            .background(type.color)
            .cornerRadius(10)
    }
}
