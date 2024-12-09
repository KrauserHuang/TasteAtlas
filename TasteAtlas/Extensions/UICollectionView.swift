//
//  UICollectionView.swift
//  TasteAtlas
//
//  Created by Tai Chin Huang on 2024/12/8.
//

import UIKit

extension UICollectionView {
    
    static let header = UICollectionView.elementKindSectionHeader
    static let footer = UICollectionView.elementKindSectionFooter
    
    func register<T: UICollectionViewCell>(cell: T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    func register<T: UICollectionViewListCell>(cell: T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    func register<T: UICollectionReusableView>(header: T.Type) {
        register(T.self, forSupplementaryViewOfKind: UICollectionView.header, withReuseIdentifier: T.reuseIdentifier)
    }
    
    func register<T: UICollectionReusableView>(footer: T.Type) {
        register(T.self, forSupplementaryViewOfKind: UICollectionView.footer, withReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueCell<T: UICollectionViewCell>(at indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else { fatalError("Unable to dequeue cell💥💥💥💥💥") }
        return cell
    }
    
    func dequeueHeaderView<T: UICollectionReusableView>(_ view: T.Type, at indexPath: IndexPath) -> UICollectionReusableView {
        dequeueReusableSupplementaryView(ofKind: UICollectionView.header, withReuseIdentifier: view.reuseIdentifier, for: indexPath)
    }
    
    func dequeueFooterView<T: UICollectionReusableView>(_ view: T.Type, at indexPath: IndexPath) -> UICollectionReusableView {
        dequeueReusableSupplementaryView(ofKind: UICollectionView.footer, withReuseIdentifier: view.reuseIdentifier, for: indexPath)
    }
}
