//
//  Util_LoadingState.swift
//  Yuta Picker
//
//  Created by Nguyen Phuc Loi on 16/03/2024.
//

import Foundation

enum LoadingState<T: Codable & Equatable>: Equatable {
    case none
    case loading
    case success(T)
    case error(Error)
                    
    static func == (lhs: LoadingState<T>, rhs: LoadingState<T>) -> Bool {
           switch (lhs, rhs) {
               case (.none, .none), (.loading, .loading):
                   return true
               case let (.success(lhsValue), .success(rhsValue)):
                   return lhsValue == rhsValue
               case let (.error(lhsError), .error(rhsError)):
                   return lhsError.localizedDescription == rhsError.localizedDescription
               default:
                   return false
           }
       }
}
