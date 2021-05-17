//
//  StartScreenVC.swift
//  Tictactoe
//
//  Created by Mikhail Kirsanov on 17.05.2021.
//

import UIKit

class StartScreenVC: BaseViewController {
    
    var presenter: StartScreenPresenterInput?

    @IBOutlet weak var startNewGameButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupAppearance()
        presenter?.viewDidLoad()
    }

    func setupAppearance() {
        self.title = "startScreen.navigationBar.title".localized
        startNewGameButton.setTitle("startScreen.startNewGameButton.title".localized, for: .normal)
    }

    @IBAction func startNewGameButtonTap() {
        presenter?.startNewGameButtonTap()
    }
}

extension StartScreenVC: StartScreenPresenterOutput {

}
