//
//  AddDebtView.swift
//  Money
//
//  Created by Tuan Si Ho (3406) on 29/12/2022.
//

import Foundation
import SwiftUI
import RealmSwift
import Combine

struct AddDebtView: View {
    enum ViewType {
        case add
        case edit
        var title: String {
            switch self {
            case .add: return "Add new data"
            case .edit: return "Edit"
            }
        }
    }
    
    var type: ViewType = .add
    var item: DebtItem = DebtItem()
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var router: HomeRouter
    @EnvironmentObject var alertManager: AlertManager
    @StateObject var state = AddDebtState()
    
    var body: some View {
        NavigationView {
            content
                .navigationTitle(type.title)
                .navigationBarTitleDisplayMode(.inline)
                .addDoneToolBar()
        }
        .hideKeyboardWhenTapAround()
    }
    
    var content: some View {
        VStack(alignment: .leading, spacing: 16) {
            ScrollView {
                HStack {
                    Text("Type")
                    Spacer()
                    Picker("", selection: $state.pickerTypeIndex) {
                        ForEach(0..<DebtType.allCases.count, id: \.self) {
                            Text(DebtType.allCases[$0].title)
                                .tag(UUID())
                                .foregroundColor(.white)
                                .background(DebtType.allCases[$0].color)
                        }
                    }
                }
                .padding(.horizontal, 24)
                if type == .edit {
                    Divider()
                        .padding(.top, 24)
                    DateInputField(title: "Return Date:", date: $state.returnDate.toUnwrapped(defaultValue: Date()))
                    NumberTextField(title: "Return Amount", placeholder: "...", keyboardType: .decimalPad, value: $state.returnAmount)
                    HStack {
                        Text("Status")
                        Spacer()
                        Picker("", selection: $state.pickerSelectedIndex) {
                            ForEach(0..<PayStatus.allCases.count, id: \.self) {
                                Text(PayStatus.allCases[$0].title)
                                    .tag(UUID())
                                    .foregroundColor(.white)
                                    .background(PayStatus.allCases[$0].color)
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    Divider()
                }
                
                MainTextField(title: "Name", placeholder: "...", value: $state.person)
                NumberTextField(title: "Amount", placeholder: "...", keyboardType: .decimalPad, value: $state.amount)
                DateInputField(title: "Issue Date:", date: $state.issueDate)
                DateInputField(title: "Expect Date:", date: $state.expectDate.toUnwrapped(defaultValue: Date()))
                NumberTextField(title: "Expect Amount", placeholder: "...", keyboardType: .decimalPad, value: $state.expectAmount)
                noteView
                    .padding(.bottom, 24)
            }
            buttonDone
        }
        .hasAlert(alertManager)
        .keyboardAdaptive()
        .onAppear {
            self.state.item = self.item
            self.state.type = self.type
            self.state.subscribe()
        }
        .onDisappear {
            self.state.unsubsribe()
            //self.router.needUpdateList = true
        }
        .toolbar {
            Button {
                dismiss()
            } label: {
                Text("Done")
            }

        }
    }
    
    var noteView: some View {
        VStack {
            HStack {
                Text("Note")
                    .padding(.horizontal, 24)
                Spacer()
            }
            
            TextEditor(text: $state.note)
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 6))
                .cornerRadius(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
                .frame(minHeight: 56)
                .padding(.horizontal, 24)
        }
    }
    var buttonDone: some View {
        HStack(alignment: .center) {
            Button {
                if type == .add {
                    addNewData()
                } else {
                    dismiss()
                }
            } label: {
                Text("Done")
                    .font(.system(size: 18))
                    .frame(width: 240, height: 56, alignment: .center)
                    .foregroundColor(Color.white)
                    .background(Color.accentColor)
                    .cornerRadius(12)
                    .padding(12)
            }
            .disabled(state.buttonDisable)
            .buttonStyle(BorderlessButtonStyle())
        }.frame(width: UIScreen.main.bounds.width)
    }
    
    func addNewData() {
        guard !item.person.isEmpty,
              item.amount > 0
        else {
            alertManager.show(title: "Error", message: "Please input valid data")
            return
        }
        DataManager.shared.saveLoan(item: self.item)
        dismiss()
    }
}
