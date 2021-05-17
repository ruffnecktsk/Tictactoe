//
//  GameFinishedScreenInitializer.swift
//  Tictactoe
//
//  Created by Mikhail Kirsanov on 17.05.2021.
//

import UIKit

class GameFinishedScreenInitializer {

    static func configure(winner: Player?, onPlayAgainTap: @escaping (() -> Void)) -> UIViewController {
        let vc = GameFinishedScreenVC()

        let presenter = GameFinishedScreenPresenter()
        presenter.winner = winner
        presenter.onPlayAgainTap = onPlayAgainTap
        vc.presenter = presenter
        presenter.view = vc

        return vc
    }
}
