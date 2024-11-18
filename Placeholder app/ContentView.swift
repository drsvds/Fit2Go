//
//  ContentView.swift
//  Placeholder app
//
//  Created by T Krobot on 11/11/24.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("workoutsCompleted") var workoutsCompleted = 0
    @AppStorage("lastLoginDate") var lastLoginDate = Date.distantPast
    
    @State var streakDays:Double = 0
    @State var streakWeeks:Double = 0
    @AppStorage("hasOpenedAppBefore") var hasOpenedAppBefore : Bool = false
//    @State var hasOpenedAppBefore = false
    var body: some View {
        Group {
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
                    }
                    .tabItem {
                        Label("Workout", systemImage: "figure.mixed.cardio")
                    }
                }
            } else {
                FirstLaunchView(hasOpenedAppBefore: $hasOpenedAppBefore)
            }
        }
        .onAppear {
            if !Calendar.current.isDateInToday(lastLoginDate) {
                workoutsCompleted = 0
            }
            
            lastLoginDate = .now
        }
    }
}
#Preview {
    ContentView()
}
