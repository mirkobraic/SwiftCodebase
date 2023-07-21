//
//  ContentView.swift
//  s04BetterRest
//
//  Created by Mirko Braic on 20.07.2023..
//

import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1

    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }

    var idealBedtime: String {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)

            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60

            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))

            let sleepTime = wakeUp - prediction.actualSleep
            return sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
            return ""
        }
    }

    var body: some View {
        NavigationView {
            Form {
                VStack(alignment: .leading, spacing: 10) {
                    Text("When do you want to wake up?")
                        .font(.headline)
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }

                VStack(alignment: .leading, spacing: 0) {
                    Text("Desired amount of sleep")
                        .font(.headline)
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                        .padding()
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("Daily coffe intake")
                        .font(.headline)
                    Picker(coffeeAmount == 1 ? "1 cup" : "\(coffeeAmount) cups", selection: $coffeeAmount) {
                        ForEach(1...25, id: \.self) {
                            Text("\($0)")
                        }
                    }
                }

                Section {
                    HStack {
                        Text("Ideal bedtime:")
                            .font(.headline)
                        Spacer()
                        Text(idealBedtime)
                    }
                }
            }
            .navigationTitle("Better rest")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
