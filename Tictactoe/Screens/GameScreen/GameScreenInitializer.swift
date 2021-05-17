//
//  GameScreenInitializer.swift
//  Tictactoe
//
//  Created by Mikhail Kirsanov on 17.05.2021.
//

import UIKit

class GameScreenInitializer {

    static func configure() -> UIViewController {
        let vc = GameScreenVC()

        let presenter = GameScreenPresenter()
        
        vc.presenter = presenter
        presenter.view = vc

        return vc
    }
}
