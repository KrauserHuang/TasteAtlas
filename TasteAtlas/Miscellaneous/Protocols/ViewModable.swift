//
//  ViewModable.swift
//  TasteAtlas
//
//  Created by IT-MAC-02 on 2024/12/10.
//

import UIKit

/// A protocol used in views to make them implement view models
protocol ViewModable where Self: UIView {
    /// The associated view model type
    associatedtype ViewModel
    
    /// A view model object for the view
    var viewModel: ViewModel! { get set }
    
    /// bind the view model to the view and renders all the view model values in the view
    /// - Parameter viewModel: The given view model to render
    func setViewModel(_ viewModel: ViewModel)
}
