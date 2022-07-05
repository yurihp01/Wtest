//
//  ZipCodeServiceMock.swift
//  WtestTests
//
//  Created by Yuri on 05/07/2022.
//

import XCTest
@testable import Wtest

enum Status {
    case success
    case error
}

enum ZipCodeError: Error {
    case internetConnection
    case closedDownloading
}

extension ZipCodeError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .internetConnection:
            return "Lost internet connection"
        case .closedDownloading:
            return "App closed while downloading zip codes" 
        }
    }
}

class ZipCodeServiceMock: ZipCodeServiceProtocol {
    
    let status: Status
    
    init (status: Status) {
        self.status = status
    }
    
    func getPostalCode(onComplete: @escaping (Result<String, Error>) -> Void) {
        switch status {
        case .success:
            onComplete(.success("CSV"))
        case .error:
            onComplete(.failure(ZipCodeError.internetConnection))
        }
    }
}
