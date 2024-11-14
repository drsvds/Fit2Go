import SwiftUI

struct Workout_View: View {
    @State private var selectedDifficulty = "Normal"
    @State private var exercises = [
        ("Pushups", "10"),
        ("Situps", "10"),
        ("Squat", "10"),
        ("Curl", "10"),
        ("Leg raise", "10"),
        ("Burpee", "10")
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Title
            Text("Plan")
                .font(.largeTitle)
                .bold()
                .padding(.top)
            
            // Date Navigation
            HStack {
                Button(action: {
                    // Handle previous date action
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.blue)
                }
                
                Spacer()
                
                Text("19 Jan")
                    .font(.title)
                    .bold()
                
                Spacer()
                
                Button(action: {
                    // Handle next date action
                }) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal)
            
            // Difficulty Picker
            Picker(selection: $selectedDifficulty, label: Text("Difficulty")) {
                Text("Recovery").tag("Recovery")
                Text("Normal").tag("Normal")
                Text("Hard").tag("Hard")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            
            Divider()
            
            // Exercise List
            VStack(spacing: 10) {
                ForEach(0..<exercises.count, id: \.self) { index in
                    HStack {
                        Text("\(index + 1). \(exercises[index].0)")
                            .font(.body)
                        
                        Spacer()
                        
                        Text(exercises[index].1)
                            .font(.body)
                    }
                    .padding(.horizontal)
                    
                    Divider()
                }
            }
            
            Spacer()
            
           
        }
        .padding()
    }
}

struct WorkoutPlanView_Previews: PreviewProvider {
    static var previews: some View {
        Workout_View()
    }
}
