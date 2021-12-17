//
//  Extension+Data.swift
//  VetsDoctoriOSSwift
//
//  Created by Invision040-Raza on 03/03/2020.
//  Copyright © 2020 Invision040-Raza. All rights reserved.
//

import Foundation

extension Data {
    struct HexEncodingOptions: OptionSet {
        let rawValue: Int
        static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
    }

    func hexEncodedString(options: HexEncodingOptions = []) -> String {
        let format = options.contains(.upperCase) ? "%02hhX" : "%02hhx"
        return map { String(format: format, $0) }.joined()
    }
}
