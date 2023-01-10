//
//  HomeView.swift
//  Money
//
//  Created by Tuan Si Ho (3406) on 25/12/2022.
//

import SwiftUI
import RealmSwift
import Combine
import SwiftUI

struct HomeView: View {
    @StateObject var state = HomeState()
    @EnvironmentObject var router: HomeRouter
    var body: some View {
        VStack {
            List {
                ForEach(state.debts.indices, id: \.self) { index in
                    NavigationLink {
                        DetailView(item: state.debts[index])
                            .environmentObject(AlertManager())
                            .environmentObject(router)
                    } label: {
                        DebtItemView(index: index, item: state.debts[index])
                    }

                    
                }
            }
            Button {
                router.isShowingAddDebt.toggle()
            } label: {
                Text("Add new data")
                    .bold()
                    .frame(width: 240, height: 56, alignment: .center)
                    .foregroundColor(Color.white)
                    .background(Color.accentColor)
                    .cornerRadius(12)
                    .padding(12)
            }
        }
        .refreshable {
            state.debts = DataManager.shared.loadDebt()
        }
        .sheet(isPresented: $router.isShowingAddDebt, content: {
            AddDebtView(type: .add)
        })
        .navigationTitle("Debts")
        .toolbar {
            Button { } label: {
                Text("Total \(state.total)")
            }

        }
        .onAppear {
            state.debts = DataManager.shared.loadDebt()
            state.subscribe()
        }
        .onDisappear {
            state.unsubsribe()
        }
        .onReceive(router.$needUpdateList) { value in
            if value {
                state.debts = DataManager.shared.loadDebt()
            }
        }
    }
}
