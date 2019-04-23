//
//  PhotoModels.swift
//  PhotoAssistant
//
//  Created by Артур Азаров on 03.04.2018.
//  Copyright (c) 2018 Артур Азаров. All rights reserved.
//

import UIKit

enum Photo {

    // MARK: Use cases

    enum ShowPhoto {
        struct Request {
            
        }
        struct Response {
            let imageData: Data
        }
        struct ViewModel {
            let image: UIImage
        }
    }
}
