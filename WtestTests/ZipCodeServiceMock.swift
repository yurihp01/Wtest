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

class ZipCodeServiceMock: ZipCodeServiceProtocol {
    
    let status: Status
    
    init (status: Status) {
        self.status = status
    }
    
    func getZipCode(onComplete: @escaping (Result<String, ZipCodeError>) -> Void) {
        switch status {
        case .success:
            onComplete(.success("CSV"))
        case .error:
            onComplete(.failure(ZipCodeError.internetConnection))
        }
    }
}
