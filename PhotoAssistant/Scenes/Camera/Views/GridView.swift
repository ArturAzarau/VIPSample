//
//  GridView.swift
//  PhotoAssistant
//
//  Created by Артур Азаров on 03.04.2018.
//  Copyright © 2018 Артур Азаров. All rights reserved.
//

import UIKit

final class GridView: UIView {
    override func draw(_ rect: CGRect) {
        let filterDrawer = DrawFiltersWorker(size: bounds.size, item: 0)
        let _ = filterDrawer.drawFilter()
    }
}
