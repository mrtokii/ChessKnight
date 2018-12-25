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
    //let chessView = ChessBoardView()
    
    var figures = [CGPoint]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chessView.update()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action:  #selector (self.chessBoardTapped(_:)))
        self.chessView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func chessBoardTapped(_ sender:UITapGestureRecognizer){
        if let location = chessView.touchedCell(in: sender.location(in: chessView) ) {
            print("tap \(location)")
            
            /*if figures.contains(location) {
                figures.remove(at: figures.firstIndex(of: location)! )
            } else {
                figures.append(location)
            }*/
            
            chessView.figures = [location]
            chessView.update()
            print(fillingMoves(from: location))
            chessView.figures = fillingMoves(from: location)
            chessView.update()
            
        }
        
    }
    
    func fillingMoves(from start: CGPoint) -> [CGPoint] {
        
        // [x][y]
        let field = Array(repeating: Array(repeating: 0, count: 8), count: 8)
        
        func inspect( cell: (x: Int, y: Int), field: [[Int]], depth: Int ) -> [(x: Int, y: Int)] {
            var newField = field
            newField[cell.x][cell.y] = 1
            
            let moves = validMoves(from: cell, on: field)
            if moves.count == 0 || depth > 20 {
                return [cell]
            }
            
            var maxStack: [(x: Int, y: Int)] = []
            for move in moves  {
                let currentStack = inspect(cell: move, field: newField, depth: depth + 1)
                if currentStack.count > maxStack.count {
                    maxStack = currentStack
                }
            }
            
            if maxStack.count > 20 {
                print("found max: \(maxStack.count) on level \(depth)")
            }
            
            
            return [cell] + maxStack
            
        }
        
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
                if inBounds(option) && field[x][y] == 0 {
                    validOptions.append(option)
                }
            }
            
            return validOptions
        }
        
        // checks if the point is still within the board
        func inBounds(_ point: (x: Int, y: Int) ) -> Bool {
            if 0 ... 7 ~= point.x &&
               0 ... 7 ~= point.y
            {
                return true
            } else {
                return false
            }
        }
        
        // ====================
        let inspected = inspect(cell: (x: Int(start.x) - 1, y: Int(start.y) - 1), field: field, depth: 0)
        var result: [CGPoint] = []
        for point in inspected {
            result.append(CGPoint(x: point.x + 1, y: point.y + 1))
        }
        
        return result
    }
    
    
    @IBAction func stepButton(_ sender: Any) {
        // performing a step
    }
    
}

