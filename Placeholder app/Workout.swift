//
//  Workout.swift
//  Placeholder app
//
//  Created by Regan on 16/11/24.
//

import SwiftUI

// Workout Model
struct Workout: Identifiable {
    var id: UUID
    var date: Date
    var activity: String
    var duration: Int // Duration in minutes
    var intensity: Int // Intensity from 1 to 10
    var completed: Bool
}

//struct ContentView: View {
//    @AppStorage("isQuestionnaireCompleted") var isQuestionnaireCompleted = false
//    @State private var selectedDuration: String? = nil
//    @State private var selectedExercise: String? = nil
//    @State private var workoutHistory: [Workout] = []
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                if isQuestionnaireCompleted {
//                    HomePageView(
//                        workoutHistory: $workoutHistory,
//                        selectedDuration: selectedDuration,
//                        selectedExercise: selectedExercise
//                    )
//                } else {
//                    QuestionnaireView(
//                        isQuestionnaireCompleted: $isQuestionnaireCompleted,
//                        selectedDuration: $selectedDuration,
//                        selectedExercise: $selectedExercise
//                    )
//                }
//            }
//            .navigationTitle("Fitness Tracker")
//            .navigationBarHidden(true)
//        }
//    }
//}

// Questionnaire View to collect user preferences
struct QuestionnaireView: View {
    @Binding var isQuestionnaireCompleted: Bool
    @Binding var selectedDuration: String?
    @Binding var selectedExercise: String?

    let durations = ["15min/day", "30min/day", "45min/day", "60min/day"]
    let exercises = ["Gym", "Sports", "Calisthenics"]

    var body: some View {
        VStack(spacing: 20) {
            Text("How long do you exercise daily?")
                .font(.title)
                .fontWeight(.bold)
                .padding()

            ForEach(durations, id: \.self) { duration in
                Button(action: {
                    selectedDuration = duration
                }) {
                    Text(duration)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
            }

            if selectedDuration != nil {
                Text("What type of exercise do you prefer?")
                    .font(.title2)
                    .padding()

                ForEach(exercises, id: \.self) { exercise in
                    Button(action: {
                        selectedExercise = exercise
                        isQuestionnaireCompleted = true
                    }) {
                        Text(exercise)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                }
            }
        }
        .padding()
    }
}

// Home Page View with Activity Circle and Progress Graph
struct HomePageView: View {
    @Binding var workoutHistory: [Workout]
    var selectedDuration: String?
    var selectedExercise: String?

    @State private var showWorkoutPage = false

    var body: some View {
        VStack {
            Text("Welcome to Your Fitness Tracker")
                .font(.title)
                .fontWeight(.bold)
                .padding()

            // Circle showing percentage of goals completed
            ActivityCircleView(workoutHistory: workoutHistory)

            // Progress Line Graph
            ProgressLineGraph(workoutHistory: workoutHistory)

            Spacer()

            // Add New Activity Button
            Button(action: {
                showWorkoutPage.toggle()
            }) {
                Text("Add New Activity")
                    .font(.title2)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.cyan, Color.blue]), startPoint: .top, endPoint: .bottom))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .shadow(radius: 10)
                    .padding(.horizontal)
            }
            .sheet(isPresented: $showWorkoutPage) {
                Spacer()
                WorkoutPageView(
                    workoutHistory: $workoutHistory,
                    selectedDuration: selectedDuration,
                    selectedExercise: selectedExercise
                )
                .presentationDetents([.medium])
            }
            

            // View Roadmap Button
            NavigationLink(destination: RoadmapPageView(workoutHistory: workoutHistory)) {
                Text("View Progress Roadmap")
                    .font(.title2)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.orange, Color.red]), startPoint: .top, endPoint: .bottom))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .shadow(radius: 10)
                    .padding(.horizontal)
            }
        }
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: [Color.purple.opacity(0.1), Color.blue.opacity(0.1)]), startPoint: .top, endPoint: .bottom))
        .cornerRadius(15)
        .padding()
    }
}

// Activity Circle View showing completion percentage
struct ActivityCircleView: View {
    var workoutHistory: [Workout]

    var body: some View {
        let totalWorkouts = workoutHistory.count
        let completedWorkouts = workoutHistory.filter { $0.completed }.count
        let goalCompletionPercentage = totalWorkouts == 0 ? 0.0 : Double(completedWorkouts) / Double(totalWorkouts) * 100
        
        return VStack {
            Text("Goal Completion")
                .font(.title2)
                .padding(.bottom, 5)
            
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
        }
    }
}

