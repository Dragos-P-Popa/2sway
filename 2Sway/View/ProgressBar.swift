//
//  progressBar.swift
//  progressBar2
//
//  Created by Joe Feest on 22/07/2021.
//

import UIKit

protocol ProgressBarDelegate: PromoViewController {
    func makeClaimable()
}

@IBDesignable class ProgressBar: UIView {
    
    // [Filling colour, Filled colour, Background colour]
    let barColours: [CGColor] = [UIColor(named: K.Colors.lightGrey)!.cgColor,
                                 UIColor(named: K.Colors.swayYellow)!.cgColor,
                                 UIColor(named: K.Colors.offWhite)!.cgColor]
  
    var lowViews: Int = 0
    var midViews: Int = 0
    var highViews: Int = 0
    var lowDiscount: Int = 0
    var midDiscount: Int = 0
    var highDiscount: Int = 0
    
    // Proportion of bar that is filled before each milestone is reached
    var lowProgress: CGFloat { return CGFloat(lowViews)/CGFloat(highViews)}
    var midProgress: CGFloat { return CGFloat(midViews)/CGFloat(highViews)}
    
    // When viewcount changes, update function runs
    public var viewCount: Int = 0 {
        didSet {
            textLayer?.string = ""
            didViewCountUpdate()
        }
    }
    
    // Angle that full progress bar makes (2pi would be a full circle with no gap)
    let barAngleSubtended: CGFloat = CGFloat.pi * 1.8
    
    // Thickness of progress bar compared to view size
    let widthRatio: CGFloat = 0.08
    
    private var backgroundLayer: CAShapeLayer!
    private var foregroundLayer1: CAShapeLayer!
    private var foregroundLayer2: CAShapeLayer!
    private var foregroundLayer3: CAShapeLayer!
    private var markersLayer: CAShapeLayer!
    private var textLayer: CATextLayer!
    
    weak var delegate: ProgressBarDelegate?
    
    // Draw progress bar, wihtin specified view
    override func draw(_ rect: CGRect) {
        
        let width = rect.width
        let height = rect.height
        
        let lineWidth = widthRatio*min(width,height)
        
        backgroundLayer = createCircularLayer(rect: rect, strokeColor: barColours[2], fillColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), lineWidth: lineWidth, isRounded: true)
        
