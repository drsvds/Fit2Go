import SwiftUI

struct Workout_View: View {
    @State private var selectedDifficulty = "Normal"
    @State var exercises = [
        ("Pushups", false),
        ("Situps", false),
        ("Squats", false),
        ("Leg raises", false),
        ("Lunges", false),
        ("Burpees", false)
    ]
    @State private var date = Date.now
    @State private var isTimerRunning = false
    @State private var remainingTime = 60
    @State private var workoutTime = 60
    @State private var showPicker: Bool = false
    @State var reps = 10
    @State var todayReps = 10
    @State private var showExerciseSheet = false
    @State var repIncrease = 0
    
    @Binding var workoutsCompleted: Int
    @Binding var streakDays: Double
    @Binding var streakWeeks: Double
    
    var body: some View {
        VStack(alignment: .leading) {
            // Difficulty Picker
            Picker(selection: $selectedDifficulty, label: Text("Difficulty")) {
                Text("Recovery").tag("Recovery")
                Text("Normal").tag("Normal")
                Text("Hard").tag("Hard")
            }
            .disabled(showPicker)
            .pickerStyle(SegmentedPickerStyle())
            .onChange(of: selectedDifficulty) { _ in
                updateRepetitions()
            }
            
            Divider()
            
            // Exercise List with Checkmarks
            VStack(spacing: 10) {
                ForEach(0..<exercises.count, id: \.self) { index in
                    HStack {
                        if exercises[index].1 {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.blue)
                        }
                        
                        Text("\(index + 1). \(exercises[index].0)")
                            .font(.title3)
                            .monospacedDigit()
                        
                        Spacer()
                        
                        Text("\(reps) reps")
                            .contentTransition(.numericText())
                            .font(.title3)
                    }
                    Divider()
                }
            }
            
            Spacer()
            
            // Current Exercise Section
            if workoutsCompleted < exercises.count {
                VStack {
                    Text("Current Exercise: \(exercises[workoutsCompleted].0)")
                        .font(.title2)
                        .bold()
                    
                    Button {
                        showExerciseSheet = true
                    } label: {
                        Text("Start")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .bold()
                            .font(.title3)
                    }
                    .cornerRadius(8)
                }
            }
        }
        .padding()
        .navigationTitle("Today's Plan")
        .sheet(isPresented: $showExerciseSheet) {
            ExerciseSheet(
                exercise: exercises[workoutsCompleted].0,
                isLastItem: workoutsCompleted == exercises.count - 1,
                remainingTime: $remainingTime,
                isTimerRunning: $isTimerRunning) {
                    moveToNextExercise()
                }
        }
        
    }
    
    private func moveToNextExercise() {
        // Mark current exercise as completed
        exercises[workoutsCompleted].1 = true
        
        // Check if there are more exercises
        if workoutsCompleted < exercises.count - 1 {
            // Move to the next exercise
            workoutsCompleted += 1
            remainingTime = 60// Reset timer
        } else {
            // All exercises completed
            finishWorkout()
        }
    }

    private func finishWorkout() {
        // Mark all exercises as completed
        exercises = exercises.map { ($0.0, true) }
        workoutsCompleted += 1
        streakDays += 1
        if streakDays == 8 {
            streakDays = 1
            streakWeeks += 1
        }
        print("Workout Finished!")
//        date = date.addingTimeInterval(86400) // Move to the next day
    }
    
    private func updateRepetitions() {
        withAnimation {
            switch selectedDifficulty {
            case "Recovery":
                reps = max(todayReps - 5, 1) // Decrease reps, ensure minimum is 1
            case "Normal":
                // Default for Normal
                reps = todayReps
            case "Hard":
                reps = todayReps + 5 // Increase reps
            default:
                break
            }
        }
    }
    
}

struct ExerciseSheet: View {
    var exercise: String
    
    var isLastItem = false
    @Binding var remainingTime: Int
    @Binding var isTimerRunning: Bool
    @State private var timer: Timer? = nil
    var onFinish: () -> Void
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Exercise")
                .font(.title3)
                .bold()
                .foregroundStyle(.secondary)
            Text("\(exercise)")
                .font(.largeTitle)
                .bold()
            
            Text("\(remainingTime)s")
                .font(.system(size: 100, weight: .heavy))
                .padding()
                .monospacedDigit()
                .contentTransition(.numericText())
            
            Spacer()
            
            Button {
                if isTimerRunning {
                    stopTimer()
                } else {
                    startTimer()
                }
            } label: {
                Text(isTimerRunning ? "Stop" : "Start")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isTimerRunning ? Color.red : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
    }
    
    private func startTimer() {
        isTimerRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if remainingTime > 0 {
                withAnimation {
                    remainingTime -= 1
                }
            } else {
                stopTimer()
                onFinish() // Call the function to move to the next exercise
                if isLastItem {
                    dismiss()
                }
            }
        }
    }
    
    private func stopTimer() {
        isTimerRunning = false
        timer?.invalidate()
        timer = nil
    }
}

#Preview {
    Workout_View(workoutsCompleted: .constant(0), streakDays: .constant(0), streakWeeks: .constant(0))
}
