//
//  ZipCodeServiceProtocol.swift
//  Wtest
//
//  Created by Yuri on 02/07/2022.
//

import Foundation

// MARK: - Protocol
protocol ZipCodeServiceProtocol {
    func getZipCode(onComplete: @escaping (Result<String, ZipCodeError>) -> Void)
}

// MARK: - Class
class ZipCodeService {
    lazy var request: URLRequest = {
            let url = URL(string: "https://raw.githubusercontent.com/centraldedados/codigos_postais/master/data/codigos_postais.csv")!
            var request = URLRequest(url: url, timeoutInterval: 30)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "GET"
            return request
    }()
}

// MARK: - Extension ZipCodeServiceProtocol
extension ZipCodeService: ZipCodeServiceProtocol {
    func getZipCode(onComplete: @escaping (Result<String, ZipCodeError>) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
              guard let data = data else {
                  return onComplete(.failure(.invalidData))
              }
              
              guard let response = response as? HTTPURLResponse else {
                  return onComplete(.failure(.badResponse))
              }
              
              guard response.statusCode == 200 else {
                  return onComplete(.failure(.invalidStatusCode(code: response.statusCode)))
              }
              
              guard error == nil else {
                  return onComplete(.failure(.internetConnection))
              }
            
            let file = String(data: data, encoding: .utf8) ?? ""
            onComplete(.success(file))
        }
        
        task.resume()
    }
}
