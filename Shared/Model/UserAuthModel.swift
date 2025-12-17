//
//  UserAuthModel.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 12/5/23.
//

import SwiftUI
import GlassRoomTypes
import GlassRoomInterface
import FirebaseAuth
#if os(visionOS)
import AuthenticationServices
#else
import GoogleSignIn
#endif

struct SignInResponse: Codable {
    var accessToken: String
    var expiresIn: Int
    var refreshToken: String
    var scope: String
    var tokenType: String
    var idToken: String
}

class UserAuthModel: NSObject, ObservableObject {
    static let shared: UserAuthModel = .init()

    @Published var isLoggedIn: Bool?
    @Published var grantedScopes: [String] = []
    
//    @Published var givenName: String?
//    @Published var familyName: String?
    @Published var fullName: String?
    @Published var email: String? {
        didSet {
            FileSystem.currentUserEmail = email
        }
    }
    @Published var profilePicUrl: String?
    @Published var errorMessage: String?
    @Published var token: String? {
        didSet {
            APISecretManager.accessToken = token ?? ""
        }
    }

    let neededScopes: [String] = [
        "https://www.googleapis.com/auth/classroom.courses.readonly",
        "https://www.googleapis.com/auth/classroom.announcements",
        "https://www.googleapis.com/auth/classroom.coursework.students",
        "https://www.googleapis.com/auth/classroom.coursework.me",
        "https://www.googleapis.com/auth/classroom.courseworkmaterials",
        "https://www.googleapis.com/auth/classroom.rosters.readonly",
        "https://www.googleapis.com/auth/classroom.topics"

        // SENSITIVE SCOPES
//        "https://www.googleapis.com/auth/classroom.profile.emails",
//        "https://www.googleapis.com/auth/classroom.profile.photos"
    ]

    private override init() {
        // load the email
        super.init()

        if let email = UserDefaults.standard.string(forKey: "userEmail") {
            self.email = email
        }

        if let token = UserDefaults.standard.string(forKey: "userAccessToken") {
            self.token = token
        }

        #if os(visionOS)
        self.checkStatus()
        #else
        self.setUpGoogleSignIn()
        self.restoreSignIn()
        #endif

    }

    #if os(visionOS)
    #else
    private func setUpGoogleSignIn() {
        let clientID = Secrets.getGoogleClientID()
        let signInConfig = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = signInConfig
    }
    #endif

    func checkStatus() {
        guard let user = Auth.auth().currentUser else {
//            self.givenName = nil
//            self.familyName = nil
            self.fullName = nil
            self.email = nil
            self.profilePicUrl = nil
            self.isLoggedIn = false
            self.token = nil
            return
        }
        
        let fullName = user.displayName
        let email = user.email
        let profilePicUrl = user.photoURL!.absoluteString

//        self.givenName = givenName
//        self.familyName = familyName
        self.fullName = fullName
        self.email = email
        self.profilePicUrl = profilePicUrl
        self.isLoggedIn = true
        checkPermissions()

        // save the email
        if let email {
            UserDefaults.standard.set(email, forKey: "userEmail")
        }
    }

    #if os(visionOS)
    #else
    private func restoreSignIn() {
        GIDSignIn.sharedInstance.restorePreviousSignIn { _, error in
            if let error = error {
                Log.error("Error: \(error.localizedDescription)")
                self.errorMessage = "error: \(error.localizedDescription)"
            }

            self.checkStatus()
        }
    }
    #endif

