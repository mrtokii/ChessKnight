//
//  ViewController.swift
//  ChessKnight
//
//  Created by Виталий Сальников on 25/12/2018.
//  Copyright © 2018 Виталий Сальников. All rights reserved.
//

import UIKit
import SpriteKit

class ViewController: UIViewController {

    @IBOutlet weak var chessView: ChessBoardView!
    
    var figures = [CGPoint(x: 3, y: 4)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chessView.figures = self.figures
        fillMoves()
        chessView.update()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action:  #selector (self.chessBoardTapped(_:)))
        self.chessView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func chessBoardTapped(_ sender:UITapGestureRecognizer){
        if let location = chessView.touchedCell(in: sender.location(in: chessView) ) {
            print("tap \(location)")
            
            self.figures = [location]
            chessView.figures = self.figures
            chessView.update()
            
            fillMoves()
            
        }
        
    }
    
    func fillMoves() {
        self.figures = fillingMoves(from: self.figures.first!)
        print(self.figures.count)
    }
    
    func fillingMoves(from start: CGPoint) -> [CGPoint] {
        
        // [x][y]
        var field = Array(repeating: Array(repeating: 0, count: 8), count: 8)
        var currentCell = (x: Int(start.x), y: Int(start.y))
        var path: [(x: Int, y: Int)] = [currentCell]
        
        // valid moves list from the given cell
        func validMoves( from: (x: Int, y: Int), on field: [[Int]] ) -> [(x: Int, y: Int)] {
            var validOptions: [(x: Int, y: Int)] = []
            let x = from.x
            let y = from.y
            let possibleOptions = [
                (x - 1, y - 2),
                (x + 1, y - 2),
                (x - 2, y - 1),
                (x + 2, y - 1),
                (x - 2, y + 1),
                (x + 2, y + 1),
                (x - 1, y + 2),
                (x + 1, y + 2)
            ]
            
            for option in possibleOptions {
                if inBounds(option) && field[option.0 - 1][option.1 - 1] == 0 {
                    validOptions.append(option)
                }
            }
            
            return validOptions
        }
        
        // checks if the point is still within the board
        func inBounds(_ point: (x: Int, y: Int) ) -> Bool {
            if 1 ... 8 ~= point.x &&
               1 ... 8 ~= point.y
            {
                return true
            } else {
                return false
            }
        }
        
        // ====================
 
        var moves = validMoves(from: (x: currentCell.x, y: currentCell.y), on: field)
        while moves.count > 0 {
            field[currentCell.x - 1][currentCell.y - 1] = 1
            
            var nextMove = moves.first!
            var minCount = 8
            for move in moves {
                let peek = validMoves(from: (x: move.x, y: move.y), on: field).count
                if peek < minCount {
                    minCount = peek
                    nextMove = move
                }
            }
            
            path.append(nextMove)
            currentCell = (x: nextMove.x, y: nextMove.y)
            moves = validMoves(from: (x: currentCell.x, y: currentCell.y), on: field)
        }
        
        var result: [CGPoint] = []
        for point in path {
            result.append(CGPoint(x: point.x, y: point.y))
        }
        
        return result
    }
    
    
    @IBAction func stepButton(_ sender: Any) {
        if chessView.figures.count < self.figures.count {
            chessView.figures.append( self.figures[chessView.figures.count] )
        }
        chessView.update()
    }
    
    
    @IBAction func runButton(_ sender: Any) {
        if self.figures.count > 0 {
            chessView.figures = self.figures
        }
        
        chessView.update()
    }
    
    @IBAction func clearButton(_ sender: Any) {
        if let firstFigureOnBoard = chessView.figures.first {
            chessView.figures = [firstFigureOnBoard]
        }
        
        chessView.update()
    }
    
}

