//
//  GridCellMagnify.swift
//  Sudoku
//
//  Created by 毛蔚.
//  Copyright © 2020 Cdts. All rights reserved.
//

import SwiftUI

struct GridCellMagnify: AnimatableModifier {
    var scale: CGFloat
    
    init(isSelected: Bool) {
        self.scale = isSelected ? magnifyScale : 1
    }
    
    var isSelected: Bool {
        scale > 1
    }
    
    var animatableData: CGFloat {
        get { return scale }
        set { scale = newValue }
    }
    
    func body(content: Content) -> some View {
        ZStack {
            Group {
                RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(lineWidth: edgeLineWidth)
                content
            }
                .opacity(isSelected ? 1 : 0)
            Group {
                content
            }
                .opacity(isSelected ? 0 : 1)
        }
        .scaleEffect(scale)
    }
    
    private let cornerRadius: CGFloat = 0
    private let edgeLineWidth: CGFloat = 2
    private let magnifyScale: CGFloat = 1.2
}

extension View {
    func magnify(isSelected: Bool) -> some View {
        self.modifier(GridCellMagnify(isSelected: isSelected))
    }
}

