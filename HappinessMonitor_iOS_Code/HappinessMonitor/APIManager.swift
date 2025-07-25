import Foundation

class APIManager {
    static let shared = APIManager()
    let baseURL = "http://localhost:8000/api"

    

    func submitSurvey(activity: String, happiness: Int, completion: @escaping (Bool) -> Void) {
        guard let token = AuthManager.shared.token,
              let url = URL(string: "\(baseURL)/submit-survey/") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Token \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = ["activity": activity, "happiness_level": happiness] as [String : Any]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, _, _ in
            completion(data != nil)
        }.resume()
    }

    func getRecentSurveys(completion: @escaping ([Survey]) -> Void) {
        guard let token = AuthManager.shared.token,
              let url = URL(string: "\(baseURL)/last-surveys/") else {
            print("Missing token or URL")
            return
        }

        var request = URLRequest(url: url)
        request.setValue("Token \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("API Error:", error)
                completion([])
                return
            }

            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let surveys = try decoder.decode([Survey].self, from: data)
                    print("Fetched Surveys:", surveys)
                    completion(surveys)
                } catch {
                    print("Decoding Error:", error)
                    print("Raw response:", String(data: data, encoding: .utf8) ?? "nil")
                    completion([])
                }
            } else {
                print("No data returned")
                completion([])
            }
        }.resume()
    }


    func toggleSubscription(completion: @escaping (Bool?) -> Void) {
        guard let token = AuthManager.shared.token,
              let url = URL(string: "\(baseURL)/toggle-subscription/") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Token \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, _, _ in
            if let data = data,
               let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let status = json["is_subscribed"] as? Bool {
                completion(status)
            } else {
                completion(nil)
            }
        }.resume()
    }
    
    func checkPromptStatus(completion: @escaping (Bool) -> Void) {
        guard let token = AuthManager.shared.token,
              let url = URL(string: "\(baseURL)/prompt-status/") else {
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.setValue("Token \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, _, _ in
            if let data = data,
               let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let shouldPrompt = json["show_prompt"] as? Bool {
                completion(shouldPrompt)
            } else {
                completion(false)
            }
        }.resume()
    }

}
