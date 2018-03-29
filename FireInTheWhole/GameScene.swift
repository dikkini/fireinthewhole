//
//  GameScene.swift
//  FireInTheWhole
//
//  Created by dikkini on 14/03/2018.
//  Copyright © 2018 Artur Karapetov. All rights reserved.
//
import Foundation
import SpriteKit
import GameplayKit

class GameScene: SKScene {

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var tileService: TileService

    override init(size: CGSize) {
        self.tileService = TileService(tileSize: (width: 32, height: 32), mapRows: 10, mapCols: 10)
        
        super.init(size: size)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    }

    override func didMove(to view: SKView) {
        self.tileService.setup(scene: self)
    }

    var selectedCharacter25D: Character? = nil
    var selectedCharacter2D: Character? = nil
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Choose one of the touches to work with
        guard let touch = touches.first else {
            return
        }

        let selectedIsoTile = self.tileService.getTouchedTile(touch: touch)
        if selectedIsoTile is Character && self.selectedCharacter25D == nil{
            self.selectedCharacter25D = selectedIsoTile as? Character
            // ищем character на 2D плоскости
            let charName = self.selectedCharacter25D!.name!
            self.selectedCharacter2D = self.tileService.findCharacter2DTileByName(name: charName) as? Character

            let moves = self.selectedCharacter2D?.getPossibleMoveTileIndexList(tileSize: GameLogic.tileSize, mapCols: GameLogic.mapCols, mapRows: GameLogic.mapRows)

            self.tileService.highlightCharacterAllowMoves(moveTileIndexList: moves!)
        } else if selectedIsoTile is Character && self.selectedCharacter25D !== nil {
            print("FIRE!!!!!!")
            print(self.selectedCharacter25D?.name)
            print(selectedIsoTile?.name)
            
            let targetTile = (selectedIsoTile as? Character)!
           // let targetTileLocation = self.tileService.calculateTileLocation(tile25DName: targetTile.name!)
            
        } else if selectedIsoTile is Ground && self.selectedCharacter25D !== nil { // персонаж выбран и выбрана земля для хода
            let groundTile = (selectedIsoTile as? Ground)!
        
            let tileLocation = self.tileService.calculateTileLocation(tile25DName: groundTile.name!)
            let canMove: Bool = self.tileService.move(tile25D: self.selectedCharacter25D!, tile2D: self.selectedCharacter2D!, location: tileLocation)
            if (!canMove) {
                self.selectedCharacter25D = nil
            }
            
        }
    }

    // TOOD опции?
    let nthFrame = 6
    var nthFrameCount = 0
    override func update(_ currentTime: TimeInterval) {
        self.nthFrameCount += 1
        if (self.nthFrameCount == self.nthFrame) {
            self.nthFrameCount = 0
            self.updateOnNthFrame()
        }
    }

    func updateOnNthFrame() {
        self.tileService.sortDepth()
    }

}
