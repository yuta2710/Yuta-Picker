//
//  ViewModel_ColorAttributes.swift
//  Yuta Picker
//
//  Created by Nguyen Phuc Loi on 05/03/2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

class ColorAttributesViewViewModel: ObservableObject {
    @Published var selectedColor: Color = Color.black
    let db = Firestore.firestore()
    
//    init() {
//        authenticationContextProvider.fetchCurrentAccount()
//    }
    
    func saveUserPalette(account: Account, paletteData: String, callback: @escaping () -> ()) {
        do {
            guard let uId = Auth.auth().currentUser?.uid else {
                return
            }
            print("[PALETTE DATA]: \(paletteData)")
            db.collection("accounts").document(account.id).updateData(["paletteIds": FieldValue.arrayUnion([paletteData])]) { error in
                Log.proposeLogInfo("[SUCCESS UPDATED DOCUMENT - save user palette]")
            }
            
            
        }catch let error {
            Log.proposeLogError("[UNABLE TO UPDATE DOCUMENT - save user palette]: \(error.localizedDescription)")
        }
    }
    
    func savePaletteToLibrary(libraryId: String, callback: @escaping () -> ()) {
        
    }
}