    func signIn() {
        #if os(visionOS)
        let clientId = "327651979329-p2sm1brpk7q099vifh2v95d5ld805gdt.apps.googleusercontent.com"
        let redirectUri = "org.sstinc.the-glassroom:/oauth2redirect"
        var authUrlString = "https://accounts.google.com/o/oauth2/v2/auth?client_id=\(clientId)&redirect_uri=\(redirectUri)&response_type=code&scope=profile email"
        for scope in neededScopes {
            authUrlString.append(" \(scope)")
        }
        let authUrl = URL(string: authUrlString)!
        let callbackUrlScheme = "org.sstinc.the-glassroom"

        let authenticationSession = ASWebAuthenticationSession(url: authUrl, callbackURLScheme: callbackUrlScheme) { callbackURL, error in
            guard error == nil, let callbackURL = callbackURL else { return }

            let queryItems = URLComponents(string: callbackURL.absoluteString)?.queryItems
            guard let code = queryItems?.first(where: { $0.name == "code" })?.value else { return }

            let parameters = "client_id=\(clientId)&client_secret=&code=\(code)&grant_type=authorization_code&redirect_uri=\(redirectUri)"
            let postData = parameters.data(using: .utf8)

            var request = URLRequest(url: URL(string: "https://oauth2.googleapis.com/token")!, timeoutInterval: Double.infinity)
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

            request.httpMethod = "POST"
            request.httpBody = postData

            var signInResponse: SignInResponse? = nil

            Task {
                let (data, _) = try await URLSession.shared.data(for: request)

                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                signInResponse = try? decoder.decode(SignInResponse.self, from: data)

                if let signInResponse {
                    let credential = GoogleAuthProvider.credential(withIDToken: signInResponse.idToken, accessToken: signInResponse.accessToken)
                    Auth.auth().signIn(with: credential) { result, error in
                        guard error == nil else {
                            return
                        }

                        self.token = signInResponse.accessToken
                        UserDefaults.standard.set(self.token, forKey: "userAccessToken")

                        self.checkStatus()
                    }
                }
            }
        }

        authenticationSession.presentationContextProvider = self
        authenticationSession.start()
        #else
        guard let presentingController = getPresenter() else { return }

        GIDSignIn.sharedInstance.signIn(withPresenting: presentingController) { result, error in
            if let error = error {
                self.errorMessage = "error: \(error.localizedDescription)"
            }

            guard let user = result?.user, let idToken = user.idToken?.tokenString else {
                return
            }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)

            Auth.auth().signIn(with: credential) { result, error in
                guard error == nil else {
                    return
                }

                self.token = user.accessToken.tokenString
                UserDefaults.standard.set(token, forKey: "userAccessToken")

                self.checkStatus()
            }
        }
        #endif
    }

    func signOut() {
        try? Auth.auth().signOut()
        #if os(visionOS)
        #else
        GIDSignIn.sharedInstance.signOut()
        #endif
        UserDefaults.standard.removeObject(forKey: "userEmail")
        UserDefaults.standard.removeObject(forKey: "userAccessToken")

        self.checkStatus()
    }

    @discardableResult
    func checkPermissions(requestIfMissing: Bool = true) -> Bool {
        #if os(visionOS)
        return true
        #else
        guard let user = GIDSignIn.sharedInstance.currentUser else { return false }
        let grantedScopes = user.grantedScopes
        self.grantedScopes = user.grantedScopes ?? []

        if grantedScopes == nil || !hasNeededScopes() {
            // Request additional scopes.
            if requestIfMissing {
                requestPermissions()
            }
            return false
        }
        return true
        #endif
    }

    func hasNeededScopes() -> Bool {
        for scope in neededScopes {
            if !grantedScopes.contains(scope) {
                #if os(visionOS)
                return true
                #else
                return false
                #endif
            }
        }
        return true
    }

    func requestPermissions() {
        #if os(visionOS)
        #else
        guard let user = GIDSignIn.sharedInstance.currentUser,
              let presentingController = getPresenter() else {
            Log.error("Could not get user")
            return
        }

        // get the scopes that we don't have
        var requestingScopes: [String] = []
        requestingScopes = neededScopes.filter({ !grantedScopes.contains($0) })
        user.addScopes(requestingScopes, presenting: presentingController) { signInResult, error in
            guard error == nil else { return }
            self.checkPermissions(requestIfMissing: false)
            guard let newUser = signInResult?.user else { return }
            let accessToken = newUser.accessToken.tokenString
            self.token = accessToken
        }
        #endif
    }

    #if os(macOS)
    typealias PresentingController = NSWindow
    #else
    typealias PresentingController = UIViewController
    #endif

    func getPresenter() -> PresentingController? {
        #if os(macOS)
        guard let presentingController = NSApp.windows.first else {
            Log.error("Could not get presenting nswindow")
            return nil
        }
        return presentingController
        #else
        guard let scene = UIApplication.shared.connectedScenes.first,
              let windowSceneDelegate = scene.delegate as? UIWindowSceneDelegate,
              let window = windowSceneDelegate.window,
              let presentingController = window?.rootViewController else {
            Log.error("Could not get presenting uiviewcontroller")
            return nil
        }
        return presentingController
        #endif
    }
}

extension UserAuthModel: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController?.view.window
        return window ?? ASPresentationAnchor()
    }
}
