//
//  ShaderScene.swift
//  SwiftSaver
//
//  Created by Justin Rhoades on 1/30/19.
//  Copyright © 2019 Justin Rhoades. All rights reserved.
//

import Cocoa
import SpriteKit

class ShaderScene: SKScene {
    
    var shaderNode = SKSpriteNode(color: NSColor.black, size: CGSize.zero)
    
    override func didChangeSize(_ oldSize: CGSize) {
        shaderNode.size = CGSize(width:self.size.width, height:self.size.height)
        shaderNode.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        shaderNode.isUserInteractionEnabled = false
        self.createShaderAndUniforms()
    }
    
    override func didMove(to view: SKView) {
        self.backgroundColor = NSColor.black
        addChild(shaderNode)
    }
    
    func createShaderAndUniforms() {
        // Available Uniforms:
        // vec2  u_resolution
        // float u_time
        
        let shader = SKShader(source: self.shaderSourceC())
        let scale = NSScreen.main!.backingScaleFactor
        let width = Float(self.size.width * scale)
        let height = Float(self.size.height * scale)
        shader.uniforms = [
            SKUniform(
                name: "u_resolution",
                vectorFloat2: vector_float2(width, height)
            ),
        ]
        shaderNode.shader = shader
    }
    
    func shaderSourceA () -> String {
        return """
        void main() {
            gl_FragColor = vec4(abs(sin(u_time)),0.0,0.0,1.0);
        }
        """
    }
    
    func shaderSourceB () -> String {
        return """
        #ifdef GL_ES
        precision mediump float;
        #endif

        float rect(vec2 st, vec2 size){
        size = 0.25-size*0.25;
        vec2 uv = step(size,st*(1.0-st));
        return uv.x*uv.y;
        }

        void main() {
        vec2 st = gl_FragCoord.xy/u_resolution.xy;
        
        vec3 influenced_color_a = vec3(0.880,0.793,0.581);
        vec3 influenced_color_b = vec3(0.654,0.760,0.576);
        
        vec3 influencing_color_A = vec3(0.980,0.972,0.896);
        vec3 influencing_color_B = vec3(0.036,0.722,0.790);
        
        vec3 color = mix(influencing_color_A,
                     influencing_color_B,
                     step(.5,1.-st.y));
        
        color = mix(color,
                influenced_color_a,
                rect(st+vec2(.0,-0.25),vec2(0.030,0.010)));
        
        color = mix(color,
                influenced_color_b,
                rect(st+vec2(.0,0.25),vec2(0.030,0.010)));
        
        // color = mix(color,
        //            mix(influenced_color_a,
        //                  influenced_color_b,
        //                  step(.5,1.-st.y)),
        //            rect(st+vec2(0.46,0.),vec2(0.01,0.02)));
        
        gl_FragColor = vec4(color,1.0);
        }
        """
    }
    
    func shaderSourceC() -> String {
        return """
        // Adpated from:
        // Author @patriciogv - 2015
        // Title: Ikeda Data Stream
        
        #ifdef GL_ES
        precision mediump float;
        #endif
        
        float random (float x) {
        return fract(sin(x)*1e4);
        }
        
        float random (vec2 st) {
        return fract(sin(dot(st.xy, vec2(12.9898,78.233)))* 43758.5453123);
        }
        
        float pattern(vec2 st, vec2 v, float t) {
        vec2 p = floor(st+v);
        return step(t, random(100.+p*.000001)+random(p.y)*0.5 );
        }
        
        void main() {
        vec2 st = gl_FragCoord.xy/u_resolution.xy;
        st.y *= u_resolution.x/u_resolution.y;
        
        vec2 grid = vec2(50.0,100.);
        st *= grid;
        
        vec2 ipos = floor(st);  // integer
        vec2 fpos = fract(st);  // fraction
        
        vec2 vel = vec2(u_time*0.5*max(grid.x,grid.y)); // time
        vel *= vec2(0.0,-1.) * random(1.0+ipos.x); // direction
        
        // Assign a random value base on the integer coord
        vec2 offset = vec2(0.,0.1);
        
        vec3 color = vec3(0.);
        color.r = pattern(vel,st+offset,1.0);
        color.g = pattern(vel,st,1.0);
        color.b = pattern(vel,st-offset,1.0);
        
        // Margins
        color *= step(fpos.x,0.2);
        
        
        gl_FragColor = vec4(color,1.0);
        }

        """
    }
    
    
}
