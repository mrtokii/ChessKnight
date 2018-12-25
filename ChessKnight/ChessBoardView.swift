//
//  ChessBoardView.swift
//  ChessKnight
//
//  Created by Виталий Сальников on 25/12/2018.
//  Copyright © 2018 Виталий Сальников. All rights reserved.
//

import UIKit
import SpriteKit

class ChessBoardView: SKView {

    var primaryColor: UIColor   = .lightGray
    var secondaryColor: UIColor = .black
    var figureColor: UIColor    = .red
    var mainScene: SKScene      = SKScene()
    var figures: [CGPoint]      = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        update()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func update() {
        drawBoard()
        drawFigures(self.figures)
        self.presentScene(mainScene)
    }
    
    func touchedCell(in location: CGPoint) -> CGPoint? {
        if !(0.0 ... self.frame.width  ~= location.x) ||
           !(0.0 ... self.frame.height ~= location.y)
        {
            return nil
        }
        
        let x = Int( location.x / (self.frame.width  / CGFloat(8)) ) + 1
        let y = Int( location.y / (self.frame.height / CGFloat(8)) ) + 1
        
        return CGPoint(x: x, y: y)
    }
    
    private func drawBoard() {
        let scene = SKScene()
        scene.size = self.bounds.size
        scene.backgroundColor = self.primaryColor
        
        let cellWidth: CGFloat = scene.size.width / CGFloat(8)
        let cellHeight: CGFloat = scene.size.height / CGFloat(8)
        let cellSize = CGSize(width: cellWidth, height: cellHeight)
        
        var skipCell = true
        for i in 0..<8 {
            skipCell = !skipCell
            
            for j in 0..<8 {
                skipCell = !skipCell
                
                if(skipCell) {
                    let cubeNode = SKSpriteNode(color: self.secondaryColor, size: cellSize)
                    let cubeX = CGFloat(j) *  cellWidth + cellWidth  / 2
                    let cubeY = CGFloat(i) * cellHeight + cellHeight / 2
                    
                    cubeNode.position = CGPoint(x: cubeX, y: cubeY)
                    
                    scene.addChild(cubeNode)
                }
                
            }
        }
        
        self.mainScene = scene
    }
    
    private func drawFigures(_ figures: [CGPoint]) {
        let cellWidth:  CGFloat = self.mainScene.size.width / CGFloat(8)
        let cellHeight: CGFloat = self.mainScene.size.height / CGFloat(8)
        let cellSize = CGSize(width: cellWidth, height: cellHeight)
        
        for figure in figures {
            let cubeNode = SKSpriteNode(color: self.figureColor, size: cellSize)
            let cubeX = CGFloat(figure.x - 1) *  cellWidth + cellWidth  / 2
            let cubeY = CGFloat(8 - figure.y) * cellHeight + cellHeight / 2
            
            cubeNode.position = CGPoint(x: cubeX, y: cubeY)
            
            mainScene.addChild(cubeNode)
        }
        
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
