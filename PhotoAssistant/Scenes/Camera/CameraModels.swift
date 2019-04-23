//
//  CameraModels.swift
//  PhotoAssistant
//
//  Created by Артур Азаров on 31.03.2018.
//  Copyright (c) 2018 Артур Азаров. All rights reserved.
//

import UIKit
import AVFoundation

enum Camera
{
    // MARK: Use cases
    
    enum Configure
    {
        struct Request {}
        
        struct Response
        {
            let error: Error?
        }
        struct ViewModel
        {
            let errorMessage: String?
        }
    }
    
    enum ShowPreview {
        struct Request {
            let size: CGRect
        }
        
        struct Response {
            let error: Error?
            let previewLayer: AVCaptureVideoPreviewLayer?
        }
        
        struct ViewModel {
            let errorMessage: String?
            let previewLayer: AVCaptureVideoPreviewLayer?
        }
    }
    
    enum UpdateOrientation {
        struct Request {}
        struct Response {
            let angle: CGFloat
        }
        struct ViewModel {
            let angle: CGFloat
        }
    }
    
    enum CaptureImage {
        struct Request {}
        struct Response {
            let imageData: Data?
            let error: Error?
        }
        struct ViewModel {
            let image: UIImage?
            let errorMessage: String?
        }
    }
    
    enum SwitchCameras {
        struct Request {}
        struct Response {
            let error: Error?
        }
        struct ViewModel {
            let errorMessage: String?
        }
    }
    
    enum ToggleFlashLight {
        struct Request {}
        struct Response {
            let state: AVCaptureDevice.FlashMode
        }
        struct ViewModel {
            let image: UIImage
        }
    }
    
    enum DrawFilter {
        struct Request {
            let item: Int
            let size: CGSize
        }
        struct Response {
            let image: UIImage
        }
        struct ViewModel {
            let image: UIImage
        }
    }
    
    enum KeepHorizonLine {
        struct Request {}
        struct Response {
            let rotation: Double
        }
        struct ViewModel {
            let rotationAngle: Double
            let strokeColor: UIColor
        }
    }
}
