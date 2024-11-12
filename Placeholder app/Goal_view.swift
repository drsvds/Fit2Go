//
//  Goal view.swift
//  Placeholder app
//
//  Created by T Krobot on 11/11/24.
//

import SwiftUI

struct Goal_view: View {
    let date = Date.now
    @State private var goalCompletionPercentage = 60
    
    let workouts = ["test", "testing"]
    
    var body: some View {
        
        NavigationStack{
            VStack{
                ZStack {
                    Circle()
                        .stroke(lineWidth: 10)
                        .foregroundColor(Color.gray.opacity(0.2))
                    
                    Circle()
                        .trim(from: 0.0, to: CGFloat(goalCompletionPercentage) / 100.0)
                        .stroke(
                            AngularGradient(
                                gradient: Gradient(colors: [Color.green, Color.blue]),
                                center: .center
                            ),
                            lineWidth: 10
                        )
                        .rotationEffect(.degrees(-90)) // Rotate the circle by -90 degrees to start at the top
                        .animation(.easeInOut(duration: 1), value: goalCompletionPercentage) // Trigger animation on value change
                    
                    Text("\(Int(goalCompletionPercentage))%")
                        .font(.title)
                        .fontWeight(.bold)
                }
                .frame(width: 150, height: 150)
                
                ScrollView{
                    ForEach(workouts, id: \.self) { workout in
                        Text(workout)
                    }
                        
                }
            }
            .navigationTitle(Text(date, style: .date))
        }
        
        }
    }


#Preview {
    Goal_view()
}