// Progress Line Graph displaying intensity over time
struct ProgressLineGraph: View {
    var workoutHistory: [Workout]
    
    var body: some View {
        let workouts = workoutHistory.sorted { $0.date < $1.date }
        
        if workouts.isEmpty {
            return AnyView(Text("No data available").padding())
        } else {
            return AnyView(
                VStack {
                    Text("Progress Graph")
                        .font(.title2)
                        .padding(.bottom, 10)
                    
                    LineGraph(data: workouts.map { $0.intensity })
                        .frame(height: 200)
                }
            )
        }
    }
}

struct LineGraph: View {
    var data: [Int]

    var body: some View {
        GeometryReader { geometry in
            Path { path in
                guard !data.isEmpty else { return }
                
                let stepWidth = geometry.size.width / CGFloat(data.count - 1)
                let maxHeight = geometry.size.height
                let minIntensity = data.min() ?? 0
                let maxIntensity = data.max() ?? 10
                
                path.move(to: CGPoint(x: 0, y: maxHeight - CGFloat(data[0] - minIntensity) / CGFloat(maxIntensity - minIntensity) * maxHeight))
                
                for index in 1..<data.count {
                    path.addLine(to: CGPoint(x: stepWidth * CGFloat(index), y: maxHeight - CGFloat(data[index] - minIntensity) / CGFloat(maxIntensity - minIntensity) * maxHeight))
                }
            }
            .stroke(Color.blue, lineWidth: 3)
        }
    }
}

// Workout Page View where the user can add a workout
struct WorkoutPageView: View {
    @Binding var workoutHistory: [Workout]
    var selectedDuration: String?
    var selectedExercise: String?

    @State private var activityDuration: Int = 30
    @State private var selectedActivity: String = "Running"
    
    var body: some View {
        VStack {
            Picker("Activity", selection: $selectedActivity) {
                Text("Running").tag("Running")
                Text("Cycling").tag("Cycling")
                Text("Strength Training").tag("Strength Training")
                Text("Yoga").tag("Yoga")
            }
            .pickerStyle(.menu)
            
            Picker("Duration", selection: $activityDuration) {
                ForEach(15..<121, id: \.self) { time in
                    Text("\(time) min")
                }
            }
            .pickerStyle(.wheel)
            
            Stepper {
                Text("Duration")
            } onIncrement: {
                activityDuration += 5
            } onDecrement: {
                activityDuration -= 5
            }
            .onChange(of: activityDuration) {
                if (activityDuration < 0){
                    activityDuration = 0
                } else if (activityDuration > 120){
                    activityDuration = 120
                }
            }
            
            Text("\(activityDuration)")
            
            Button("Add Activity") {
                let newWorkout = Workout(
                    id: UUID(),
                    date: Date(),
                    activity: selectedActivity,
                    duration: activityDuration,
                    intensity: Int.random(in: 1...10),
                    completed: true
                )
                workoutHistory.append(newWorkout)
            }
            .font(.title2)
            .padding()
            .frame(maxWidth: .infinity)
            .background(LinearGradient(gradient: Gradient(colors: [Color.cyan, Color.blue]), startPoint: .top, endPoint: .bottom))
            .foregroundColor(.white)
            .cornerRadius(12)
            .shadow(radius: 10)
            .padding(.horizontal)

            Spacer()
        }
        .padding()
    }
}

// Roadmap Page View to display progress over time
struct RoadmapPageView: View {
    var workoutHistory: [Workout]

    var body: some View {
        VStack {
            Text("Your Fitness Roadmap")
                .font(.title)
                .fontWeight(.bold)
                .padding()

            if workoutHistory.isEmpty {
                Text("No progress data available.")
                    .padding()
            } else {
                List {
                    ForEach(workoutHistory) { workout in
                        VStack(alignment: .leading) {
                            Text("Activity: \(workout.activity)")
                                .font(.headline)
                            Text("Duration: \(workout.duration) min")
                            Text("Intensity: \(workout.intensity) / 10")
                            Text("Date: \(workout.date, formatter: dateFormatter)")
                        }
                        .padding()
                    }
                }
            }

            Spacer()
        }
        .padding()
    }
}

// Date Formatter to display workout date
let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()

// Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

