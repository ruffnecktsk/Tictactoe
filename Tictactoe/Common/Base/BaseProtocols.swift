//
//  BaseProtocols.swift
//  Tictactoe
//
//  Created by Mikhail Kirsanov on 17.05.2021.
//

import UIKit

protocol BasePresenterInput: AnyObject {

    func viewDidLoad()
    
}

protocol BasePresenterOutput: AnyObject {

    var navigationController: UINavigationController? { get }
    var vc: UIViewController? { get }
    func presentVC(_ vc: UIViewController)
    func dismiss()
}
