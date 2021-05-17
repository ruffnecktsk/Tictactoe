//
//  BaseViewController.swift
//  Tictactoe
//
//  Created by Mikhail Kirsanov on 17.05.2021.
//

import UIKit

class BaseViewController: UIViewController {

    var vc: UIViewController? {
        return self
    }
}

extension BaseViewController: BasePresenterOutput {

    func presentVC(_ vc: UIViewController) {
        self.present(vc, animated: true, completion: nil)
    }

    func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
}
