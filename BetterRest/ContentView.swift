//
//  ContentView.swift
//  BetterRest
//
//  Created by Kenneth Oliver Rathbun on 2/22/24.
//

import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 7.5
    @State private var coffeeAmount = 1
    
    // Alert displaying the time the user should go to sleep
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    var recommendedBedtime: String {
        let sleepTime = calculateBedtime()
        return sleepTime.formatted(date: .omitted, time: .shortened)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("⏰ When do you want to wake up?") {
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                
                Section("⏳ Desired Amount of Sleep") {
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.5)
                }
                
                Section("☕️ Daily Coffee Intake") {
                    Stepper("^[\(coffeeAmount) cup](inflect: true)", value: $coffeeAmount, in: 1...20, step: 1)
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("Your bedtime is...")
                        .fontWeight(.semibold)
                    Text("\(recommendedBedtime) 🌙")
                        .font(.largeTitle)
                }
            }
            .navigationTitle("Better Rest 😴")
        }
    }
    
    func calculateBedtime() -> Date {
        var sleepTime = Date.now
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            // Get date components for the wake up time and convert them to seconds
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            // Feed values into CoreML and see what comes out
            let prediction = try model.prediction(wake: Int64(hour + minute), estimatedSleep: sleepAmount, coffee: Int64(coffeeAmount))
            
            // Sleep time is the wake up time minus the amount of time required to sleep
            sleepTime = wakeUp - prediction.actualSleep
            
        }
        catch {
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating your bedtime."
        }
        
        return sleepTime
    }
}

#Preview {
    ContentView()
}
