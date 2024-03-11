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
    
    let db = Firestore.firestore()
    
    func createNewLibrary(data: Library, callback: @escaping () -> ()) {
        do {
            try db.collection("libraries").document(data.id).setData(from: data)
            callback()
        }catch let error {
            Log.proposeLogError("[ERROR] ==> \(error.localizedDescription)")
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