        // Layer 1 is grey rounded end
        foregroundLayer1  = createCircularLayer(rect: rect, strokeColor: barColours[0], fillColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), lineWidth: lineWidth, isRounded: true)
        // Layer 2 is yellow that marks intermediate milestones
        foregroundLayer2  = createCircularLayer(rect: rect, strokeColor: barColours[1], fillColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), lineWidth: lineWidth, isRounded: false)
        // Layer 3 is for full bar
        foregroundLayer3  = createCircularLayer(rect: rect, strokeColor: barColours[1], fillColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), lineWidth: lineWidth, isRounded: true)
        
        markersLayer = createMarkers(rect: rect, strokeColor: #colorLiteral(red: 0.7803230882, green: 0.780436337, blue: 0.7802982926, alpha: 1), lineWidth: 1)
        
        textLayer = createTextLayer(rect: rect)
        
        didViewCountUpdate() // ensures the bar starts at 0

        layer.addSublayer(backgroundLayer)
        layer.addSublayer(foregroundLayer1)
        layer.addSublayer(foregroundLayer2)
        layer.addSublayer(foregroundLayer3)
        layer.addSublayer(markersLayer)
        layer.addSublayer(textLayer)
    }
    
    // Drawing circular path that bar takes
    private func createCircularLayer(rect: CGRect, strokeColor: CGColor, fillColor: CGColor,
                                     lineWidth: CGFloat, isRounded: Bool ) -> CAShapeLayer {
        
        
        let width = rect.width
        let height = rect.height
        let barWidth = widthRatio*min(width,height)
        let centre = CGPoint(x: width/2, y: height/2)
        let radius = (min(width,height)-barWidth)/2
        let startAngle = -CGFloat.pi/2
        let endAngle = startAngle + barAngleSubtended
        let circularPath = UIBezierPath(arcCenter: centre, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = strokeColor
        shapeLayer.fillColor = fillColor
        shapeLayer.lineWidth = barWidth
        if isRounded {
            shapeLayer.lineCap = .round
        } else { shapeLayer.lineCap = .butt
            
        }
        
        return shapeLayer
    }
    
    // Write viewcount in middle of circle
    private func createTextLayer(rect: CGRect) -> CATextLayer {
        
        let width = rect.width
        let height = rect.height
        let barWidth = widthRatio*min(width,height)
        let fontSize = min(width, height)/15
        let font = UIFont(name: "Jost", size: fontSize)
        // let offset = min(width, height)*0.05
        let layer = CATextLayer()
        let textWidth = (width - 2*barWidth)*0.8
                
        layer.string = "\(viewCount) views"
        layer.backgroundColor = #colorLiteral(red: 1, green: 0.3103723374, blue: 0.4807848495, alpha: 0)
        layer.foregroundColor = UIColor(named: K.Colors.white)?.cgColor
        layer.font = font
        layer.fontSize = fontSize
        layer.isWrapped = true
        layer.frame = CGRect(x: 2*barWidth, y: height/2 - fontSize, width: textWidth, height: height/4)
        layer.alignmentMode = .center
    
        
        return layer
        
    }
    
    private func createMarkers(rect: CGRect, strokeColor: CGColor, lineWidth: CGFloat) -> CAShapeLayer {
        let width = rect.width
        let height = rect.height
        let barWidth = widthRatio*min(width,height)
        let centre = CGPoint(x: width/2, y: height/2)
        let innerBarRadius = (min(width,height)/2 - barWidth)
        let outerBarRadius = (min(width,height))/2
        let markerSizeRatio = CGFloat(0.5)            // How much marker sticks out either side of the progress bar, compared to the width of the bar
        let innerMarkerRadius = innerBarRadius - markerSizeRatio * barWidth
        let outerMarkerRadius = outerBarRadius + markerSizeRatio * barWidth
        
        let lowMarkerAngle = -CGFloat.pi/2 + lowProgress * barAngleSubtended
        let midMarkerAngle = -CGFloat.pi/2 + midProgress * barAngleSubtended
        
        let lowLineStart = CGPoint(centre: centre, radius: innerMarkerRadius, angle: lowMarkerAngle)
        let lowLineEnd = CGPoint(centre: centre, radius: outerMarkerRadius, angle: lowMarkerAngle)
        
        let midLineStart = CGPoint(centre: centre, radius: innerMarkerRadius, angle: midMarkerAngle)
        let midLineEnd = CGPoint(centre: centre, radius: outerMarkerRadius, angle: midMarkerAngle)
        
        let path = UIBezierPath()
        path.move(to: lowLineStart)
        path.addLine(to: lowLineEnd)
        path.close()
        path.move(to: midLineStart)
        path.addLine(to: midLineEnd)
        path.close()
        
        let markersLayer = CAShapeLayer()
        markersLayer.path = path.cgPath
        markersLayer.strokeColor = strokeColor
        markersLayer.lineWidth = lineWidth
        
        return markersLayer
        
    }
        
    // Set text in middle of circle to current viewcount, and update the progress of the bar
    private func didViewCountUpdate() {
        
        if viewCount >= lowViews {
            delegate?.makeClaimable()
        }
        textLayer?.string = ""
        let progress: CGFloat = CGFloat(viewCount)/CGFloat(highViews)
        
        if viewCount < lowViews {
            foregroundLayer1.strokeEnd = min(progress, lowProgress)
            foregroundLayer2.strokeEnd = 0.0
            foregroundLayer3.strokeEnd = 0.0
            if viewCount == 1 {
          //      textLayer?.string = "\(viewCount) view, Current discount: 0%"
            } else {
           //     textLayer?.string = "\(viewCount) views, Current discount: 0%"
            }
        } else if viewCount < midViews {
            foregroundLayer1.strokeEnd = min(progress, midProgress)
            foregroundLayer2.strokeEnd = lowProgress
            foregroundLayer3.strokeEnd = lowProgress/2      // Just to make it invisible

          //  textLayer?.string = "\(viewCount) views, Current discount: \(lowDiscount)%"

        
        } else if viewCount < highViews {
            foregroundLayer1.strokeEnd = min(progress, 1)
            foregroundLayer2.strokeEnd = midProgress
            
           // textLayer?.string = "\(viewCount) views, Current discount: \(midDiscount)%"
            
        } else {
            foregroundLayer3.strokeEnd = 1.0
            
           // textLayer?.string = "\(viewCount) views, Current discount: \(highDiscount)%"
        }
    }
}

extension CGPoint {
    init(centre: CGPoint, radius: CGFloat, angle: CGFloat) {
        let x = centre.x + radius * cos(angle)
        let y = centre.y + radius * sin(angle)
        self.init(x: x, y: y)
    }
}
    


