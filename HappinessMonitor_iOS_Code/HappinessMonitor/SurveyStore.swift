import Foundation

class SurveyStore: ObservableObject {
    @Published var surveys: [Survey] = []

    func loadSurveys() {
        APIManager.shared.getRecentSurveys { fetched in
            DispatchQueue.main.async {
                self.surveys = fetched
            }
        }
    }
}
