//
//  SpinnerFooterView.swift
//  TasteAtlas
//
//  Created by IT-MAC-02 on 2024/12/10.
//

import UIKit

class SpinnerFooterView: UICollectionReusableView {
    
    // MARK: - Private Properties
    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(useAutoLayout: true)
        spinner.color = .white
        return spinner
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(spinner)
        spinner.startAnimating()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}