//
//  SettingsView.swift
//  The GlassRoom
//
//  Created by Tristan on 14/05/2023.
//

import SwiftUI

struct SettingsView: View {
    
    @AppStorage("settingsTabSelection", store: .standard) var settingsTabSelection = 0
    @ObservedObject var userModel: UserAuthModel = .shared

    @AppStorage("debugMode") var debugMode: Bool = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        TabView(selection: $settingsTabSelection) {
            account
                .frame(width: 680, height: 200)
                .tabItem {
                    Label("Account", systemImage: settingsTabSelection == 0 ? "person.fill" : "person")
                }
                .tag(0)
            
            general
                .frame(width: 680, height: 300)
                .tabItem {
                    Label("General", systemImage: settingsTabSelection == 1 ? "gearshape.fill" : "gearshape")
                }
                .tag(1)

            CustomisationView()
                .frame(width: 680, height: 300)
                .tabItem {
                    Label("Customisation", systemImage: settingsTabSelection == 2 ? "paintpalette.fill" : "paintpalette")
                }
                .tag(2)

            
            shortcuts
                .frame(width: 680, height: 300)
                .tabItem {
                    Label("Shortucts", systemImage: settingsTabSelection == 3 ? "keyboard.fill" : "keyboard")
                }
                .tag(3)
        }
    }
    
    var account: some View {
        HStack {
            HStack {
                Spacer()
                
                VStack {
                    AsyncImage(url: URL(string: getProfilePicURL()))
                        .mask(Circle())
                    
                    Button {
                        dismiss.callAsFunction()
                        userModel.signOut()
                    } label: {
                        Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
                    }
                    .padding(.top, 5)
                }
                
                Spacer()
                
                VStack {
                    if let fullName = userModel.fullName {
                        VStack(alignment: .leading) {
                            
                            Text("Full name")
                                .font(.headline)
                                .fontWeight(.bold)
                            
                            Text(fullName)
                                .font(.headline)
                                .padding(.top, 5)
                            
                            Divider()
                                .frame(width: 340)
                        }
                        
                    } else if let givenName = userModel.givenName {
                        VStack(alignment: .leading) {
                            
                            Text("Name")
                                .font(.headline)
                                .fontWeight(.bold)
                            
                            Text(givenName)
                                .font(.headline)
                                .padding(.top, 5)
                            
                            Divider()
                                .frame(width: 340)
                        }
                    }
                    
                    if let email = userModel.email {
                        VStack(alignment: .leading) {
                            
                            Text("Email")
                                .font(.headline)
                                .fontWeight(.bold)
                                .padding(.top, 5)
                            
                            Text(email)
                                .font(.headline)
                                .padding(.vertical, 5)
                            
                            Divider()
                                .frame(width: 340)
                        }
                    }
                }
                .padding(.leading)
                
                Spacer()
            }
        }
        .padding(.horizontal)
    }
    
    var general: some View {
        VStack {
            Text("General Settings")
            Toggle("Debug Mode", isOn: $debugMode)
        }
    }
    
    var shortcuts: some View {
        VStack {
            Text("Shortcuts")
        }
    }
    
    func getFullName() -> String {
        guard let fullName = userModel.fullName else {
            guard let givenName = userModel.givenName else {
                return ""
            }
            return givenName
        }
        return fullName
    }
    
    func getProfilePicURL() -> String {
        guard let profilePicURL = userModel.profilePicUrl else { return "" }
        return profilePicURL
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
