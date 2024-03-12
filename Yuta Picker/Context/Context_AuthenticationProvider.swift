//
//  Manager_Authentication.swift
//  Yuta Picker
//
//  Created by Nguyen Phuc Loi on 05/03/2024.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import GoogleSignIn
import GoogleSignInSwift

enum AuthenticationError: Error, CaseIterable {
    case invalidCredentials
    case invalidData
}

class AuthenticationContextProvider: ObservableObject {
    @Published var currentAccount: Account? = nil
    @Published var isSignInWithGoogle: Bool = false
    @Published var isSignInWithFacebook: Bool = false
    @Published var isSignInWithGithub: Bool = false
    @Published var alertTitle: String = ""
    @Published var isDisplayAlert: Bool = false
    @Published var alertMsg: String = ""
    
    var isActive: Bool {
        return Auth.auth().currentUser != nil
    }
    
    func signInWithGoogle(callback: @escaping () -> ())async -> Bool {
        let db = Firestore.firestore()
        guard let clientID = FirebaseApp.app()?.options.clientID else { return false }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowScene = await UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = await windowScene.windows.first,
              let rootViewController = await window.rootViewController else {
            Log.proposeLogError("There is no root view controller")
            return false
        }
        
        do {
            let userAuthentication: GIDSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            Log.proposeLogInfo("\nGIDSignInResult = \(userAuthentication)")
            
            let user: GIDGoogleUser = userAuthentication.user
            Log.proposeLogInfo("\nGIDGoogleUser = \(user)")
            
            guard let idToken = user.idToken else {
                Log.proposeLogError("Token ID does not exist")
                return false
            }
            
            let accessToken = user.accessToken
            Log.proposeLogInfo("\nAccess Token = \(accessToken)")
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
            Log.proposeLogInfo("\nCredential  = \(credential)")
            
            let result = try await Auth.auth().signIn(with: credential)
            Log.proposeLogInfo("\nResult  = \(result)")
            
            let userObject = result.user
            Log.proposeLogInfo("\nUser Object  = \(userObject)")
            
            let accountEntity: Account = Account(id: userObject.uid, email: userObject.email!, name: userObject.displayName!, paletteIds: [], libraryWorkspaceIds: [])
            let isAccountExist: Bool = await isAccountExistInFirestore(accountId: accountEntity.id)
            
            if !isAccountExist {
                self.insertUser(data: accountEntity, callback: callback)
            }
            
            Log.proposeLogInfo("\n\nUser \(userObject.uid) signed in with \(userObject.email ?? "Unknown")")
            return true
            
        }catch let error {
            Log.proposeLogError(error.localizedDescription)
            return false
        }

    }
    
    func signInWithGithub() {
        
    }
    
    func signInWithFacebook() {
        
    }
    
    func signOut(callback: @escaping () -> ()) {
        do {
            try Auth.auth().signOut()
            self.currentAccount = nil
            callback()
        }catch {
            Log.proposeLogError("Unable to sign out")
        }
    }
    
    func insertUser(data: Account, callback: @escaping () -> ()) {
        let db = Firestore.firestore()
        do {
            try db.collection("accounts").document(data.id).setData(from: data) { error in
                if let error = error {
                    Log.proposeLogError(error.localizedDescription)
                }
                
                Log.proposeLogInfo("[SUCCESS] ==> Inserted user <\(data.id)> successfully to Firestore Database")
            }
        }catch let error {
            Log.proposeLogError(error.localizedDescription)
        }
        
        callback()
    }
    
    func fetchCurrentAccount() -> Void {
        let db = Firestore.firestore()
        
        guard let uId = Auth.auth().currentUser?.uid else {
            return
        }
        
        print("[USER ID]: \(uId)")
        
        db.collection("accounts").document(uId).getDocument { [weak self] snapshot, error in
            guard let data = snapshot?.data() else {
                return
            }
            
            Log.proposeLogInfo("[FETCHED DOCUMENT DATA]: \(data)")
            
            DispatchQueue.main.async {
                self?.currentAccount = Account(
                    id: data["id"] as? String ?? "",
                    email: data["email"] as? String ?? "",
                    name: data["name"] as? String ?? "",
                    paletteIds: data["paletteIds"] as? [String] ?? [],
                    libraryWorkspaceIds: data["libraryWorkspaceIds"] as? [String] ?? []
                )
            }
        }
    }
    
    func isAccountExistInFirestore(accountId: String) async -> Bool {
        let db = Firestore.firestore()
        let docRef = db.collection("accounts").document(accountId)
        
        do {
            let document = try await docRef.getDocument()
            print("[DOCUMENT EXIST STATE]: \(document.exists)")
            return document.exists
        }catch {
            return false
        }
    }
}
