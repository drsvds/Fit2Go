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
                    Label("Goals", systemImage: "house.fill")
                }
            Workout_View()
                .tabItem {
                    Label("Goals", systemImage: "figure.mixed.cardio")
                }
            
            
            
        }
    }
}

#Preview {
    ContentView()
}
