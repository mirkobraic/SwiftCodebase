//
//  ContentView.swift
//  s07iExpense
//
//  Created by Mirko Braic on 24.07.2023..
//

import SwiftUI

struct ContentView: View {
    @StateObject var expenses = Expenses()
    @State private var showingAddExpense = false

    private var sections = ["Personal", "Business"]

    var body: some View {
        NavigationView {
            List {
                ForEach(sections, id: \.self) { section in
                    Section(section) {
                        ForEach(expenses.items) { item in
                            if item.type == section {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(item.name)
                                            .font(.headline)
                                        Text(item.type)
                                    }

                                    Spacer()
                                    Text(item.amount, format: .currency(code: "USD"))
                                }
                            }
                        }
                        .onDelete(perform: removeItems(at:))
                    }
                }
            }
            .navigationTitle("iExpense")
            .toolbar {
                Button {
                    showingAddExpense = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                AddView(expenses: expenses)
            }
        }
    }

    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
