import SwiftUI

struct Workout_View: View {
    @State private var selectedDifficulty = "Normal"
    @State var exercises = [
        ("Pushups", false),
        ("Situps", false),
        ("Squats", false),
        ("Curls", false),
        ("Leg raises", false),
        ("Burpees", false)
    ]
    @State private var date = Date.now
    @State private var currentExerciseIndex = 0
    @State private var isTimerRunning = false
    @State private var remainingTime = 60
    @State private var workoutTime = 60
    @State private var showPicker: Bool = false
    @State var reps = 10
    @State private var showExerciseSheet = false

    @Binding var workoutsCompleted: Double
    @Binding var streakDays: Double
    @Binding var streakWeeks: Double

    var body: some View {
        VStack(alignment: .leading) {
            // Date Navigation
            HStack {
                Button(action: {
                    date = date.addingTimeInterval(-86400)
                    reps = max(reps - 1, 1)
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(showPicker ? .gray : .blue)
                }
                Spacer()
                
                Text(date, format: .dateTime.day().month())
                    .font(.title)
                    .bold()
                
                Spacer()
                
                Button(action: {
                    date = date.addingTimeInterval(86400)
                    reps += 1
                }) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(showPicker ? .gray : .blue)
                }
                .disabled(showPicker)
            }
            .padding(.horizontal)
            
            // Difficulty Picker
            Picker(selection: $selectedDifficulty, label: Text("Difficulty")) {
                Text("Recovery").tag("Recovery")
                Text("Normal").tag("Normal")
                Text("Hard").tag("Hard")
            }
            .disabled(showPicker)
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
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
            if currentExerciseIndex < exercises.count {
                VStack {
                    Text("Current Exercise: \(exercises[currentExerciseIndex].0)")
                        .font(.title2)
                        .bold()
                    
                    Button("Start") {
                        showExerciseSheet = true
                    }
                    .padding(30)
                    .frame(maxWidth: .infinity)
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .bold()
                    .font(.title3)
                    .cornerRadius(8)
                }
                .padding()
                .frame(maxWidth: .infinity)
            }
        }
        .padding()
        .navigationTitle("Plan")
        .sheet(isPresented: $showExerciseSheet) {
            ExerciseSheet(
                exercise: exercises[currentExerciseIndex].0,
                remainingTime: $remainingTime,
                isTimerRunning: $isTimerRunning
            )
        }
    }
    
    private func updateRepetitions() {
        withAnimation {
            switch selectedDifficulty {
            case "Recovery":
                reps = max(reps - 5, 1)
            case "Normal":
                reps = 10
            case "Hard":
                reps += 5
            default:
                break
            }
        }
    }
}

struct ExerciseSheet: View {
    var exercise: String
    @Binding var remainingTime: Int
    @Binding var isTimerRunning: Bool
    @State private var timer: Timer? = nil
    
    var body: some View {
        VStack {
            Text("Exercise: \(exercise)")
                .font(.title)
                .bold()
                .padding()
            
            Text("\(remainingTime) seconds")
                .font(.title2)
                .padding()
            
            Button(isTimerRunning ? "Stop" : "Start") {
                if isTimerRunning {
                    stopTimer()
                } else {
                    startTimer()
                }
            }
            .padding()
            .background(isTimerRunning ? Color.red : Color.green)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
    }
    
    private func startTimer() {
        isTimerRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if remainingTime > 0 {
                remainingTime -= 1
            } else {
                stopTimer()
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
