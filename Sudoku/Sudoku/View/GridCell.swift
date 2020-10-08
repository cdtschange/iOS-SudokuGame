//
//  GridCell.swift
//  Sudoku
//
//  Created by 毛蔚.
//  Copyright © 2020 Cdts. All rights reserved.
//

import SwiftUI

struct GridCell: View {
    var model: DigitalCell
    var size: CGSize
    var textColor: Color
    var borderColor: Color
    
    var body: some View {
        self.body(for: size)
    }
    
    @ViewBuilder
    private func body(for size: CGSize) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(lineWidth: lineWidth)
                .foregroundColor(borderColor)
            Text(model.displayValue)
                .font(chalkFont(with: fontSize(for: size)))
                .foregroundColor(textColor)
        }
            .magnify(isSelected: model.isSelected)
            .transition(AnyTransition.scale)
    }
    
    private let cornerRadius: CGFloat = 0
    private let lineWidth: CGFloat = 1
    private func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * 0.7
    }
    private func chalkFont(with size: CGFloat) -> Font {
        return Font.custom("ChalkBoard SE", size: size)
    }
}

struct GridCell_Previews: PreviewProvider {
    static var previews: some View {
        let model = DigitalCell(model: Sudoku9x9Cell(index: 1), originalValue: 1)
        return GridCell(model: model, size: CGSize(width: 100, height: 100), textColor: .black, borderColor: .orange)
    }
}
