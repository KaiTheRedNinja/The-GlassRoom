//
//  UserAuthModel.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 12/5/23.
//

import SwiftUI
import GoogleSignIn

class UserAuthModel: ObservableObject {
    static let shared: UserAuthModel = .init()

    @Published var isLoggedIn: Bool?
    @Published var hasPermissions: Bool = false

    @Published var givenName: String?
    @Published var profilePicUrl: String?
    @Published var errorMessage: String?
    @Published var token: String?

    let neededScopes: [String] = [
        "https://www.googleapis.com/auth/classroom.courses",
        "https://www.googleapis.com/auth/classroom.announcements",
        "https://www.googleapis.com/auth/classroom.coursework.students",
        "https://www.googleapis.com/auth/classroom.courseworkmaterials",
        "https://www.googleapis.com/auth/classroom.rosters",
        "https://www.googleapis.com/auth/classroom.topics"
    ]

    private init() {
        let clientID = Secrets.getGoogleClientID()
        let signInConfig = GIDConfiguration(clientID: clientID)

        GIDSignIn.sharedInstance.configuration = signInConfig
        check()
    }

    func checkStatus() {
        guard let user = GIDSignIn.sharedInstance.currentUser else {
            self.isLoggedIn = false
            self.givenName = nil
            self.profilePicUrl = nil
            return
        }
        let givenName = user.profile?.givenName
        let profilePicUrl = user.profile!.imageURL(withDimension: 100)!.absoluteString
        self.givenName = givenName
        self.profilePicUrl = profilePicUrl
        self.isLoggedIn = true
        self.token = user.accessToken.tokenString
        checkPermissions()
    }

    private func check() {
        GIDSignIn.sharedInstance.restorePreviousSignIn { _, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                self.errorMessage = "error: \(error.localizedDescription)"
            }

            self.checkStatus()
        }
    }

    func signIn() {
        guard let presentingWindow = NSApp.windows.first else {
            print("Could not get presenting view controller")
            return
        }

        GIDSignIn.sharedInstance.signIn(withPresenting: presentingWindow,
                                        completion: { _, error in
            if let error = error {
                self.errorMessage = "error: \(error.localizedDescription)"
            }

            self.checkStatus()
        })
    }

    @discardableResult
    func checkPermissions(requestIfMissing: Bool = true) -> Bool {
        guard let user = GIDSignIn.sharedInstance.currentUser else { return false }
        let grantedScopes = user.grantedScopes
        if grantedScopes == nil || grantedScopes!.contains(neededScopes) {
            print("Requesting additional scopes")
            // Request additional scopes.
            if requestIfMissing {
                requestPermissions()
            }
            hasPermissions = false
            return false
        }
        hasPermissions = true
        return true
    }

    func requestPermissions() {
        guard let user = GIDSignIn.sharedInstance.currentUser else { return }
        guard let presentingWindow = NSApp.windows.first else {
            print("Could not get presenting view controller")
            return
        }

        // get the scopes that we don't have
        var requestingScopes: [String] = []
        if let grantedScopes = user.grantedScopes {
            requestingScopes = neededScopes.filter({ grantedScopes.contains($0) })
        } else {
            requestingScopes = neededScopes
        }

        user.addScopes(requestingScopes, presenting: presentingWindow) { signInResult, error in
            guard error == nil else { return }
            self.checkPermissions(requestIfMissing: false)
            guard let newUser = signInResult?.user else { return }
            let accessToken = newUser.accessToken.tokenString
            self.token = accessToken
        }
    }

    func signOut() {
        GIDSignIn.sharedInstance.signOut()
        self.checkStatus()
    }
}
