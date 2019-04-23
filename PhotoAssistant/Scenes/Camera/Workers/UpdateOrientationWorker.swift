//
//  UpdateOrientationWorker.swift
//  PhotoAssistant
//
//  Created by Артур Азаров on 01.04.2018.
//  Copyright © 2018 Артур Азаров. All rights reserved.
//

import UIKit

final class UpdateOrientationWorker {
    
    // MARK: - Methods
    
    var angleToRotate: CGFloat {
        let deviceOrientation = UIDevice.current.orientation
        let angle: CGFloat
        
        switch deviceOrientation {
        case .portraitUpsideDown: angle = .pi
        case .landscapeLeft: angle = .pi / 2
        case .landscapeRight: angle = -.pi / 2
        default: angle = 0;
        }
        
        return angle
    }
}
