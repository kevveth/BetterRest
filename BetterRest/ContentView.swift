//
//  ContentView.swift
//  BetterRest
//
//  Created by Kenneth Oliver Rathbun on 2/22/24.
//

import SwiftUI

struct ContentView: View {
    @State private var sleepAmount = 6.0
    @State private var wakeUp = Date.now
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, step: 0.25)
            DatePicker("Please pick a date", selection: $wakeUp, in: Date.now...)
                .labelsHidden()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
