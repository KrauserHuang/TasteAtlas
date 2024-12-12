//
//  Encodable.swift
//  TasteAtlas
//
//  Created by IT-MAC-02 on 2024/12/12.
//

import Foundation

extension Encodable {
    func toDictionary() throws -> [String: Any]? {
        let data = try JSONEncoder().encode(self)
        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        return json as? [String: Any]
    }
}
