//
//  ZipCodeError.swift
//  Wtest
//
//  Created by Yuri on 05/07/2022.
//

import Foundation

// MARK: - Enum
enum ZipCodeError: Error {
    case internetConnection
    case closedDownloading
    case invalidData
    case invalidStatusCode(code: Int)
    case badResponse
}

// MARK: - Extension
extension ZipCodeError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .internetConnection:
            return "Lost internet connection"
        case .closedDownloading:
            return "App closed while downloading zip codes"
        case .invalidData:
            return "Invalid data type"
        case .invalidStatusCode(let code):
            return "Status code: \(code)"
        case .badResponse:
            return "Invalid Response"
        }
    }
}
