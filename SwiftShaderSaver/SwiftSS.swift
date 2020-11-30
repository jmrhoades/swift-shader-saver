//
//  SwiftSS.swift
//  SwiftSaver
//
//  Created by Justin Rhoades on 1/30/19.
//  Copyright © 2019 Justin Rhoades. All rights reserved.
//

import ScreenSaver
import SpriteKit


class SwiftSS: ScreenSaverView {
    
    var skView: SKView!
    
    override init?(frame: NSRect, isPreview: Bool) {
        
        super.init(frame: frame, isPreview: isPreview)
        
        self.skView = SKView.init(frame: self.bounds)
        
        let scene = ShaderScene.init(size: self.bounds.size)
        scene.scaleMode = .resizeFill
        self.skView.presentScene(scene)
        //self.skView.showsFPS = true
        //self.skView.showsNodeCount = true
        self.addSubview(self.skView)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    deinit {
        self.skView.removeFromSuperview()
        self.skView = nil
    }
    
    override func startAnimation() {
        super.startAnimation();
    }
    
    override func stopAnimation() {
        super.stopAnimation();
    }
    
    override class func performGammaFade() -> Bool {
        return false
    }
    
    override func hitTest(_ point: NSPoint) -> NSView? {
        return nil
    }
        
}
