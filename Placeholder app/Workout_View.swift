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
    @State private var showPicker : Bool = false
    @State var reps = 10
    
    @Binding var workoutsCompleted: Double
    @Binding var streakDays: Double
    @Binding var streakWeeks: Double
//    func moveDate() {
//        VStack {
//            ForEach(0..<exercises.count, id: \.self) { index in
//                HStack {
//                    if exercises[index].1 { // Check if completed
//                        Image(systemName: "checkmark.circle.fill") // Show checkmark if completed
//                            .foregroundColor(.blue)
//                    }
//                    
//                    Text("\(index + 1). \(exercises[index].0)")
//                        .font(.body)
//                        .strikethrough(exercises[index].1) // Strike through if completed
//                    
//                    Spacer()
//                    
//                    Text("\(reps) reps")
//                        .contentTransition(.numericText())
//                        .font(.body)
//                }
//                Divider()
//            }
//        }
//    }
    var body: some View {
        VStack(alignment: .leading) {
            // Date Navigation
            HStack {
                Button(action: {
                    // Handle previous date action
                    date = date.addingTimeInterval(-86400)
                    reps -= 1
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(showPicker ? .gray : .blue)
                }
                .disabled(showPicker)
                
                Spacer()
                
                Text(date, format: .dateTime.day().month())
                    .font(.title)
                    .bold()
                
                Spacer()
                
                Button(action: {
                    // Handle next date action
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
            .animation(.default, value: 2)
            
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
                            .font(.body)
                        
                        Spacer()
                        
                        Text("\(reps) reps")
                            .contentTransition(.numericText())
                            .font(.body)
                        
                    }
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
                        .font(.headline)
                    
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
                            Button("Next") {
                                workoutsCompleted += 1
                                moveToNextExercise() // Move to next exercise and mark the current one as completed
                            }
                            .padding(30)
                            .background(Color.yellow)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        } else {
                            Button("Finish") {
                                finishWorkout()
                                workoutsCompleted += 1
                                currentExerciseIndex += 1
                                streakDays += 1
                                if(streakDays == 8){
                                    streakDays = 1
                                    streakWeeks += 1
                                }
                            }
                            .padding(30)
                            .background(Color.red)
                            .foregroundColor(.white)
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
    
    // Function to start the timer
    private func startTimer() {
        isTimerRunning = true
        remainingTime = 60
        // Create and start the timer
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if remainingTime > 0 {
                remainingTime -= 1
            } else {
                timer?.invalidate()
            }
        }
    }
    
    // Function to move to the next exercise
    private func moveToNextExercise() {
        // Mark the current exercise as completed
        exercises[currentExerciseIndex].1 = true
        
        // Move to the next exercise
        currentExerciseIndex += 1
        remainingTime = 60 // Reset the timer for the next exercise
        isTimerRunning = false
    }
    
    // Function to finish the workout and mark all exercises as completed
    private func finishWorkout() {
        // Mark all exercises as completed when finishing the workout
        exercises = exercises.map { ($0.0, true) } // Set all exercises to completed
        print("Workout Finished!")
        date = date.addingTimeInterval(86400)
    }
}

#Preview {
//    Workout_View(workoutsCompleted: .constant(0))
    ContentView()
}
