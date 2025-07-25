class AuthManager {
    static let shared = AuthManager()

    private init() {}

    var token: String? {
        // Paste the token you copied from Django Admin here:
        return "90fff289e4f6f80efb35750a82ffba4b243df6ef"
    }
}
