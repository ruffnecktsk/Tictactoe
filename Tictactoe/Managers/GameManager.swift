//
//  GameManager.swift
//  Tictactoe
//
//  Created by Mikhail Kirsanov on 17.05.2021.
//

import Foundation

class Player {

    enum PlayerType {
        case x
        case o
    }

    let type: PlayerType
    let isAI: Bool

    init(type: PlayerType, isAI: Bool) {
        self.type = type
        self.isAI = isAI
    }
}

struct GameMovePosition {
    let x: Int
    let y: Int
}

enum GameGridElement {
    case x
    case o
    case empty
}

protocol GameManagerOutput: AnyObject {

    func boardUpdated(_ matrix: [[GameGridElement]])
    func gameOver(_ winner: Player?)
}

class GameManager {

    weak var output: GameManagerOutput?

    private let players: [Player]
    private var currentPlayer: Player
    private var boardMatrix: [[GameGridElement]]
    private var gameOver: Bool

    init(output: GameManagerOutput?) {
        self.output = output
        
        let xPlayer = Player(type: .x, isAI: false)
        let oPlayer = Player(type: .o, isAI: true)

        players = [xPlayer, oPlayer]
        currentPlayer = xPlayer
        boardMatrix = [[GameGridElement](repeating: .empty, count: 3),
                       [GameGridElement](repeating: .empty, count: 3),
                       [GameGridElement](repeating: .empty, count: 3)]
        gameOver = false
        output?.boardUpdated(boardMatrix)

        if currentPlayer.isAI {
            makeAIMove()
        }
    }

    func tryMakeMove(position: GameMovePosition) {

        if gameOver {
            return
        }

        if currentPlayer.isAI {
            return
        }

        let element = boardMatrix[position.y][position.x]
        if element != .empty {
            return
        }

        applyMove(position)
    }

    private func switchToNextPlayer() {

        guard let newPlayer = players.first(where: { player in
            return player.isAI != currentPlayer.isAI
        }) else {
            return
        }

        currentPlayer = newPlayer

        if currentPlayer.isAI {
            makeAIMove()
        }
    }

    private func makeAIMove() {

        if gameOver {
            return
        }

        var aiMove: GameMovePosition?

        //looking for ai lines to close
        for (y, yValue) in boardMatrix.enumerated() {
            if aiMove != nil {
                break
            }
            for (x, xValue) in yValue.enumerated() {
                //if found empty space for move
                if xValue == .empty {
                    if isMoveWillCloseLine(GameMovePosition(x: x, y: y)) {
                        aiMove = GameMovePosition(x: x, y: y)
                        break
                    }
                }
            }
        }

        if let aiMove = aiMove {
            print("Found close move")
            applyMove(aiMove)
            return
        } else {
            print("Nothing to close")
        }

        //looking for line to broke
        for (y, yValue) in boardMatrix.enumerated() {
            if aiMove != nil {
                break
            }

            for (x, xValue) in yValue.enumerated() {
                //if found empty space for move
                if xValue == .empty {
                    if isMoveWillBrokeLine(GameMovePosition(x: x, y: y)) {
                        aiMove = GameMovePosition(x: x, y: y)
                        break
                    }
                }
            }
        }

        if let aiMove = aiMove {
            print("Found broke move")
            applyMove(aiMove)
            return
        } else {
            print("Nothing to broke")
        }

        //looking for ai lines to continue
        for (y, yValue) in boardMatrix.enumerated() {
            if aiMove != nil {
                break
            }
            for (x, xValue) in yValue.enumerated() {
                //if found empty space for move
                if xValue == .empty {
                    if isMoveWillContinueLine(GameMovePosition(x: x, y: y)) {
                        aiMove = GameMovePosition(x: x, y: y)
                        break
                    }
                }
            }
        }

        if let aiMove = aiMove {
            print("Found continue move")
            applyMove(aiMove)
            return
        } else {
            print("Nothing to continue")
        }

        //making random move
        var availableMoves: [GameMovePosition] = []
        for (y, yValue) in boardMatrix.enumerated() {
            for (x, xValue) in yValue.enumerated() {
                //if found empty space for move
                if xValue == .empty {
                    availableMoves.append(GameMovePosition(x: x, y: y))
                }
            }
        }
        if let randomMove = availableMoves.randomElement() {
            applyMove(randomMove)
        }
    }

    private func applyMove(_ position: GameMovePosition) {
        boardMatrix[position.y][position.x] = currentPlayer.type == .o ? .o : .x
        output?.boardUpdated(boardMatrix)

        let (winner, isGameOver) = checkIsGameOver()
        if !isGameOver {
            switchToNextPlayer()
        } else {
            gameOver = true
            output?.gameOver(winner)
        }
    }

