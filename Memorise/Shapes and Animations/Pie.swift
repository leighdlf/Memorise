//
//  Pie.swift
//  Memorise
//
//  Created by Leigh De La Fontaine on 5/6/20.
//  Copyright © 2020 Leigh De La Fontaine. All rights reserved.
//

import SwiftUI

// All shapes are animatable.

struct Pie: Shape {
    /// Creates a pie shape to use as part of a view.
    
    var startAngle: Angle
    var endAngle: Angle
    var clockWise = false
    
    var animatableData: AnimatablePair<Double, Double> {
        // Connecting the angle vars to the animation.
        // What part of our shape we want to animate.
        get {
            AnimatablePair(startAngle.radians, endAngle.radians)    // Getting the animatable data.
        }
        set {
            startAngle = Angle.radians(newValue.first)
            endAngle = Angle.radians(newValue.second)
        }
    }
    
    // CGRect is the space offered.
    func path(in rect: CGRect) -> Path {
        let radius = min(rect.width, rect.height) / 2   // Smaller of the width and height for the rectangle.
        let centre = CGPoint(x: rect.midX, y: rect.midY)
        let start = CGPoint(
            x: centre.x + radius * cos(CGFloat(startAngle.radians)),
            y: centre.y + radius * cos(CGFloat(startAngle.radians))
        )
        
        var p = Path()
        p.move(to: centre)
        p.addLine(to: start)
        p.addArc(
            center: centre,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: clockWise
        )
        p.addLine(to: centre)
        
        
        return p
    }
}
