//
//  ContentView.swift
//  s10CupcakeCorner
//
//  Created by Mirko Braic on 11.02.2024..
//

import SwiftUI

struct ContentView: View {
    @State private var order = Order()
     
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Selcet your cake type", selection: $order.type) {
                        ForEach(Order.types.indices, id: \.self) {
                            Text(Order.types[$0])
                        }
                    }

                    Stepper("Number of cakes: \(order.quantity)", value: $order.quantity, in: 3...20)
                }

                Section {
                    Toggle("Any special requests?", isOn: $order.specialRequestEnabled)

                    if order.specialRequestEnabled {
                        Toggle("Add extra frosting", isOn: $order.extraFrosting)
                        Toggle("Add extra sprinkles", isOn: $order.addSprinkles)
                    }
                }

                Section {
                    NavigationLink("Delivery details", value: order)
                }
            }
            .animation(.default, value: order.specialRequestEnabled)
            .navigationTitle("Cupcake Corner")
            .navigationDestination(for: Order.self) { order in
                AddressView(order: order)
            }
        }
    }
}

#Preview {
    ContentView()
}
