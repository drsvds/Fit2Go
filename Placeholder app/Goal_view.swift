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
    @Binding var workoutsCompleted: Double
    
    var body: some View {
        ScrollView {
            // Progress Circle
            CircularProgressView(progress: (workoutsCompleted/6))
                .frame(width: 120, height: 120)
                .padding(.vertical)
            
            // Workout Tasks
            Text("Workout Plan")
                .font(.title3)
                .bold()
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
            }
            
            Divider()
            
            Text("Workout Log")
                .bold()
                .font(.title3)
            WorkoutHistory(workoutHistory: $workoutHistory)
        }
        .padding(.horizontal)
        .navigationTitle("Summary")
    }
}

struct StreakView: View {
    
    @Binding var streakWeeks: Double
    @Binding var streakDays: Double
    
    var body: some View {
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

struct WorkoutHistory: View {
    
    @Binding var workoutHistory: [Workout]
    
    var body: some View {
        if workoutHistory.isEmpty {
            Text("No progress data available.")
                .padding()
        } else {
            ForEach(workoutHistory.reversed()) { workout in
                VStack(alignment: .leading) {
                    Text("Activity: \(workout.activity)")
                        .font(.headline)
                    Text("Duration: \(workout.duration) min")
                    Text("Intensity: \(workout.intensity) / 10")
                    Text("Date: \(workout.date, formatter: dateFormatter)")
                }
            }
        }
    }
}
    
#Preview {
    ContentView()
}
