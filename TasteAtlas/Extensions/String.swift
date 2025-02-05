//
//  String.swift
//  TasteAtlas
//
//  Created by IT-MAC-02 on 2025/2/5.
//

import Foundation

extension String {
    func convertToFlag() -> String {
        let base: UInt32 = 127397
        var flag = ""
        for unicode in self.uppercased().unicodeScalars {
            if let scalar = UnicodeScalar(base + unicode.value) {
                flag.append(String(scalar))
            }
        }
        return flag
    }
}
