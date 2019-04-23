//
//  CameraError.swift
//  PhotoAssistant
//
//  Created by Артур Азаров on 23/04/2019.
//  Copyright © 2019 Артур Азаров. All rights reserved.
//

import Foundation

enum CameraError: LocalizedError {

    case captureSessionIsMissing
    case inputsAreInvalid
    case invalidOperation
    case noCamerasAvailable
    case unknown

    var errorDescription: String? {
        switch self {
        case .captureSessionIsMissing: return "Capture Session Is Missing"
        case .inputsAreInvalid: return "Inputs Are Invalid"
        case .invalidOperation: return "Invalid Operation"
        case .noCamerasAvailable: return "No cameras available"
        case .unknown: return "Unknown error occured"
        }
    }
}
