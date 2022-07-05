//
//  ZipCode.swift
//  Wtest
//
//  Created by Yuri on 02/07/2022.
//

import Foundation

// MARK: - Struct
struct ZipCode {
    var zipCode: Int = 0
    var extensionZipCode: Int = 0
    var city: String = ""
    
    var fullZipCode: String {
        "\(zipCode)-\(extensionZipCode) \(city)"
    }
}

// MARK: - Coding Keys
extension ZipCode: Codable {
    enum CodingKeys: String, CodingKey {
        case zipCode = "num_cod_postal"
        case extensionZipCode = "ext_cod_postal"
        case city = "desig_postal"
    }
}

// MARK: - UserDefaults
extension ZipCode {
    static func getDownloadStatus() -> Bool {
        return UserDefaults.standard.bool(forKey: "hasFinished")
    }
    
    static func setDownloadStatus(finished: Bool) {
        UserDefaults.standard.set(finished, forKey: "hasFinished")
    }
}
