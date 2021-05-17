//
//  GameFinishedScreenVC.swift
//  Tictactoe
//
//  Created by Mikhail Kirsanov on 17.05.2021.
//

import UIKit

class GameFinishedScreenVC: BaseViewController {

    var presenter: GameFinishedScreenPresenterInput?

    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var playAgainButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupAppearance()
        presenter?.viewDidLoad()
    }

    func setupAppearance() {
        playAgainButton.setTitle("gameFinishedScreen.playAgainButton.title".localized, for: .normal)
    }

    @IBAction func playAgainTap() {
        presenter?.playAgainTap()
    }
}

extension GameFinishedScreenVC: GameFinishedScreenPresenterOutput {

    func updateResultLabel(_ text: String) {
        resultLabel.text = text
    }
}
