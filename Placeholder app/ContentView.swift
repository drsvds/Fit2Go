//
//  ContentView.swift
//  Placeholder app
//
//  Created by T Krobot on 11/11/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Goal_view()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            Workout_View(workoutsCompleted: .constant(0))
                .tabItem {
                    Label("Workout", systemImage: "figure.mixed.cardio")
                }
           
        }
    }
}

#Preview {
    ContentView()
}
