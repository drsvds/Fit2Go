import SwiftUI

struct Goal_view: View {
    let date = Date.now
    
    let workouts = [
        ("Pushups"),
        ("Situps"),
        ("Squats"),
        ("Curls"),
        ("Leg raises"),
        ("Burpees")
    ]
    
    @State private var workoutHistory: [Workout] = []
    
    @Binding var streakDays: Double
    @Binding var streakWeeks: Double
    @Binding var workoutsCompleted: Int
    
    
    var body: some View {
        ScrollView {
            // Progress Circle
            CircularProgressView(progress: Double(workoutsCompleted) / 6)
                .frame(width: 180, height: 180)
                .padding(.vertical)
            
            VStack {
                ForEach(0..<workouts.count, id: \.self) { index in
                    
                    Divider()
                    
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
                    .font(.title2)
                    .padding(.vertical, 6)
                }
                Divider()
                
                Spacer()
                StreakView(streakWeeks: $streakWeeks, streakDays: $streakDays)
                
                
            }
           
        }
        .padding(.horizontal)
        .navigationTitle("Home")
    }
}

struct StreakView: View {
    
    @Binding var streakWeeks: Double
    @Binding var streakDays: Double
    
    var body: some View {
        // Streak Section
        VStack {
            Text("Streak: \(Int(streakWeeks)) weeks")
                .font(.headline)
            
            Spacer()
            
            HStack() {
                
                ForEach(0..<7) { index in
                    Circle()
                        .fill(index < Int(streakDays) ? Color.green : Color.green.opacity(0.3))
                        .frame(width: 24, height: 24)
                }
                .padding(.horizontal, 6)
            }
            
           
        }
        Spacer()
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
                .font(.largeTitle)
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



#Preview {
    ContentView()
}
