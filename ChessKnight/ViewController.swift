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

    let chessView = ChessBoardView()
    
    var figures = [CGPoint]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let boardSize = self.view.frame.width
        chessView.bounds = CGRect(x: 0, y: 0, width: boardSize, height: boardSize)
        chessView.center = self.view.center
        
        self.view.addSubview(chessView)
    
        chessView.update()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action:  #selector (self.chessBoardTapped(_:)))
        self.chessView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func chessBoardTapped(_ sender:UITapGestureRecognizer){
        if let location = chessView.touchedCell(in: sender.location(in: chessView) ) {
            print("tap \(location)")
            
            if figures.contains(location) {
                figures.remove(at: figures.firstIndex(of: location)! )
            } else {
                figures.append(location)
            }
            
            chessView.figures = self.figures
            chessView.update()
        }
        
    }

}

