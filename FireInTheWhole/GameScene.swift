//
//  GameScene.swift
//  FireInTheWhole
//
//  Created by dikkini on 14/03/2018.
//  Copyright © 2018 Artur Karapetov. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let view2D:SKSpriteNode
    let viewIso:SKSpriteNode
    
    let tileService:TileService = TileService()
    
    var tiles:[[(Int, Int)]]
    
    let tileSize = (width:32, height:32)

    override init(size: CGSize) {
        
        view2D = SKSpriteNode()
        viewIso = SKSpriteNode()
        
        tiles =     [[(1,7), (1,0), (1,0), (1,0), (1,0), (1,1)]]
        tiles.append([(1,6), (0,0), (0,0), (0,0), (0,0), (1,2)])
        tiles.append([(1,6), (0,0), (2,2), (0,0), (0,0), (1,2)])
        tiles.append([(1,6), (0,0), (0,0), (0,0), (0,0), (1,2)])
        tiles.append([(1,6), (0,0), (0,0), (0,0), (0,0), (1,2)])
        tiles.append([(1,5), (1,4), (1,4), (1,4), (1,4), (1,3)])
        
        super.init(size: size)
        self.anchorPoint = CGPoint(x:0.5, y:0.5)
    }

    override func didMove(to view: SKView) {
        let deviceScale = self.size.width/667
        
        view2D.position = CGPoint(x:-self.size.width*0.45, y:self.size.height*0.17)
        view2D.xScale = deviceScale
        view2D.yScale = deviceScale
        addChild(view2D)
        
        viewIso.position = CGPoint(x:self.size.width*0.12, y:self.size.height*0.12)
        viewIso.xScale = deviceScale
        viewIso.yScale = deviceScale
        addChild(viewIso)
        
        tileService.placeAllTiles2D(view:view2D, tiles:tiles, tileSize: tileSize)
        tileService.placeAllTilesIso(view:viewIso, tiles:tiles, tileSize: tileSize)
    }
}
