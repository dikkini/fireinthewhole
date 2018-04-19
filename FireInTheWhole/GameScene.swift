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

    var selectedCharacter: Character? = nil
    var targetTile: Character? = nil
    var selectedGround: Ground? = nil

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Choose one of the touches to work with
        guard let touch = touches.first else {
            return
        }

        enumerateChildNodes(withName: "//*", using: { (node, stop) in
            if node.name == "fire_btn" {
                if node.contains(touch.location(in: self)) {
                    if self.selectedCharacter != nil && self.selectedCharacter is Droid && self.targetTile != nil {
                        (self.selectedCharacter as? Droid)!.fire(targetTile: self.targetTile!)
                    }
                    return
                }
            }
        })

        let selectedTile = self.tileService.getTouchedTile(touch: touch)

        if selectedTile is Character && (self.selectedCharacter == nil || selectedTile == self.selectedCharacter) { // первый раз выбран персонаж
            print("Character chosen for the first time")
            self.selectedCharacter = selectedTile as? Character
            let moves = self.selectedCharacter?.getPossibleMoveTileIndexList(tileSize: GameLogic.tileSize, mapCols: GameLogic.mapCols, mapRows: GameLogic.mapRows)

            self.tileService.highlightCharacterAllowMoves(moveTileIndexList: moves!)
            self.selectedGround = nil
        } else if selectedTile is Character && self.selectedCharacter !== nil && selectedTile as? Character !== self.selectedCharacter { // выбран другой персонаж, не тот что выбран ранее
            print("Other character chosen")
            self.targetTile = (selectedTile as? Character)!

            self.showCharacterActionsMenu(char: self.selectedCharacter!)

        } else if selectedTile is Ground && self.selectedCharacter !== nil && self.selectedGround == nil { // персонаж выбран и выбрана земля для хода
            print("Ground chosen first time for selected characeter mean while character was chosen")
            self.hideCharacterActionsMenu()
            self.selectedGround = (selectedTile as? Ground)!
            if (self.selectedCharacter?.canMoveTo(point25D: (self.selectedGround?.position)!))! { // если персонаж пожет пойти в точку/ то подсветить точку
                print("Character can move to ground point. Highligh it!")
                self.tileService.highlightMovePoint(move25DPoint: (self.selectedGround?.position)!)
            } else { //иначе убрать выделение
                print("Character can't move to ground point. Remove highlights - reset move action!")
                self.hideCharacterActionsMenu()
                self.tileService.highlightPathLayer.removeAllChildren()
                self.selectedGround = nil
                self.selectedCharacter = nil
            }
        } else if selectedTile is Ground && self.selectedGround != nil && self.selectedCharacter != nil { //если выбрана земля и до этого была выбрана земля (которая уже подсвечена)
            self.hideCharacterActionsMenu()
            if selectedTile?.position == self.selectedGround?.position { // и координаты совпадают? то надо идти в эту точку
                let toPos2D = point25DTo2D(p: (self.selectedGround?.position)!)
                let fromPos2D = point25DTo2D(p: (self.selectedCharacter?.position)!)
                let path = self.tileService.findPathFrom(from: point2DToPointTileIndex(point: fromPos2D, tileSize: GameLogic.tileSize), to: point2DToPointTileIndex(point: toPos2D, tileSize: GameLogic.tileSize))
                if path != nil {
                    let tileIndexOfChar = point2DToPointTileIndex(point: (self.selectedCharacter?.position2D)!, tileSize: GameLogic.tileSize)
                    self.selectedCharacter!.move(path: path!, completion: { newTileIndexOfChar in
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

                self.tileService.highlightPathLayer.removeAllChildren()
                self.selectedCharacter = nil
                self.selectedGround = nil
            } else {
                let movePointHighlight = self.tileService.highlightPathLayer.children.last
                if (self.selectedCharacter?.canMoveTo(point25D: (selectedTile?.position)!))! { // иначе либо подсветить другую землю
                    movePointHighlight?.position = (selectedTile?.position)!
                    self.selectedGround = selectedTile as? Ground
                } else { // либо убрать подсветку патенциального хода
                    self.tileService.highlightPathLayer.removeChildren(in: [movePointHighlight!])
                    self.selectedGround = nil
                }
            }
        }
    }

    func showCharacterActionsMenu(char: Character) {
        let menuLayer = SKNode()
        menuLayer.name = "char_menu"
        menuLayer.zPosition = 999

        if char.canFire! {
            let fireButton = SKSpriteNode(imageNamed: "fire_button")
            fireButton.name = "fire_btn"
            fireButton.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            fireButton.position = CGPoint(x: -250, y: 170)
            fireButton.zPosition = 100

            menuLayer.addChild(fireButton)
        }

        // ...
        // more more buttons
        // ...

        self.addChild(menuLayer)
    }

    func hideCharacterActionsMenu() {
        self.childNode(withName: "char_menu")?.removeFromParent()
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
