import SwiftUI

struct ContentView: View {
    @State private var showSurvey = false
    @StateObject private var store = SurveyStore()

    var body: some View {
        NavigationView {
            HomeView(showSurvey: $showSurvey)
                .environmentObject(store)
                .sheet(isPresented: $showSurvey) {
                    SurveyView()
                        .environmentObject(store)
                }
        }
    }
}

