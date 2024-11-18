import SwiftUI

struct Goal_view: View {
    @State private var completedTasks = [true, true, false, false]
    @State private var dailyProgress = 0.333333
    
    
    @State private var exercise = false
    
    
    
    let date = Date.now
    
    let workouts = [
        ("Pushups"),
        ("Situps"),
        ("Squats"),
        ("Curls"),
        ("Leg raises"),
        ("Burpees")
    ]
    @Binding var streakDays: Double
    @Binding var streakWeeks: Double
    @Binding var workoutsCompleted: Double
    
        var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Date and Title
            
            Text("Summary")
                .font(.largeTitle)
                .bold()
            
            Text("Daily Goal")
                .font(.headline)
                .foregroundColor(.gray)
            
            // Progress Circle
            VStack {
                CircularProgressView(progress: (workoutsCompleted/6))
                    .frame(width: 120, height: 120)
            }
            .frame(maxWidth: .infinity)
            
            // Workout Plan
            Text("Workout Plan")
                .font(.headline)
                .padding(.top)
            
            // Workout Tasks
            VStack(spacing: 10) {
                ScrollView{
                    ForEach(0..<workouts.count, id: \.self) { index in
                        HStack {
                            Text(workouts[index])
                            Spacer()
                            if index < Int(workoutsCompleted) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            } else {
                                Image(systemName: "circle")
                                    .foregroundColor(.gray)
                            }
                        }
                        .contentShape(Rectangle())
                    }
                }
            }
            
            // Streak Section
            

                HStack {
                    Text("Streak: \(Int(streakWeeks)) weeks")
                        .font(.headline)
                    
                    Spacer()
                    
                    HStack(spacing: 8) {
                        ForEach(0..<7) { index in
                            Circle()
                                .fill(index < Int(streakDays) ? Color.green : Color.green.opacity(0.3))
                                .frame(width: 24, height: 24)
                        }
                    }
                }
                
                Spacer()
                
                // Bottom Navigation
                
        }.padding()
            
        }
    }
    
    // Custom Circular Progress View
    struct CircularProgressView: View {
        var progress: Double
        
        var body: some View {
            ZStack {
                Circle()
                    .stroke(lineWidth: 15.0)
                    .opacity(0.3)
                    .foregroundColor(.green)
                Circle()
                    .trim(from: 0.0, to: progress)
                    .stroke(style: StrokeStyle(lineWidth: 15.0, lineCap: .round, lineJoin: .round))
                    .foregroundColor(.green)
                    .rotationEffect(Angle(degrees: 270.0))
                Text("\(Int(progress * 100))%")
                    .font(.title)
                    .bold()
            }
        }
    }
    
    // Workout Task View
    struct WorkoutTaskView: View {
        var time: String
        var task: String
        var completed: Bool
        
        var body: some View {
            HStack {
                Image(systemName: completed ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(completed ? .blue : .gray)
                VStack(alignment: .leading) {
                    Text("\(time) - \(task)")
                        .bold()
                    Text("Details")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
        }
    }
    
    //#Preview {
    //    Goal_view()
    //}
//}
