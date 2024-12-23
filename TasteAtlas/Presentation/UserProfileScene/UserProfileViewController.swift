//
//  UserProfileViewController.swift
//  TasteAtlas
//
//  Created by Tai Chin Huang on 2024/12/22.
//

import Combine
import UIKit

class UserProfileViewController: UIViewController {
    
    struct SettingsItem: Hashable {
        let id = UUID()
        let icon: String
        let title: String
        let accessory: SettingsAccessory
        
        enum SettingsAccessory: Hashable {
            case none
            case disclosure
            case toggle(isOn: Bool)
            case value(String)
        }
    }
    
    enum Section {
        case support
        case logout
        
        var title: String {
            switch self {
            case .support: return "支援相關"
            case .logout: return ""
            }
        }
    }
    
    private lazy var collectionView: UICollectionView = {
        var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        config.headerMode = .supplementary
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, SettingsItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, SettingsItem>
    private lazy var dataSource = makeDataSource()
    
    private let viewModel = AuthenticationViewModel()
    private var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        updateSnapshot()
        setupBindings()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.pinToSuperview()
    }
    
    private func setupBindings() {
        viewModel.$user
            .receive(on: DispatchQueue.main)
            .collect()
            .map { $0.last }
            .print()
            .sink { [weak self] user in
                guard let self else { return }
                if user == nil {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            .store(in: &subscriptions)
    }
}

extension UserProfileViewController {
    private func makeDataSource() -> DataSource {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, SettingsItem> { cell, indexPath, item in
            var contentConfiguration = UIListContentConfiguration.cell()
            contentConfiguration.text = item.title
            contentConfiguration.image = UIImage(systemName: item.icon)
            
            // Accessory 配置
            switch item.accessory {
            case .disclosure:
                cell.accessories = [.disclosureIndicator()]
            case .toggle(let isOn):
                let toggleAccessory = UICellAccessory.customView(
                    configuration: UICellAccessory.CustomViewConfiguration(
                        customView: {
                            let toggle = UISwitch()
                            toggle.isOn = isOn
                            toggle.addAction(
                                UIAction { action in
                                    guard let toggle = action.sender as? UISwitch else { return }
                                    print("Toggle switched: \(toggle.isOn)")
                                },
                                for: .valueChanged
                            )
                            return toggle
                        }(),
                        placement: .trailing()
                    )
                )
                cell.accessories = [toggleAccessory]
            case .value(let text):
                let label = UILabel()
                label.text = text
                label.textColor = .secondaryLabel
                cell.accessories = [.customView(configuration: .init(customView: label, placement: .trailing()))]
            case .none:
                cell.accessories = []
            }
            cell.contentConfiguration = contentConfiguration
        }
        let headerRegistration = UICollectionView.SupplementaryRegistration<UICollectionViewListCell>(elementKind: UICollectionView.elementKindSectionHeader) { [weak self] headerView, elementKind, indexPath in
            guard let section = self?.dataSource.sectionIdentifier(for: indexPath.section) else { return }
            
            var configuration = headerView.defaultContentConfiguration()
            configuration.text = section.title
            configuration.textProperties.font = .systemFont(ofSize: 13)
            configuration.textProperties.color = .secondaryLabel
            headerView.contentConfiguration = configuration
        }
        
        let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, item in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
        
        dataSource.supplementaryViewProvider = { collectionView, elementKind, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
        
        return dataSource
    }
    
    private func updateSnapshot(animated: Bool = false) {
        var snapshot = Snapshot()
        snapshot.appendSections([.support, .logout])
        
        snapshot.appendItems([
            SettingsItem(icon: "support", title: "Support", accessory: .disclosure),
        ], toSection: .support)
        snapshot.appendItems([
            SettingsItem(icon: "logout", title: "Logout", accessory: .none)
        ], toSection: .logout)
        
        dataSource.apply(snapshot, animatingDifferences: animated)
    }
}

// MARK: - UICollectionViewDelegate
extension UserProfileViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = dataSource.sectionIdentifier(for: indexPath.section) else { return }
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        
        switch section {
        case .support: return
        case .logout:
            showLogoutAlert()
        }
    }
    
    private func showLogoutAlert() {
        let alert = UIAlertController(title: "系統訊息", message: "確認要登出帳號?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel))
        alert.addAction(UIAlertAction(title: "確認", style: .default) { [weak self] _ in
            guard let self else { return }
            viewModel.signOut()
        })
        present(alert, animated: true)
    }
}
