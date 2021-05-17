//
//  GameFinishedScreenPresenter.swift
//  Tictactoe
//
//  Created by Mikhail Kirsanov on 17.05.2021.
//

import Foundation

protocol GameFinishedScreenPresenterInput: BasePresenterInput {

    func viewDidLoad()
    func playAgainTap()
}

protocol GameFinishedScreenPresenterOutput: BasePresenterOutput {

    func updateResultLabel(_ text: String)
}

class GameFinishedScreenPresenter {

    var view: GameFinishedScreenPresenterOutput?
    var winner: Player?
    var onPlayAgainTap: (() -> Void)?
}

extension GameFinishedScreenPresenter: GameFinishedScreenPresenterInput {

    func viewDidLoad() {
        guard let winner = winner else {
            view?.updateResultLabel("gameFinishedScreen.resultLabel.tie".localized)
            return
        }

        if winner.isAI {
            view?.updateResultLabel("gameFinishedScreen.resultLabel.aiWon".localized)
        } else {
            view?.updateResultLabel("gameFinishedScreen.resultLabel.youWon".localized)
        }
    }

    func playAgainTap() {
        view?.dismiss()
        onPlayAgainTap?()
    }
}
