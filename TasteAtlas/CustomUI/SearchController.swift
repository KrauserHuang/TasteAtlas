//
//  SearchController.swift
//  TasteAtlas
//
//  Created by IT-MAC-02 on 2024/12/10.
//

import UIKit

class SearchController: UISearchController {
    
    // MARK: - Public properties
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.searchTextField.keyboardAppearance = .dark
        searchBar.searchTextField.backgroundColor = .darkGray
        searchBar.searchTextField.textColor = .white
        obscuresBackgroundDuringPresentation = false
        searchBar.searchTextField.font = .systemFont(ofSize: 14)
        searchBar.searchBarStyle = .prominent
        searchBar.tintColor = .black
//        searchBar.barTintColor = .black
        searchBar.placeholder = "Search..."
//        searchBar.searchTextField.clearButtonMode = .whileEditing
        searchBar.isTranslucent = false
        searchBar.isOpaque = true
    }
}
