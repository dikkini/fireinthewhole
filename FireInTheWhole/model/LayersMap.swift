//
//  LayersMap.swift
//  FireInTheWhole
//
//  Created by dikkini on 18/03/2018.
//  Copyright © 2018 Artur Karapetov. All rights reserved.
//

import Foundation
import SpriteKit

struct LayersMap {
    var groundLayer25D: SKNode
    var characterLayer25D: SKNode
    var objectLayer25D: SKNode
    var highlightPathLayer25D: SKNode

    init(groundLayer25D: SKNode, characterLayer25D: SKNode, objectLayer25D: SKNode, highlightPathLayer25D: SKNode) {
        self.groundLayer25D = groundLayer25D
        self.characterLayer25D = characterLayer25D
        self.objectLayer25D = objectLayer25D
        self.highlightPathLayer25D = highlightPathLayer25D
    }
}

