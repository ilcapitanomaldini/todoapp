//
//  NetworkHelper.swift
//  todoapp
//
//  Created by VM on 11/04/21.
//  Copyright © 2021 VM. All rights reserved.
//

import Foundation

typealias NetworkRequestCompletion = ((Data?, URLResponse?, Error?) -> Void)
class NetworkHelper {
    let session = URLSession.shared
    
    // MARK: Shared Instance
    static let shared = NetworkHelper()
    
    func get(_ urlString: String, completion: @escaping NetworkRequestCompletion) {
        guard let url = URL(string: urlString) else {
            print("Incorrect URL")
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        send(request: urlRequest, completion: completion)
    }
    
    func post(_ data: [String: Any], to urlString: String, completion: @escaping NetworkRequestCompletion) {
        guard let url = URL(string: urlString) else {
            print("Incorrect URL")
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        var requestData: Data
        do {
            requestData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            urlRequest.httpBody = requestData
        } catch {
            print("Error: cannot create JSON")
            return
        }
        send(request: urlRequest, completion: completion)
    }
    
    private func send(request: URLRequest, completion: @escaping NetworkRequestCompletion) {
        let task = session.dataTask(with: request, completionHandler: completion)
        task.resume()
    }
}




