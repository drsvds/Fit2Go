//
//  ContentView.swift
//  Placeholder app
//
//  Created by T Krobot on 11/11/24.
//

import SwiftUI

struct ContentView: View {
    @State var workoutsCompleted: Double = 0
    @State var streakDays:Double = 0
    @State var streakWeeks:Double = 0
    var body: some View {
        TabView {
            Goal_view(streakDays: $workoutsCompleted, streakWeeks: $streakDays, workoutsCompleted: $streakWeeks)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            Workout_View(workoutsCompleted: $workoutsCompleted, streakDays: $streakDays, streakWeeks: $streakWeeks)
                .tabItem {
                    Label("Workout", systemImage: "figure.mixed.cardio")
                }
           
        }
    }
}

#Preview {
    ContentView()
}
