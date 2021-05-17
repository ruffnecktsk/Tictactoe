//
//  BoardView.swift
//  Tictactoe
//
//  Created by Mikhail Kirsanov on 17.05.2021.
//

import UIKit

class GameButton: UIButton {

    let position: GameMovePosition

    init(position: GameMovePosition, frame: CGRect) {
        self.position = position

        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol BoardViewOutput: AnyObject {

    func didTapAt(_ position: GameMovePosition)
}

class BoardView: UIView {

    weak var output: BoardViewOutput?

    private var gridViewWidth: Int {
        return Int(self.frame.size.width) / 3
    }

    private var gridViewHeight: Int {
        return Int(self.frame.size.height) / 3
    }

    private var gridViews: [[GameButton]] = [[]]

    override func awakeFromNib() {
        super.awakeFromNib()
        initBoard()
    }

    private func initBoard() {
        gridViews = [[]]

        var yGridArray: [[GameButton]] = []
        for y in 0...2 {
            var xGridArray: [GameButton] = []
            for x in 0...2 {
                let button = GameButton(position: GameMovePosition(x: x, y: y),
                                        frame: CGRect(x: x * gridViewWidth, y: y * gridViewHeight, width: gridViewWidth, height: gridViewHeight))
                button.setTitleColor(.black, for: .normal)
                button.addTarget(self, action: #selector(buttonTap(_:)), for: .touchUpInside)
                button.layer.borderWidth = 1.0
                button.layer.borderColor = UIColor.black.withAlphaComponent(0.5).cgColor
                button.titleLabel?.font = UIFont.systemFont(ofSize: 50)
                self.addSubview(button)
                xGridArray.append(button)
            }
            yGridArray.append(xGridArray)
        }

        gridViews = yGridArray
    }

    @objc func buttonTap(_ button: GameButton) {
        output?.didTapAt(button.position)
    }

    func updateBoardWith(_ matrix: [[GameGridElement]]) {
        for (y, yValue) in matrix.enumerated() {
            for (x, xValue) in yValue.enumerated() {
                let button = gridViews[y][x]

                switch(xValue) {
                case .empty:
                    button.setTitle("", for: .normal)
                case .o:
                    button.setTitle("O", for: .normal)
                case .x:
                    button.setTitle("X", for: .normal)
                }
            }
        }
    }
}
