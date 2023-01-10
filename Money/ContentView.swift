//
//  ContentView.swift
//  Money
//
//  Created by Tuan Si Ho (3406) on 25/12/2022.
//

import SwiftUI

struct ContentView: View {
    @StateObject var homeRouter = HomeRouter()
    @StateObject var alertManager = AlertManager()
    var body: some View {
        NavigationView {
            HomeView()
                .environmentObject(homeRouter)
                .environmentObject(alertManager)
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
