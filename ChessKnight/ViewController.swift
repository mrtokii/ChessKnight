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
            self.figures = fillingMoves(from: location)
            print(self.figures.count)
        }
        
    }
    
    func fillingMoves(from start: CGPoint) -> [CGPoint] {
        
        // [x][y]
        let field = Array(repeating: Array(repeating: 0, count: 8), count: 8)
        
        func inspect( cell: (x: Int, y: Int), field: [[Int]], depth: Int ) -> [(x: Int, y: Int)] {
            var newField = field
            newField[cell.x][cell.y] = 1
            
            let moves = validMoves(from: cell, on: field)
            if moves.count == 0 {
                return [cell]
            }
            
            var maxInspected: [(x: Int, y: Int)] = []
            for _ in 1...2 {
                let inspected = inspect(cell: moves.randomElement()!, field: newField, depth: depth + 1)
                if inspected.count > maxInspected.count {
                    maxInspected = inspected
                }
            }
            
            return [cell] + maxInspected
            
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
        var maxPath: [(x: Int, y: Int)] = []
        for _ in 1...1 {
            let path = inspect(cell: (x: Int(start.x) - 1, y: Int(start.y) - 1), field: field, depth: 0)
            if path.count > maxPath.count {
                maxPath = path
            }
        }
        
        var result: [CGPoint] = []
        for point in maxPath {
            result.append(CGPoint(x: point.x + 1, y: point.y + 1))
        }
        
        return result
    }
    
    
    @IBAction func stepButton(_ sender: Any) {
        if chessView.figures.count < self.figures.count {
            chessView.figures.append( self.figures[chessView.figures.count] )
        }
        chessView.update()
    }
    
    
    @IBAction func clearButton(_ sender: Any) {
        chessView.figures = []
        chessView.update()
    }
    
}

