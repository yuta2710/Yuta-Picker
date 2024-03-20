//
//  Cache_ColorAttributes.swift
//  Yuta Picker
//
//  Created by Nguyen Phuc Loi on 20/03/2024.
//

import Foundation
import CoreData

class ColorAttributesCacheData: ObservableObject {
    let container = NSPersistentContainer(name: "ColorAttributes")
    
    init() {
        
    }
    
    func save(context: NSManagedObjectContext) -> Void {
        do{
            try context.save()
            Log.proposeLogInfo("[SUCCESSFULLY]: Data saved")
        }catch {
            let nsError = error as NSError
            Log.proposeLogError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func saveColorToCache(){
        // 
    }
}