    private func checkIsGameOver() -> (winner: Player?, gameOver: Bool) {

        var gameOver = false

        //horizontal
        for y in boardMatrix {
            let uniqueElements = Set(y)
            if uniqueElements.count <= 1 && uniqueElements.first != .empty {
                gameOver = true
                break
            }
        }

        //vertical
        if (boardMatrix[0][0] == boardMatrix[1][0] && boardMatrix[0][0] == boardMatrix[2][0] && boardMatrix[0][0] != .empty) ||
            (boardMatrix[0][1] == boardMatrix[1][1] && boardMatrix[0][1] == boardMatrix[2][1] && boardMatrix[0][1] != .empty) ||
            (boardMatrix[0][2] == boardMatrix[1][2] && boardMatrix[0][2] == boardMatrix[2][2] && boardMatrix[0][2] != .empty) {
            gameOver = true
        }

        //diagonal
        if (boardMatrix[0][0] == boardMatrix[1][1] && boardMatrix[0][0] == boardMatrix[2][2] && boardMatrix[0][0] != .empty) ||
            (boardMatrix[0][2] == boardMatrix[1][1] && boardMatrix[0][2] == boardMatrix[2][0] && boardMatrix[0][2] != .empty) {
            gameOver = true
        }

        if gameOver {
            return (currentPlayer, gameOver)
        } else {
            //check if no empty space available
            var foundEmptySpace = false

            for y in boardMatrix {
                for x in y {
                    if x == .empty {
                        foundEmptySpace = true
                        break
                    }
                }
            }
            if !foundEmptySpace {
                return (nil, true)
            }

            return (nil, false)
        }
    }

    private func isMoveWillBrokeLine(_ position: GameMovePosition) -> Bool {

        var willBroke: Bool = false

        let availableX = [0,1,2].filter { value in
            return value != position.x
        }
        let availableY = [0,1,2].filter { value in
            return value != position.y
        }

        // horizontal
        if ((boardMatrix[position.y][availableX[0]] == .o && currentPlayer.type == .x) && (boardMatrix[position.y][availableX[1]] == .o && currentPlayer.type == .x)) ||
            ((boardMatrix[position.y][availableX[0]] == .x && currentPlayer.type == .o) && (boardMatrix[position.y][availableX[1]] == .x && currentPlayer.type == .o)) {
            willBroke = true
        }

        // vertical
        if ((boardMatrix[availableY[0]][position.x] == .o && currentPlayer.type == .x) && (boardMatrix[availableY[1]][position.x] == .o && currentPlayer.type == .x)) ||
            ((boardMatrix[availableY[0]][position.x] == .x && currentPlayer.type == .o) && (boardMatrix[availableY[1]][position.x] == .x && currentPlayer.type == .o)) {
            willBroke = true
        }

        // diagonal
        let ordinalMoveNumber =  (position.y * 3) + position.x + 1
        if ordinalMoveNumber % 2 > 0 { //can check diagonal only for odd moves

            let positionsToCheckForFirstDiag = [GameMovePosition(x: 0, y: 0), GameMovePosition(x: 1, y: 1), GameMovePosition(x: 2, y: 2)].filter { pos in
                return pos.x != position.x || pos.y != position.y
            }
            let positionsToCheckForSecondDiag = [GameMovePosition(x: 2, y: 0), GameMovePosition(x: 1, y: 1), GameMovePosition(x: 0, y: 2)].filter { pos in
                return pos.x != position.x || pos.y != position.y
            }

            if positionsToCheckForFirstDiag.count < 3 { //if move exists on that diagonal
                if ((boardMatrix[positionsToCheckForFirstDiag[0].y][positionsToCheckForFirstDiag[0].x] == .o && currentPlayer.type == .x) &&
                        (boardMatrix[positionsToCheckForFirstDiag[1].y][positionsToCheckForFirstDiag[1].x] == .o && currentPlayer.type == .x) ||
                        (boardMatrix[positionsToCheckForFirstDiag[0].y][positionsToCheckForFirstDiag[0].x] == .x && currentPlayer.type == .o) &&
                        (boardMatrix[positionsToCheckForFirstDiag[1].y][positionsToCheckForFirstDiag[1].x] == .x && currentPlayer.type == .o)) {
                    willBroke = true
                }
            }

            if positionsToCheckForSecondDiag.count < 3 { //if move exists on that diagonal
                if ((boardMatrix[positionsToCheckForSecondDiag[0].y][positionsToCheckForSecondDiag[0].x] == .o && currentPlayer.type == .x) &&
                        (boardMatrix[positionsToCheckForSecondDiag[1].y][positionsToCheckForSecondDiag[1].x] == .o && currentPlayer.type == .x) ||
                        (boardMatrix[positionsToCheckForSecondDiag[0].y][positionsToCheckForSecondDiag[0].x] == .x && currentPlayer.type == .o) &&
                        (boardMatrix[positionsToCheckForSecondDiag[1].y][positionsToCheckForSecondDiag[1].x] == .x && currentPlayer.type == .o)) {
                    willBroke = true
                }
            }
        }

        return willBroke
    }

