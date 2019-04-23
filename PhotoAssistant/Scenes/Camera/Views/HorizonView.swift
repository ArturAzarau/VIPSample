//
//  HorizonView.swift
//  PhotoAssistant
//
//  Created by Артур Азаров on 02.04.2018.
//  Copyright © 2018 Артур Азаров. All rights reserved.
//

import UIKit

final class HorizonView: UIView {

    // MARK: - Properties
    
    var strokeColor = UIColor.red
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        strokeColor.setStroke()
        path.move(to: CGPoint(x: 0, y: bounds.height / 2))
        path.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height / 2))
        path.stroke()
    }
}
