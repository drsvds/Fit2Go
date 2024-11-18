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
    @AppStorage("hasOpenedAppBefore") var hasOpenedAppBefore : Bool = false
//    @State var hasOpenedAppBefore = false
    var body: some View {
        if hasOpenedAppBefore {
            TabView {
                NavigationView {
                    Goal_view(streakDays: $streakDays , streakWeeks: $streakWeeks,  workoutsCompleted: $workoutsCompleted)
                }
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                
                NavigationView {
                    Workout_View(workoutsCompleted: $workoutsCompleted, streakDays: $streakDays, streakWeeks: $streakWeeks)
                        .tabItem {
                            Label("Workout", systemImage: "figure.mixed.cardio")
                        }
        } else {
            FirstLaunchView(hasOpenedAppBefore: $hasOpenedAppBefore)
        }
    }
}
#Preview {
    ContentView()
}
