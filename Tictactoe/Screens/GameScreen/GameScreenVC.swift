//
//  GameScreenVC.swift
//  Tictactoe
//
//  Created by Mikhail Kirsanov on 17.05.2021.
//

import UIKit

class GameScreenVC: BaseViewController {

    var presenter: GameScreenPresenterInput?

    @IBOutlet weak var boardView: BoardView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupAppearance()
        setupBoard()
        presenter?.viewDidLoad()
    }

    func setupAppearance() {
        self.title = "gameScreen.navigationBar.title".localized
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "gameScreen.navigationBar.backButton.title".localized,
                                                                                              style: .plain,
                                                                                              target: nil,
                                                                                              action: nil)
    }

    func setupBoard() {
        boardView.output = self
    }
}

extension GameScreenVC: GameScreenPresenterOutput {

    func updateBoardWith(_ matrix: [[GameGridElement]]) {
        boardView.updateBoardWith(matrix)
    }
}

extension GameScreenVC: BoardViewOutput {

    func didTapAt(_ position: GameMovePosition) {
        presenter?.didTapAt(position: position)
    }
}
