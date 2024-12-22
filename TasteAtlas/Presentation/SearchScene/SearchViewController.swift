//
//  SearchViewController.swift
//  TasteAtlas
//
//  Created by Tai Chin Huang on 2024/12/15.
//

import Combine
import UIKit

final class SearchViewController: UIViewController {
    
    // MARK: - Private properties
    private var subscriptions: Set<AnyCancellable> = []
    private lazy var searchController: SearchController = {
        let controller = SearchController()
        controller.searchBar.delegate = self
        return controller
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        navigationItem.searchController = searchController
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
}
