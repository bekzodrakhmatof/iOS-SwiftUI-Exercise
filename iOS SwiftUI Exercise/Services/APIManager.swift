//
//  APIManager.swift
//  iOS SwiftUI Exercise
//
//  Created by Bekzod Rakhmatov on 19/12/23.
//

import Foundation

fileprivate let baseUrl = "https://v2.dev.api.legitmark.com/api/"

class APIManager {
    
    static let shared = APIManager()
    
    func getBrands(completion: @escaping(GetBrands?, String?) -> ()) {
        var request = URLRequest(
            url: URL(string: "\(baseUrl)brands")!,
            timeoutInterval: .infinity)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            print(data?.prettyPrintedJSONString ?? "")
            guard let data = data else {
                completion(nil, error?.localizedDescription)
                return
            }
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(GetBrands.self, from: data)
                completion(response, nil)
            } catch {
                completion(nil, error.localizedDescription)
            }
        }
        task.resume()
    }
    
    func getModel(brandUuid: String, completion: @escaping(GetModels?, String?) -> ()) {
        var request = URLRequest(
            url: URL(string: "\(baseUrl)brands/\(brandUuid)/models")!,
            timeoutInterval: .infinity)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            print(data?.prettyPrintedJSONString ?? "")
            guard let data = data else {
                completion(nil, error?.localizedDescription)
                return
            }
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(GetModels.self, from: data)
                completion(response, nil)
            } catch {
                completion(nil, error.localizedDescription)
            }
        }
        task.resume()
    }
}

extension Data {
    
    var prettyPrintedJSONString: NSString? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
        return prettyPrintedString
    }
}
