//
//  ContentView.swift
//  Placeholder app
//
//  Created by T Krobot on 11/11/24.
//

import SwiftUI

struct ContentView: View {
    @State var workoutsCompleted: Int = 0
    
    
    var body: some View {
        TabView {
            Goal_view(workoutsCompleted: $workoutsCompleted)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            Workout_View(workoutsCompleted: $workoutsCompleted)
                .tabItem {
                    Label("Workout", systemImage: "figure.mixed.cardio")
                }
           
        }
    }
}

#Preview {
    ContentView()
}
