//
//  AccountController.swift
//  TasteAtlas
//
//  Created by IT-MAC-02 on 2024/12/10.
//

import UIKit

final class AccountController: UIViewController {
    
    private var interactor: AccountInteractor
    
    init(interactor: AccountInteractor) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
