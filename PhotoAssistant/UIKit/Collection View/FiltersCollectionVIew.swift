//
//  FiltersCollectionVIew.swift
//  PhotoAssistant
//
//  Created by Артур Азаров on 17.03.2018.
//  Copyright © 2018 Артур Азаров. All rights reserved.
//

import UIKit

final class FiltersCollectionVIew: UICollectionView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 10
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        backgroundView = blurredEffectView
    }
}
