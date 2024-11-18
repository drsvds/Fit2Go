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
    @State private var timer: Timer? = nil
    @State private var workoutTime = 60
    @State private var showPicker: Bool = false
    @State var reps = 10
    
    @Binding var workoutsCompleted: Double
    @Binding var streakDays: Double
    @Binding var streakWeeks: Double

    var body: some View {
        VStack(alignment: .leading) {
            // Date Navigation
            HStack {
                if reps > 10 {
                    Button(action: {
                        // Handle previous date action
                        date = date.addingTimeInterval(-86400)
                        
                        reps -= 1
                        
                        
                        
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(showPicker ? .gray : .blue)
                    }
                    .disabled(showPicker)
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
                        if exercises[index].1 { // Check if completed
                            Image(systemName: "checkmark.circle.fill") // Show checkmark if completed
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
                    
                    Text("Time Remaining: \(remainingTime) seconds")
                        .font(.title3)
                    
                    if !isTimerRunning {
                        Button("Start") {
                            startTimer()
                            if !(1...6).contains(Int(workoutsCompleted)) {
                                showPicker.toggle()
                            }
                        }
                        .padding(30)
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor)
                        .foregroundColor(.primary)
                        .bold()
                        .font(.title3)
                        .cornerRadius(8)
                    }
                    
                    if remainingTime == 0 {
                        if currentExerciseIndex < exercises.count - 1 {
                            Button{
                                workoutsCompleted += 1
                                moveToNextExercise() // Move to next exercise and mark the current one as completed
                            } label: {
                                Text("Next")
                                .padding(30)
                                .frame(maxWidth: .infinity)
                                .background(Color.green)
                                .foregroundColor(.primary)
                                .bold()
                                .font(.title3)
                                .cornerRadius(8)
                            }
                            
                        } else {
                            Button("Finish") {
                                finishWorkout()
                                workoutsCompleted += 1
                                currentExerciseIndex += 1
                                streakDays += 1
                                showPicker.toggle()
                                if(streakDays == 8){
                                    streakDays = 1
                                    streakWeeks += 1
                                }
                                
                            }
                            .padding(30)
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .foregroundColor(.primary)
                            .bold()
                            .font(.title3)
                            .cornerRadius(8)
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
            }
        }
        .padding()
        .navigationTitle("Plan")
    }
    
    // Function to update repetitions based on difficulty
    private func updateRepetitions() {
            withAnimation {
                switch selectedDifficulty {
                case "Recovery":
                    reps = max(reps - 5, 1) // Decrease reps, ensure minimum is 1
                case "Normal":
                    reps = 10 // Default for Normal
                case "Hard":
                    reps += 5 // Increase reps
                default:
                    break
                }
            }
        }
    }
    
    // Function to start the timer
    private func startTimer() {
        isTimerRunning = true
        remainingTime = 60
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if remainingTime > 0 {
                remainingTime -= 1
            } else {
                timer?.invalidate()
                isTimerRunning = false
            }
        }
    }
    
    // Function to move to the next exercise
    private func moveToNextExercise() {
        exercises[currentExerciseIndex].1 = true // Mark current exercise as completed
        currentExerciseIndex += 1
        remainingTime = 60 // Reset timer
        isTimerRunning = false
    }
    
    // Function to finish the workout and mark all exercises as completed
    private func finishWorkout() {
        exercises = exercises.map { ($0.0, true) } // Mark all exercises as completed
        print("Workout Finished!")
        date = date.addingTimeInterval(86400) // Move to the next day
    }
}

#Preview {
    Workout_View(workoutsCompleted: .constant(0), streakDays: .constant(0), streakWeeks: .constant(0))
}
