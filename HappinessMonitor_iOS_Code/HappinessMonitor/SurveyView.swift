import SwiftUI


struct SurveyView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var store: SurveyStore
    @State private var activity = ""
    @State private var happiness = 5.0
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""

    var body: some View {
        ZStack {
            
            Image("BackgroundImage")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .opacity(0.15)

            
            VStack(spacing: 24) {
                Text("Take Survey")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .padding(.top)

                VStack(alignment: .leading, spacing: 16) {
                    Text("Your Current Activity")
                        .font(.headline)

                    TextField("e.g. Studying, Walking", text: $activity)
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)

                    Text("Your Happiness Level")
                        .font(.headline)

                    VStack(alignment: .leading) {
                        Text("Happiness: \(Int(happiness))")
                            .font(.subheadline)
                        Slider(value: $happiness, in: 1...10, step: 1)
                    }
                }
                .padding()
                .background(Color(UIColor.systemBackground).opacity(0.9))
                .cornerRadius(12)
                .shadow(radius: 2)
                .padding(.horizontal)

                VStack(spacing: 12) {
                    Button(action: submitSurvey) {
                        Text("Submit")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }

                    Button(action: {
                        dismiss()
                    }) {
                        Text("Cancel")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .frame(maxWidth: 300)
                .padding(.bottom)

                Spacer()
            }
            .padding()
        }
        .alert(alertTitle, isPresented: $showAlert) {
            Button("OK", role: .cancel) {
                if alertTitle == "Success" {
                    dismiss()
                }
            }
        } message: {
            Text(alertMessage)
        }
    }

    func submitSurvey() {
        guard !activity.trimmingCharacters(in: .whitespaces).isEmpty else {
            alertTitle = "Missing Activity"
            alertMessage = "Please enter your current activity."
            showAlert = true
            return
        }

        APIManager.shared.submitSurvey(activity: activity, happiness: Int(happiness)) { success in
            DispatchQueue.main.async {
                if success {
                    store.loadSurveys()
                    alertTitle = "Success"
                    alertMessage = "Your survey has been submitted."
                } else {
                    alertTitle = "Error"
                    alertMessage = "Submission failed. Please try again."
                }
                showAlert = true
            }
        }
    }
}
