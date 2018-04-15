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
        self.tileService = TileService(tileSize: (width: GameLogic.tileSize.width, height: GameLogic.tileSize.height), mapRows: GameLogic.mapRows, mapCols: GameLogic.mapRows)

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
        if selectedTile is Character && (self.selectedCharacter25D == nil || selectedTile == self.selectedCharacter25D) { // первый раз выбран персонаж
            print("Character chosen for the first time")
            self.selectedCharacter25D = selectedTile as? Character
            let moves = self.selectedCharacter25D?.getPossibleMoveTileIndexList(tileSize: GameLogic.tileSize, mapCols: GameLogic.mapCols, mapRows: GameLogic.mapRows)

            self.tileService.highlightCharacterAllowMoves(moveTileIndexList: moves!)
            self.selectedGround25D = nil
        } else if selectedTile is Character && self.selectedCharacter25D !== nil && selectedTile as? Character !== self.selectedCharacter25D { // выбран другой персонаж, не тот что выбран ранее
            var tt = self.selectedCharacter25D as? Droid
            
            print("Other character chosen")
            print(self.selectedCharacter25D?.name)
            print(selectedTile?.name)

            let targetTile = (selectedTile as? Character)!
            tt?.fire(targetTile: targetTile)
            // TODO определение какой именно character, в зависимости от этого разные действия.

        } else if selectedTile is Ground && self.selectedCharacter25D !== nil && self.selectedGround25D == nil { // персонаж выбран и выбрана земля для хода
            print("Ground chosen first time for selected characeter mean while character was chosen")
            self.selectedGround25D = (selectedTile as? Ground)!
            if (self.selectedCharacter25D?.canMoveTo(point25D: (self.selectedGround25D?.position)!))! { // если персонаж пожет пойти в точку/ то подсветить точку
                print("Character can move to ground point. Highligh it!")
                self.tileService.highlightMovePoint(move25DPoint: (self.selectedGround25D?.position)!)
            } else { //иначе убрать выделение
                print("Character can't move to ground point. Remove highlights - reset move action!")
                self.tileService.highlightPathLayer25D.removeAllChildren()
                self.selectedGround25D = nil
                self.selectedCharacter25D = nil
            }
        } else if selectedTile is Ground && self.selectedGround25D != nil && self.selectedCharacter25D != nil { //если выбрана земля и до этого была выбрана земля (которая уже подсвечена)
            if selectedTile?.position == self.selectedGround25D?.position { // и координаты совпадают? то надо идти в эту точку
                let toPos2D = point25DTo2D(p: (self.selectedGround25D?.position)!)
                let fromPos2D = point25DTo2D(p: (self.selectedCharacter25D?.position)!)
                let path = self.tileService.findPathFrom(from: point2DToPointTileIndex(point: fromPos2D, tileSize: GameLogic.tileSize), to: point2DToPointTileIndex(point: toPos2D, tileSize: GameLogic.tileSize))
                if path != nil {
                    // TODO здесь надо удостоверится что персонаж точно сможет пойти
                    let tileIndexOfChar = point2DToPointTileIndex(point: (self.selectedCharacter25D?.position2D)!, tileSize: GameLogic.tileSize)
                    self.selectedCharacter25D!.move(path: path!, completion: {newTileIndexOfChar in
                        let oldIndex = tileIndexOfChar
                        let newIndex = newTileIndexOfChar
                        let oldType = TileType.Ground
                        let newType = TileType.Character
                        // updateTileMap (change position of Character, place ground on character old place)
                        self.tileService.updateTileMap(oldIndex: oldIndex, newIndex: newIndex, oldType: oldType, newType: newType)
                    })
                } else {
                    print("PATH IS NIL")
                }

                self.tileService.highlightPathLayer25D.removeAllChildren()
                self.selectedCharacter25D = nil
                self.selectedGround25D = nil
            } else {
                let movePointHighlight = self.tileService.highlightPathLayer25D.children.last
                if (self.selectedCharacter25D?.canMoveTo(point25D: (selectedTile?.position)!))! { // иначе либо подсветить другую землю
                    movePointHighlight?.position = (selectedTile?.position)!
                    self.selectedGround25D = selectedTile as? Ground
                } else { // либо убрать подсветку патенциального хода
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
