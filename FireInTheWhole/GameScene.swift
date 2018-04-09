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
    var selectedGround25D: Ground? = nil
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Choose one of the touches to work with
        guard let touch = touches.first else {
            return
        }

        let selectedTile = self.tileService.getTouchedTile(touch: touch)
        if selectedTile is Character && (self.selectedCharacter25D == nil || selectedTile == self.selectedCharacter25D) {
            self.selectedCharacter25D = selectedTile as? Character
            let moves = self.selectedCharacter25D?.getPossibleMoveTileIndexList(tileSize: GameLogic.tileSize, mapCols: GameLogic.mapCols, mapRows: GameLogic.mapRows)
           
            self.tileService.highlightCharacterAllowMoves(moveTileIndexList: moves!)
            self.selectedGround25D = nil
        } else if selectedTile is Character && self.selectedCharacter25D !== nil {
            print("FIRE!!!!!!")
            print(self.selectedCharacter25D?.name)
            print(selectedTile?.name)
            
            let targetTile = (selectedTile as? Character)!
        
        } else if selectedTile is Ground && self.selectedCharacter25D !== nil && self.selectedGround25D == nil { // персонаж выбран и выбрана земля для хода
            self.selectedGround25D = (selectedTile as? Ground)!
            if (self.selectedCharacter25D?.canMoveTo(point25D: (self.selectedGround25D?.position)!))! { // если персонаж пожет пойти в точку/ то подсветить точку
                self.tileService.highlightMovePoint(move25DPoint: (self.selectedGround25D?.position)!)
            }
            else { //иначе убрать выделение
                self.tileService.highlightPathLayer25D.removeAllChildren()
                self.selectedGround25D = nil
                self.selectedCharacter25D = nil
            }
        } else if selectedTile is Ground && self.selectedGround25D != nil && self.selectedCharacter25D != nil { //если выбрана земля и до этого была выбрана земля (которая уже подсвечена)
            if selectedTile?.position == self.selectedGround25D?.position{ // и координаты совпадают? то надо идти в эту точку
                self.selectedCharacter25D?.move(point25D: (self.selectedGround25D?.position)!)
                self.tileService.highlightPathLayer25D.removeAllChildren()
                self.selectedCharacter25D = nil
                self.selectedGround25D = nil
            }
            else {
                var movePointHighlight = self.tileService.highlightPathLayer25D.children.last
                if (self.selectedCharacter25D?.canMoveTo(point25D: (selectedTile?.position)!))!{ // иначе либо подсветить другую землю
                    movePointHighlight?.position = (selectedTile?.position)!
                    self.selectedGround25D = selectedTile as! Ground
                }
                else { // либо убрать подсветку патенциального хода
                    self.tileService.highlightPathLayer25D.removeChildren(in: [movePointHighlight!])
                    self.selectedGround25D = nil
                }
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
