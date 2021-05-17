//
//  GameScreenPresenter.swift
//  Tictactoe
//
//  Created by Mikhail Kirsanov on 17.05.2021.
//

import Foundation

protocol GameScreenPresenterInput: BasePresenterInput {

    func viewDidLoad()
    func didTapAt(position: GameMovePosition)
}

protocol GameScreenPresenterOutput: BasePresenterOutput {

    func updateBoardWith(_ matrix: [[GameGridElement]])
}

class GameScreenPresenter {

    var view: GameScreenPresenterOutput?
    var gameManager: GameManager?
}

extension GameScreenPresenter: GameScreenPresenterInput {

    func viewDidLoad() {

        gameManager = GameManager(output: self)
    }

    func didTapAt(position: GameMovePosition) {

        gameManager?.tryMakeMove(position: position)
    }
}

extension GameScreenPresenter: GameManagerOutput {

    func boardUpdated(_ matrix: [[GameGridElement]]) {
        view?.updateBoardWith(matrix)
    }

    func gameOver(_ winner: Player?) {
        let gameFinishedVC = GameFinishedScreenInitializer.configure(winner: winner, onPlayAgainTap: {
            self.viewDidLoad()
        })

        view?.presentVC(gameFinishedVC)
    }
}
