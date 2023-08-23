//
//  SettingsView.swift
//  The GlassRoom
//
//  Created by Tristan on 14/05/2023.
//

import SwiftUI
#if os(macOS)
import KeyboardShortcuts
#endif

struct SettingsView: View {
    
    @AppStorage("settingsTabSelection", store: .standard) var settingsTabSelection = 0
    @ObservedObject var userModel: UserAuthModel = .shared

    @AppStorage("debugMode") var debugMode: Bool = false
    @AppStorage("useSenderPfpAsIcon") var useSenderPfpAsIcon: Bool = false
    @AppStorage("enableBionicReading") var enableBionicReading: Bool = false
    @AppStorage("tintToCourseColor") var tintToCourseColor: Bool = false
    @AppStorage("useFancyUI") var useFancyUI: Bool = false
    @AppStorage("lowerUnloadedOpacity") var lowerUnloadedOpacity: Bool = true
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        #if os(macOS)
        TabView(selection: $settingsTabSelection) {
            account
                .frame(width: 680, height: 200)
                .tabItem {
                    Label("Account", systemImage: settingsTabSelection == 0 ? "person.fill" : "person")
                }
                .tag(0)
            
            VStack {
                Spacer()
                VStack(alignment: .leading) {
                    general
                }
                Spacer()
            }
            .frame(width: 680, height: 300)
            .tabItem {
                Label("General", systemImage: "gear")
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
                    Label("Shortcuts", systemImage: settingsTabSelection == 3 ? "keyboard.fill" : "keyboard")
                }
                .tag(3)
        }
        #else
        NavigationView {
            List {
                Section {
                    account
                }
                
                Section {
                    NavigationLink {
                        general
                            .navigationTitle("General")
                            .navigationBarTitleDisplayMode(.inline)
                    } label: {
                        Label("General", systemImage: "gear")
                    }
                    
                    NavigationLink {
                        CustomisationView()
                            .navigationTitle("Customisation")
                            .navigationBarTitleDisplayMode(.inline)
                    } label: {
                        Label("Customisation", systemImage: "paintpalette.fill")
                    }
                }
                
                Section {
                    Button(role: .destructive) {
                        dismiss.callAsFunction()
                        userModel.signOut()
                    } label: {
                        HStack {
                            Spacer()
                            Text("Sign Out")
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss.callAsFunction()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
        }
        #endif
    }
    
    var account: some View {
        HStack {
            HStack {
                
                #if os(macOS)
                Spacer()
                #endif
                
                VStack {
                    #if os(iOS)
                    if UIScreen.main.traitCollection.userInterfaceIdiom == .phone {
                        AsyncImage(url: URL(string: getProfilePicURL()))
                            .mask(Circle())
                            .scaleEffect(0.75)
                            .frame(width: UIScreen.main.bounds.width / 6, height: UIScreen.main.bounds.width / 6)
                    } else {
                        AsyncImage(url: URL(string: getProfilePicURL()))
                            .mask(Circle())
                    }
                    #else
                    AsyncImage(url: URL(string: getProfilePicURL()))
                        .mask(Circle())
                    #endif
                    
                    #if os(macOS)
                    Button {
                        dismiss.callAsFunction()
                        userModel.signOut()
                    } label: {
                        Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
                    }
                    .padding(.top, 5)
                    #endif
                }
                
                
                VStack(alignment: .leading) {
                    if let fullName = userModel.fullName {
                        VStack(alignment: .leading) {
                            
                            #if os(macOS)
                            Text("Full name")
                                .font(.headline)
                                .fontWeight(.bold)
                            #endif
                            
                            Text(fullName)
                                .font(.title3)
                                .padding(.top, 5)
                            #if os(iOS)
                                .fontWeight(.heavy)
                            #else
                                .fontWeight(.bold)
                            #endif
                            
                            #if os(macOS)
                            Divider()
                                .frame(width: 340)
                            #endif
                        }
                        
                    } else if let givenName = userModel.givenName {
                        VStack(alignment: .leading) {
                            
                            #if os(macOS)
                            Text("Name")
                                .font(.headline)
                                .fontWeight(.bold)
                            #endif
                            
                            Text(givenName)
                                .font(.title3)
                                .padding(.top, 5)
                            #if os(iOS)
                                .fontWeight(.heavy)
                            #else
                                .fontWeight(.bold)
                            #endif
                            
                            #if os(macOS)
                            Divider()
                                .frame(width: 340)
                            #endif
                        }
                    }
                    
                    if let email = userModel.email {
                        VStack(alignment: .leading) {
                            
                            #if os(macOS)
                            Text("Email")
                                .font(.headline)
                                .fontWeight(.bold)
                                .padding(.top, 5)
                            #endif
                            
                            Text(email)
                            #if os(macOS)
                                .padding(.vertical, 5)
                                .font(.headline)
                            #else
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundStyle(.secondary)
                            #endif
                            
                            #if os(macOS)
                            Divider()
                                .frame(width: 340)
                            #endif
                        }
                    }
                }
                .padding(.leading)
                
                Spacer()
            }
        }
        #if os(macOS)
        .padding(.horizontal)
        #else
        .padding(.all, 5)
        #endif
    }
    
    var general: some View {
        Form {
            #if os(macOS)
            Toggle("Debug Mode", isOn: $debugMode)
            Toggle("Use announcement author's profile picture as symbol", isOn: $useSenderPfpAsIcon)
            Toggle("Enable bionic reading", isOn: $enableBionicReading)
            Toggle("Tint posts background to course color", isOn: $tintToCourseColor)
            Toggle("Use fancy UI", isOn: $useFancyUI)
            Toggle("Reduce course name opacity for unloaded courses", isOn: $lowerUnloadedOpacity)
            #else
            Section {
                Toggle("Use announcement author's profile picture as symbol", isOn: $useSenderPfpAsIcon)
            } header: {
                Text("General")
            }
            
            Section {
                Toggle("Enable bionic reading", isOn: $enableBionicReading)
            } header: {
                Text("Accessbility")
            }
            
            Section {
                Toggle("Debug Mode", isOn: $debugMode)
            } header: {
                Text("Developer")
            }
            #endif
        }
    }
    
    #if os(macOS)
    var shortcuts: some View {
        List {
            GroupBox {
                VStack {
                    KeyboardShortcuts.Recorder("Reload Posts", name: .reloadCoursePosts)
                    KeyboardShortcuts.Recorder("Reload Sidebar", name: .reloadSidebar)
                    //              KeyboardShortcuts.Recorder("Switch to Next Tab", name: .nextTab)
                    //              KeyboardShortcuts.Recorder("Switch to Previous Tab", name: .previousTab)
                    KeyboardShortcuts.Recorder("Show/Hide Tab Bar", name: .toggleTabBar)
                    KeyboardShortcuts.Recorder("Toggle Universal Search", name: .openUniversalSearch)
                }
                .padding(5)
            }
        }
        .scrollContentBackground(.hidden)
    }
    #endif
    
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
