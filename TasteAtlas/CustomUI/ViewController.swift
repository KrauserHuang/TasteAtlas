//
//  ViewController.swift
//  TasteAtlas
//
//  Created by Tai Chin Huang on 2024/12/8.
//

import Combine
import UIKit

/// A view controller subclass that takes a `UIView` and set up that view as its root view.
/// The given view has to be subscribing to `ViewModable` and `Interactable` protocols.
class ViewController<T>: UIViewController where T: ViewModable & Interactable {
    
    // MARK: - Public properties
    var interaction: AnyPublisher<T.Interaction, Never> { rootView.interaction }
    var viewModel: T.ViewModel { rootView.viewModel }
    
    // MARK: - Private properties
    private(set) var rootView: T
    
    // MARK: - Initializers
    /// Initializes a new `ViewController` with a given view.
    /// - Parameter viewModel: The view model for the view
    init(viewModel: T.ViewModel) {
        self.rootView = T()
        self.rootView.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = ""
    }
}
