//
//  PlayGroundScene.swift
//  FireInTheWhole
//
//  Created by dikkini on 14/03/2018.
//  Copyright © 2018 Artur Karapetov. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class PlayGroundScene: BaseScene {

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var tileService: TileService
    var menuService: MenuService

    override init(size: CGSize) {
        self.tileService = TileService(tileSize: (width: GameLogic.tileSize.width, height: GameLogic.tileSize.height),
                mapRows: GameLogic.mapRows, mapCols: GameLogic.mapRows)
        let menuPosition = CGPoint(x: 300, y: 160)
        self.menuService = MenuService(menuPosition: menuPosition)

        super.init(size: size)
    }

    override func didMove(to view: SKView) {
        self.tileService.setup(scene: self)
        self.menuService.setup(scene: self)

        self.menuButton.fontColor = .white
        self.menuButton.position = CGPoint(x: -(self.size.width / 2 - 50), y: self.size.height / 2 - 25)
    }

    var selectedCharacter: Character? = nil
    var targetTile: Character? = nil
    var selectedGround: Ground? = nil

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

        guard let touch = touches.first else {
            return
        }

        // нажимаем ли на меню
        enumerateChildNodes(withName: "//*", using: { (node, stop) in
            if node.name == "fire_btn" {
                if node.contains(touch.location(in: self.menuService.menuLayer)) {
                    if self.selectedCharacter != nil && self.selectedCharacter is Droid && self.targetTile != nil {
                        (self.selectedCharacter as? Droid)!.fire(targetTile: self.targetTile!)
                    }
                    return
                }
            }
        })

        let touchedTile = self.tileService.getTouchedTile(touch: touch)

        if touchedTile is Character && (self.selectedCharacter == nil || touchedTile == self.selectedCharacter) {
            // первый раз выбран персонаж
            self.touchedMainCharacter(touchedTile: touchedTile as! Character)
        } else if touchedTile is Character && self.selectedCharacter !== nil
                          && touchedTile as? Character !== self.selectedCharacter {
            // выбран другой персонаж, не тот что выбран ранее
            self.touchedOtherCharacter(touchedTile: touchedTile as! Character)
        } else if touchedTile is Ground {
            // персонаж выбран и выбрана земля для хода
            self.touchedGround(touchedTile: touchedTile as! Ground)
        }
    }

    func touchedMainCharacter(touchedTile: Character) {
        print("GameScene Character chosen for the first time")
        self.selectedCharacter = touchedTile
        let moves = self.selectedCharacter?.getPossibleMoveTileIndexList(tileSize: GameLogic.tileSize,
                mapCols: GameLogic.mapCols, mapRows: GameLogic.mapRows)

        self.tileService.highlightCharacterAllowMoves(moveTileIndexList: moves!)
        self.selectedGround = nil
    }

    func touchedOtherCharacter(touchedTile: Character) {
        print("GameScene Other character chosen")
        self.targetTile = touchedTile

        self.menuService.showActionMenu(char: self.selectedCharacter!)

        self.selectedCharacter?.changeDirection(newPoint2D: (self.targetTile?.position2D)!,
                prevPoint2D: (self.selectedCharacter?.position2D)!)
        self.targetTile?.color = .magenta
        self.targetTile?.update()
    }

    func touchedGround(touchedTile: Ground) {
        if self.selectedCharacter != nil && self.selectedGround == nil {
            print("GameScene Ground chosen first time for selected character mean while character was chosen")
            self.menuService.hideActionMenu()

            self.selectedGround = touchedTile

            if (self.selectedCharacter?.canMoveTo(point25D: (self.selectedGround?.position)!))! {
                // если персонаж пожет пойти в точку/ то подсветить точку
                print("GameScene Character can move to ground point. Highlight it!")
                self.tileService.highlightMovePoint(move25DPoint: (self.selectedGround?.position)!)
            } else {
                // иначе убрать выделение
                print("GameScene Character can't move to ground point. Remove highlights - reset move action!")
                self.menuService.hideActionMenu()
                self.tileService.highlightPathLayer.removeAllChildren()
                self.selectedGround = nil
                self.selectedCharacter = nil
            }
        } else if self.selectedCharacter != nil && self.selectedGround != nil {
            self.menuService.hideActionMenu()
            if touchedTile.position == self.selectedGround?.position {
                self.blockUI = true
                // и координаты совпадают, то надо идти в эту точку
                let toPos2D = point25DTo2D(p: (self.selectedGround?.position)!)
                let fromPos2D = point25DTo2D(p: (self.selectedCharacter?.position)!)
                let path = self.tileService.findPathFrom(from: point2DToPointTileIndex(point: fromPos2D,
                        tileSize: GameLogic.tileSize),
                        to: point2DToPointTileIndex(point: toPos2D, tileSize: GameLogic.tileSize))
                if path != nil {
                    let tileIndexOfChar = point2DToPointTileIndex(point: (self.selectedCharacter?.position2D)!,
                            tileSize: GameLogic.tileSize)
                    self.selectedCharacter!.move(path: path!, completion: { newTileIndexOfChar in
                        let oldIndex = tileIndexOfChar
                        let newIndex = newTileIndexOfChar
                        let oldType = TileType.Ground
                        let newType = TileType.Character
                        // updateTileMap (change position of Character, place ground on character old place)
                        self.tileService.updateTileMap(oldIndex: oldIndex, newIndex: newIndex, oldType: oldType,
                                newType: newType)
                        self.blockUI = false
                    })
                } else {
                    // TODO
                    print("GameScene PATH IS NIL")
                }

                self.tileService.highlightPathLayer.removeAllChildren()
                self.selectedCharacter = nil
                self.selectedGround = nil
            } else {
                // иначе
                let movePointHighlight = self.tileService.highlightPathLayer.children.last
                if (self.selectedCharacter?.canMoveTo(point25D: touchedTile.position))! {
                    // либо подсветить другую землю
                    movePointHighlight?.position = touchedTile.position
                    self.selectedGround = touchedTile
                } else {
                    // либо убрать подсветку потенциального хода
                    self.tileService.highlightPathLayer.removeChildren(in: [movePointHighlight!])
                    self.selectedGround = nil
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
