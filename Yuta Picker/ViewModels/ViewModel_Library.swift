//
//  ViewModel_LibraryWorkspace.swift
//  Yuta Picker
//
//  Created by Nguyen Phuc Loi on 05/03/2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class LibraryViewViewModel: ObservableObject {
    @Published var isDisplayAlert: Bool = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    @Published var name: String = ""
    @Published var currentAccountLibraries: [Library] = []
    
    let db = Firestore.firestore()
    
    func createNewLibrary(account: Account, data: Library, callback: @escaping () -> ()) {
        do {
            try db.collection("libraries").document(data.id).setData(from: data)
            
            db.collection("accounts").document(account.id).updateData(["libraryWorkspaceIds": FieldValue.arrayUnion([data.id])]) { error in
                Log.proposeLogInfo("[SUCCESS UPDATED CURRENT USER DOCUMENT - save user library ID]")
            }
            callback()
        }catch let error {
            Log.proposeLogError("[ERROR] ==> \(error.localizedDescription)")
        }
    }
    
    func fetchAllLibrariesByAccountId(ownerId: String, callback: @escaping () -> ()) -> Void {
        do {
            db.collection("libraries").whereField("ownerId", isEqualTo: ownerId)
                .getDocuments { (snapshot, error) in
                    if let error = error {
                        print("Error fetching posts: \(error)")
                        return
                    }
                    
                    guard let documents = snapshot?.documents else {
                        print("No documents found")
                        return
                    }
                    
                    DispatchQueue.main.async {
                        self.currentAccountLibraries = documents.compactMap { document -> Library? in
                            try? document.data(as: Library.self)
                        }
                        Log.proposeLogInfo("[LIBRARY DATA]: \(self.currentAccountLibraries)")
                    }
                }
            
        }catch let error {
            Log.proposeLogError("\(error.localizedDescription)")
            
        }
    }
    
    func addColorToCurrentLibrary(libraryId: String, hexData: String, callback: @escaping () -> ()) {
        do {
            db.collection("libraries").document(libraryId).updateData(["colors": FieldValue.arrayUnion([hexData])]) { error in
                Log.proposeLogInfo("[SUCCESSFULLY ADDED COLOR TO LIBRARY \(libraryId)]")
            }
            callback()
        }catch let error {
            Log.proposeLogError("\(error.localizedDescription)")
        }
    }
    
    func validate() -> Bool {
        guard !name.isEmpty else {
            self.isDisplayAlert.toggle()
            self.alertTitle = "Invalid"
            self.alertMessage = "Name cannot be empty"
            Log.proposeLogError("[ERROR] ==> Name cannot be empty")
            
            return false
        }
        
        return true
    }
}


