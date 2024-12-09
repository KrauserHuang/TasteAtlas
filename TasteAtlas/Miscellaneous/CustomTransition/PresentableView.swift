//
//  PresentableView.swift
//  TasteAtlas
//
//  Created by IT-MAC-02 on 2024/12/9.
//

import UIKit

/// A protocol that makes a view controller presentable
protocol PresentableView: UIViewController {
    /// The transition delegate object for the presentable view
    var transitionManager: UIViewControllerTransitioningDelegate? { get }
    /// The final receiving frame of the custom transition
    var receivingFrame: CGRect? { get }
}
