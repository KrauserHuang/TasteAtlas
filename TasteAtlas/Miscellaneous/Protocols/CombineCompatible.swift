//
//  CombineCompatible.swift
//  TasteAtlas
//
//  Created by Tai Chin Huang on 2024/12/15.
//

import UIKit

protocol CombineCompatible {}

extension CombineCompatible where Self: UIControl {
    func publisher(for event: UIControl.Event) -> UIControl.Publisher<UIControl> {
        .init(output: self, event: event)
    }
}
