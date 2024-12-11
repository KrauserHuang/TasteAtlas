//
//  NetworkConfig.swift
//  TasteAtlas
//
//  Created by IT-MAC-02 on 2024/12/11.
//

import Foundation

protocol NetworkConfigurable {
    var baseURL: URL { get }
    var headers: [String: String] { get }
    var queryParameters: [String: String] { get }
}
