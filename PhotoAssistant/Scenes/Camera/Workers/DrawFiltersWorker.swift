//
//  DrawFiltersWorker.swift
//  PhotoAssistant
//
//  Created by Артур Азаров on 01.04.2018.
//  Copyright © 2018 Артур Азаров. All rights reserved.
//

import UIKit

final class DrawFiltersWorker {
    
    // MARK: - Properties
    
    private let size: CGSize
    private let item: Int
    
    // MARK: - Object Life Cycle
    
    init(size: CGSize,item: Int) {
        self.size = size
        self.item = item
    }
    
    func drawFilter() -> UIImage {
        print(item)
        switch self.item {
        case 0: return UIImage()
        case 1: return drawGrid()
        case 2: return drawFibonacciSpiral()
        case 3: return drawHorizonLine()
        default: return UIImage()
        }
    }
    
    private func drawHorizonLine() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(UIColor.yellow.cgColor)
        context?.setLineWidth(CGFloat(0.5))
        context?.setLineCap(.square)
        context?.setBlendMode(.normal)
        UIColor.yellow.setStroke()
        context?.move(to: CGPoint(x: 0, y: size.height / 2))
        context?.addLine(to: CGPoint(x: size.width, y: size.height / 2))
        context?.strokePath()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    private func drawGrid() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(UIColor.yellow.cgColor)
        context?.setLineWidth(CGFloat(0.5))
        context?.setLineCap(.square)
        context?.setBlendMode(.normal)

        
        func drawFirstVerticalLine() {
            let x = size.width / 3
            let firstPoint = CGPoint(x: x, y: 0)
            let secondPoint = CGPoint(x: x, y: size.height)
            drawLine(from: firstPoint, to: secondPoint)
        }
        
        func drawSecondVerticalLine() {
            let x = 2 * size.width / 3
            let firstPoint = CGPoint(x: x, y: 0)
            let secondPoint = CGPoint(x: x, y: size.height)
            drawLine(from: firstPoint, to: secondPoint)
        }
        
        func drawFirstHorizontalLine() {
            let y = size.height / 3
            let firstPoint = CGPoint(x: 0, y: y)
            let secondPoint = CGPoint(x: size.width, y: y)
            drawLine(from: firstPoint, to: secondPoint)
        }
        
        func drawSecondHorizontalLine() {
            let y = 2 * size.height / 3
            let firstPoint = CGPoint(x: 0, y: y)
            let secondPoint = CGPoint(x: size.width, y: y)
            drawLine(from: firstPoint, to: secondPoint)
        }
        
        func drawLine(from firstPoint: CGPoint,to secondPoint: CGPoint) {
            context?.move(to: firstPoint)
            context?.addLine(to: secondPoint)
        }
        
        drawFirstVerticalLine()
        drawSecondVerticalLine()
        drawFirstHorizontalLine()
        drawSecondHorizontalLine()
        
