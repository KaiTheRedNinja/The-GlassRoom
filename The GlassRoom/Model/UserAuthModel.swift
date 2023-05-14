//
//  UserAuthModel.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 12/5/23.
//

import SwiftUI
import GoogleSignIn
import GlassRoomAPI

class UserAuthModel: ObservableObject {
    static let shared: UserAuthModel = .init()

    @Published var isLoggedIn: Bool?
    @Published var grantedScopes: [String] = []
    
    @Published var givenName: String?
    @Published var familyName: String?
    @Published var fullName: String?
    @Published var email: String?
    @Published var profilePicUrl: String?
    @Published var errorMessage: String?
    @Published var token: String? {
        didSet {
            APISecretManager.accessToken = token ?? ""
        }
    }

    let neededScopes: [String] = [
        "https://www.googleapis.com/auth/classroom.courses",
        "https://www.googleapis.com/auth/classroom.announcements",
        "https://www.googleapis.com/auth/classroom.coursework.students",
        "https://www.googleapis.com/auth/classroom.coursework.me",
        "https://www.googleapis.com/auth/classroom.courseworkmaterials",
        "https://www.googleapis.com/auth/classroom.rosters",
        "https://www.googleapis.com/auth/classroom.topics"
    ]

    private init() {
        let clientID = Secrets.getGoogleClientID()
        let signInConfig = GIDConfiguration(clientID: clientID)

        GIDSignIn.sharedInstance.configuration = signInConfig
        restoreSignIn()
    }

    func checkStatus() {
        guard let user = GIDSignIn.sharedInstance.currentUser else {
            self.isLoggedIn = false
            self.givenName = nil
            self.profilePicUrl = nil
            return
        }
        
        let givenName = user.profile?.givenName
        let familyName = user.profile?.familyName
        let fullName = user.profile?.name
        let email = user.profile?.email
        let profilePicUrl = user.profile!.imageURL(withDimension: 100)!.absoluteString
        self.givenName = givenName
        self.familyName = familyName
        self.fullName = fullName
        self.email = email
        self.profilePicUrl = profilePicUrl
        self.isLoggedIn = true
        self.token = user.accessToken.tokenString
        checkPermissions()
    }

    private func restoreSignIn() {
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

    func signOut() {
        GIDSignIn.sharedInstance.signOut()
        self.checkStatus()
    }

    @discardableResult
    func checkPermissions(requestIfMissing: Bool = true) -> Bool {
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
    }

    func hasNeededScopes() -> Bool {
        for scope in neededScopes {
            if !grantedScopes.contains(scope) {
                return false
            }
        }
        return true
    }

    func requestPermissions() {
        guard let user = GIDSignIn.sharedInstance.currentUser else {
            print("Could not get user")
            return
        }
        guard let presentingWindow = NSApp.windows.first else {
            print("Could not get presenting view controller")
            return
        }

        // get the scopes that we don't have
        var requestingScopes: [String] = []
        requestingScopes = neededScopes.filter({ !grantedScopes.contains($0) })

        user.addScopes(requestingScopes, presenting: presentingWindow) { signInResult, error in
            guard error == nil else { return }
            self.checkPermissions(requestIfMissing: false)
            guard let newUser = signInResult?.user else { return }
            let accessToken = newUser.accessToken.tokenString
            self.token = accessToken
        }
    }
}
