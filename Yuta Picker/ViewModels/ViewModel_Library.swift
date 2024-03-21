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
            let docRef = db.collection("libraries").document(libraryId)

            // Fetch the current array from Firestore
            docRef.getDocument { (document, error) in
                guard let document = document, document.exists else {
                    print("Document does not exist")
                    return
                }
                
                // Extract the current array from the document
                var currentColorsArray = document.data()?["colors"] as? [String] ?? []
                
                for hexValue in currentColorsArray {
                    if hexValue == hexData {
                        self.isDisplayAlert.toggle()
                        self.alertTitle = "Hell nah"
                        self.alertMessage = "Color has already exist"
                        
                        Log.proposeLogError("This hex data has already exist")
                        
                        return
                    }
                }

                // Insert the new element at the first position
                currentColorsArray.insert(hexData, at: 0)

                // Update the document with the modified array
                docRef.updateData([
                    "colors": currentColorsArray,
                    "modifiedAt": Date().timeIntervalSince1970
                ]) { error in
                    if let error = error {
                        print("Error updating document: \(error)")
                    } else {
                        print("Document successfully updated")
                    }
                }
                
                callback()
            }
            
        }catch let error {
            Log.proposeLogError("\(error.localizedDescription)")
        }
    }
    
    func deleteCurrentLibrary(libId: String, callback: @escaping () -> ()) {
        do{
            try db.collection("libraries").document(libId).delete { error in
                if let error = error {
                    
                }else {
                    Log.proposeLogInfo("This is scumbag")
                    callback()
                }
            }
            
        }catch {
            
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