        context?.strokePath()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    private func drawFibonacciSpiral() -> UIImage {
        let size = self.size
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(UIColor.yellow.cgColor)
        context?.setLineWidth(CGFloat(1))
        context?.setLineCap(.square)
        context?.setBlendMode(.normal)
        
        var smallerWidth = size.width
        var heigherWidth = size.height
        var xRectCoord: CGFloat = 0
        var yRectCoord: CGFloat = 0
        var startAngle: CGFloat = 3 * .pi / 2
        var endAngle: CGFloat = 0
        
        func calculateNewWidthAndCoords() {
            let temp = smallerWidth
            smallerWidth = heigherWidth - smallerWidth
            heigherWidth = temp
            startAngle += .pi / 2
            endAngle += .pi / 2
        }
        
        let path = UIBezierPath(rect: CGRect(x: xRectCoord, y: yRectCoord, width: smallerWidth, height: smallerWidth))
        path.move(to: CGPoint(x: 0, y: 0))
        path.addArc(withCenter: CGPoint(x: 0, y: smallerWidth), radius: smallerWidth, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        context?.addPath(path.cgPath)
        calculateNewWidthAndCoords()
        
        let secondPath = UIBezierPath(rect: CGRect(x: size.width - smallerWidth, y: heigherWidth, width: smallerWidth, height: smallerWidth))
        secondPath.move(to: CGPoint(x: size.width - smallerWidth, y: heigherWidth))
        secondPath.addArc(withCenter: CGPoint(x: size.width - smallerWidth, y: heigherWidth), radius: smallerWidth, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        context?.addPath(secondPath.cgPath)
        calculateNewWidthAndCoords()
        
        let thirdPath = UIBezierPath(rect: CGRect(x: 0, y: size.height - smallerWidth, width: smallerWidth, height: smallerWidth))
        thirdPath.move(to: CGPoint(x: 0, y: size.height))
        thirdPath.addArc(withCenter: CGPoint(x: smallerWidth, y: size.height - smallerWidth), radius: smallerWidth, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        context?.addPath(thirdPath.cgPath)
        calculateNewWidthAndCoords()
        
        let fourtPath = UIBezierPath(rect: CGRect(x: 0, y: size.height - smallerWidth - heigherWidth, width: smallerWidth, height: smallerWidth))
        fourtPath.move(to: CGPoint(x: smallerWidth, y: size.height - heigherWidth))
        fourtPath.addArc(withCenter: CGPoint(x: smallerWidth, y: size.height - heigherWidth), radius: smallerWidth, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        context?.addPath(fourtPath.cgPath)
        calculateNewWidthAndCoords()
        
        var rectOrigin: CGPoint
        
        let fifthPath = UIBezierPath(rect: CGRect(x: heigherWidth, y: size.height - smallerWidth - 2 * heigherWidth, width: smallerWidth, height: smallerWidth))
        fifthPath.move(to: CGPoint(x: heigherWidth, y: size.height - smallerWidth - heigherWidth - (heigherWidth - smallerWidth)))
        fifthPath.addArc(withCenter: CGPoint(x: heigherWidth, y: size.height - smallerWidth - heigherWidth - (heigherWidth - smallerWidth)), radius: smallerWidth, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        context?.addPath(fifthPath.cgPath)
        rectOrigin = CGPoint(x: heigherWidth, y: size.height - smallerWidth - 2 * heigherWidth)
        calculateNewWidthAndCoords()
        
        let sixthPath = UIBezierPath(rect: CGRect(x: rectOrigin.x + (heigherWidth - smallerWidth), y: rectOrigin.y + heigherWidth, width: smallerWidth, height: smallerWidth))
        sixthPath.move(to: CGPoint(x: rectOrigin.x + (heigherWidth - smallerWidth), y: rectOrigin.y + heigherWidth))
        sixthPath.addArc(withCenter: CGPoint(x: rectOrigin.x + (heigherWidth - smallerWidth), y: rectOrigin.y + heigherWidth), radius: smallerWidth, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        context?.addPath(sixthPath.cgPath)
        rectOrigin = CGPoint(x: rectOrigin.x + (heigherWidth - smallerWidth), y: rectOrigin.y + heigherWidth)
        calculateNewWidthAndCoords()
        
        let seventhPath = UIBezierPath(rect: CGRect(x: rectOrigin.x - smallerWidth, y: rectOrigin.y + heigherWidth - smallerWidth, width: smallerWidth, height: smallerWidth))
        seventhPath.move(to: CGPoint(x: rectOrigin.x, y: rectOrigin.y + heigherWidth - smallerWidth))
        seventhPath.addArc(withCenter: CGPoint(x: rectOrigin.x, y: rectOrigin.y + heigherWidth - smallerWidth), radius: smallerWidth, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        context?.addPath(seventhPath.cgPath)
        rectOrigin = CGPoint(x: rectOrigin.x - smallerWidth, y: rectOrigin.y + heigherWidth - smallerWidth)
        calculateNewWidthAndCoords()
        
        let eighthPath = UIBezierPath(rect: CGRect(
            x: rectOrigin.x,
            y: rectOrigin.y - smallerWidth, width: heigherWidth, height: smallerWidth))
        eighthPath.move(to: CGPoint(
            x: rectOrigin.x + smallerWidth,
            y: rectOrigin.y))
        eighthPath.addArc(withCenter: CGPoint(
            x: rectOrigin.x + smallerWidth,
            y: rectOrigin.y),
                          radius: smallerWidth, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        context?.addPath(eighthPath.cgPath)
        rectOrigin = CGPoint(
            x: rectOrigin.x - smallerWidth,
            y: rectOrigin.y + heigherWidth - smallerWidth)
        calculateNewWidthAndCoords()
        
        context?.strokePath()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
