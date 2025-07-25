import SwiftUI

struct HomeView: View {
    @Binding var showSurvey: Bool
    @State private var isSubscribed = false
    @EnvironmentObject var store: SurveyStore
    @State private var showSurveyPrompt = false
    @State private var promptTimer: Timer?

    var body: some View {
        ZStack {
         
            Image("BackgroundImage")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .opacity(0.05)

            
            ScrollView {
                VStack(spacing: 30) {
                    Text("Happiness Monitor")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .padding(.top, 10)

                   
                    VStack(spacing: 16) {
                        Button(action: {
                            showSurvey = true
                        }) {
                            Text("Take Survey")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }

                        Button(action: {
                            APIManager.shared.toggleSubscription { newStatus in
                                if let new = newStatus {
                                    DispatchQueue.main.async {
                                        isSubscribed = new
                                    }
                                }
                            }
                        }) {
                            Text(isSubscribed ? "Unsubscribe from Prompts" : "Subscribe to Prompts")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(isSubscribed ? Color.red : Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                    }
                    .frame(maxWidth: 300)

                    Text("Recent Surveys")
                        .font(.headline)
                        .padding(.top)

                    VStack(spacing: 10) {
                        ForEach(store.surveys, id: \.timestamp) { survey in
                            VStack(alignment: .leading, spacing: 4) {
                                Text("📌 Activity: \(survey.activity)")
                                Text("😊 Happiness: \(survey.happiness_level)")
                                Text("🕒 Time: \(survey.timestamp)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(10)
                            .shadow(radius: 1)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding()
            }
        }
        .onAppear {
            store.loadSurveys()
            promptTimer = Timer.scheduledTimer(withTimeInterval: 20.0, repeats: true) { _ in
                APIManager.shared.checkPromptStatus { shouldShow in
                    if shouldShow {
                        DispatchQueue.main.async {
                            if !showSurvey {
                                showSurveyPrompt = true
                                UINotificationFeedbackGenerator().notificationOccurred(.success)
                            }
                        }
                    }
                }
            }
        }
        .onDisappear {
            promptTimer?.invalidate()
            promptTimer = nil
        }
        .alert("Survey Available", isPresented: $showSurveyPrompt) {
            Button("Take Survey") {
                showSurvey = true
                showSurveyPrompt = false
            }
            Button("Dismiss", role: .cancel) {
                showSurveyPrompt = false
            }
        } message: {
            Text("A new survey is available for you.")
        }
    }
}
