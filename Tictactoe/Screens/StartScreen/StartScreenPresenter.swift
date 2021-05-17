//
//  StartScreenPresenter.swift
//  Tictactoe
//
//  Created by Mikhail Kirsanov on 17.05.2021.
//

import Foundation

protocol StartScreenPresenterInput: BasePresenterInput {

    func viewDidLoad()
    func startNewGameButtonTap()
}

protocol StartScreenPresenterOutput: BasePresenterOutput {

}

class StartScreenPresenter {
    
    var view: StartScreenPresenterOutput?
}

extension StartScreenPresenter: StartScreenPresenterInput {

    func viewDidLoad() {

    }

    func startNewGameButtonTap() {
        let gameScreenVC = GameScreenInitializer.configure()
        view?.navigationController?.pushViewController(gameScreenVC, animated: true)
    }
}