    private func isMoveWillCloseLine(_ position: GameMovePosition) -> Bool {

        var willClose: Bool = false

        let availableX = [0,1,2].filter { value in
            return value != position.x
        }
        let availableY = [0,1,2].filter { value in
            return value != position.y
        }

        // horizontal
        if ((boardMatrix[position.y][availableX[0]] == .o && currentPlayer.type == .o) && (boardMatrix[position.y][availableX[1]] == .o && currentPlayer.type == .o)) ||
            ((boardMatrix[position.y][availableX[0]] == .x && currentPlayer.type == .x) && (boardMatrix[position.y][availableX[1]] == .x && currentPlayer.type == .x)) {
            willClose = true
        }

        // vertical
        if ((boardMatrix[availableY[0]][position.x] == .o && currentPlayer.type == .o) && (boardMatrix[availableY[1]][position.x] == .o && currentPlayer.type == .o)) ||
            ((boardMatrix[availableY[0]][position.x] == .x && currentPlayer.type == .x) && (boardMatrix[availableY[1]][position.x] == .x && currentPlayer.type == .x)) {
            willClose = true
        }

        // diagonal
        let ordinalMoveNumber =  (position.y * 3) + position.x + 1
        if ordinalMoveNumber % 2 > 0 { //can check diagonal only for odd moves

            let positionsToCheckForFirstDiag = [GameMovePosition(x: 0, y: 0), GameMovePosition(x: 1, y: 1), GameMovePosition(x: 2, y: 2)].filter { pos in
                return pos.x != position.x || pos.y != position.y
            }
            let positionsToCheckForSecondDiag = [GameMovePosition(x: 2, y: 0), GameMovePosition(x: 1, y: 1), GameMovePosition(x: 0, y: 2)].filter { pos in
                return pos.x != position.x || pos.y != position.y
            }

            if positionsToCheckForFirstDiag.count < 3 { //if move exists on that diagonal
                if ((boardMatrix[positionsToCheckForFirstDiag[0].y][positionsToCheckForFirstDiag[0].x] == .o && currentPlayer.type == .o) &&
                        (boardMatrix[positionsToCheckForFirstDiag[1].y][positionsToCheckForFirstDiag[1].x] == .o && currentPlayer.type == .o) ||
                        (boardMatrix[positionsToCheckForFirstDiag[0].y][positionsToCheckForFirstDiag[0].x] == .x && currentPlayer.type == .x) &&
                        (boardMatrix[positionsToCheckForFirstDiag[1].y][positionsToCheckForFirstDiag[1].x] == .x && currentPlayer.type == .x)) {
                    willClose = true
                }
            }

            if positionsToCheckForSecondDiag.count < 3 { //if move exists on that diagonal
                if ((boardMatrix[positionsToCheckForSecondDiag[0].y][positionsToCheckForSecondDiag[0].x] == .o && currentPlayer.type == .o) &&
                        (boardMatrix[positionsToCheckForSecondDiag[1].y][positionsToCheckForSecondDiag[1].x] == .o && currentPlayer.type == .o) ||
                        (boardMatrix[positionsToCheckForSecondDiag[0].y][positionsToCheckForSecondDiag[0].x] == .x && currentPlayer.type == .x) &&
                        (boardMatrix[positionsToCheckForSecondDiag[1].y][positionsToCheckForSecondDiag[1].x] == .x && currentPlayer.type == .x)) {
                    willClose = true
                }
            }
        }

        return willClose
    }

    private func isMoveWillContinueLine(_ position: GameMovePosition) -> Bool {

        var willContinue: Bool = false

        let availableX = [0,1,2].filter { value in
            return value != position.x
        }
        let availableY = [0,1,2].filter { value in
            return value != position.y
        }

        // horizontal
        // checking if opponent already did move at line
        if (boardMatrix[position.y][availableX[0]] != .x && currentPlayer.type == .o) && (boardMatrix[position.y][availableX[1]] != .x && currentPlayer.type == .o) ||
            (boardMatrix[position.y][availableX[0]] != .o && currentPlayer.type == .x) && (boardMatrix[position.y][availableX[1]] != .o && currentPlayer.type == .x) {
            // checking if current player already did moves at line
            if ((boardMatrix[position.y][availableX[0]] == .o && currentPlayer.type == .o) || (boardMatrix[position.y][availableX[1]] == .o && currentPlayer.type == .o)) ||
                ((boardMatrix[position.y][availableX[0]] == .x && currentPlayer.type == .x) || (boardMatrix[position.y][availableX[1]] == .x && currentPlayer.type == .x)) {
                willContinue = true
            }
        }

        // vertical
        // checking if opponent already did move at line
        if (boardMatrix[availableY[0]][position.x] != .x && currentPlayer.type == .o) && (boardMatrix[availableY[1]][position.x] != .x && currentPlayer.type == .o) ||
            (boardMatrix[availableY[0]][position.x] != .o && currentPlayer.type == .x) && (boardMatrix[availableY[1]][position.x] != .o && currentPlayer.type == .x) {
            // checking if current player already did moves at line
            if ((boardMatrix[availableY[0]][position.x] == .o && currentPlayer.type == .o) || (boardMatrix[availableY[1]][position.x] == .o && currentPlayer.type == .o)) ||
                ((boardMatrix[availableY[0]][position.x] == .x && currentPlayer.type == .x) || (boardMatrix[availableY[1]][position.x] == .x && currentPlayer.type == .x)) {
                willContinue = true
            }
        }

        return willContinue
    }
}
