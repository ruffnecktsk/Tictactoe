//
//  StartScreenInitializer.swift
//  Tictactoe
//
//  Created by Mikhail Kirsanov on 17.05.2021.
//

import UIKit

class StartScreenInitializer {

    static func configure() -> UIViewController {
        let vc = StartScreenVC()
        let presenter = StartScreenPresenter()

        vc.presenter = presenter
        presenter.view = vc

        let navController = BaseNavController(rootViewController: vc)
        return navController
    }
}
