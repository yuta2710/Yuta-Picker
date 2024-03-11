//
//  Context_SameColourProvider.swift
//  Yuta Picker
//
//  Created by Nguyen Phuc Loi on 09/03/2024.
//

import Foundation
import SwiftyBeaver

let log = SwiftyBeaver.self

class ColourInfoContextProvider: ObservableObject {
    @Published var currentColorDetails: ColorAttributes? = nil
    
    func getJsonByQuery(queries: [String: String]) {
        let queryString: String = queries.map { key, value in
            "\(key)=\(value)"
        }.joined(separator: "&")
        Log.proposeLogInfo("[QUERY STRING]: \(queryString)")
        
        guard let url = URL(string: "https://www.thecolorapi.com/id?\(queryString)") else {
            Log.proposeLogError("Missing URL")
            fatalError("Missing URL")
        }
        
        let urlRequest = URLRequest(url: url)

        URLSession.shared.dataTask(with: urlRequest) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            if let error = error {
                Log.proposeLogError("Hahahahah: \(error.localizedDescription)")
                return
            }
            
            guard let data = data, let response = response as? HTTPURLResponse else {
                Log.proposeLogError("Invalid data or response")
                return
            }
            
            guard response.statusCode == 200 else {
                Log.proposeLogError("Non-200 status code: \(response.statusCode)")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let decodedData: ColorAttributes = try decoder.decode(ColorAttributes.self, from: data)
                print("Hahaha \(decodedData._embedded)")
                Log.proposeLogInfo("[DECODED COLOR]: \(decodedData)")
    
                DispatchQueue.main.async {
                    self.currentColorDetails = decodedData
                }
            }catch let error {
                Log.proposeLogError(error.localizedDescription)
            }
        }
        .resume()
    }
}
