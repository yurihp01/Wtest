//
//  WingmanService.swift
//  Wtest
//
//  Created by Yuri on 02/07/2022.
//

import Foundation

protocol WingmanServiceProtocol {
    func getPostalCode(onComplete: @escaping (Result<String, Error>) -> Void)
}

class WingmanService {
    lazy var request: URLRequest = {
            let url = URL(string: "https://raw.githubusercontent.com/centraldedados/codigos_postais/master/data/codigos_postais.csv")!
            var request = URLRequest(url: url, timeoutInterval: 30)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "GET"
            return request
    }()
}

extension WingmanService: WingmanServiceProtocol {
    func getPostalCode(onComplete: @escaping (Result<String, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
              guard let data = data else {
//                  return onComplete(.failure(.invalidData))
                  return onComplete(.failure(error!))
              }
              
              guard let response = response as? HTTPURLResponse else {
//                  return onComplete(.failure(.badResponse))
                  return onComplete(.failure(error!))
              }
              
              guard response.statusCode == 200 else {
//                  return onComplete(.failure(.invalidStatusCode(statusCode: response.statusCode)))
                  return onComplete(.failure(error!))
              }
              
              guard error == nil else {
//                  return onComplete(.failure(.invalidData))
                  return onComplete(.failure(error!))
              }
            
            let file = String(data: data, encoding: .utf8)
            onComplete(.success(file!))
            
        }
        
        task.resume()
    }
}
