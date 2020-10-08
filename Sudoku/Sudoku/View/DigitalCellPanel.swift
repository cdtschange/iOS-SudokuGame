//
//  DigitalCellPanel.swift
//  Sudoku
//
//  Created by 毛蔚.
//  Copyright © 2020 Cdts. All rights reserved.
//

import SwiftUI

struct DigitalCellPanel: View {
    var type: SudokuGame.GridType
    var onDigitClicked: (Int) -> Void
    
    var digitalCells: [DigitalCell] {
        var cells = [DigitalCell]()
        switch type {
        case .nineNine:
            for index in 1...9 {
                cells.append(DigitalCell(model: Sudoku9x9Cell(index: index, value: index), originalValue: index))
            }
        case .sixSix:
            for index in 1...6 {
                cells.append(DigitalCell(model: Sudoku6x9Cell(index: index, value: index), originalValue: index))
            }
        }
        return cells
    }
    
    var body: some View {
        GeometryReader { geometry in
            self.body(for: geometry.size)
        }
    }
    
    @ViewBuilder
    private func body(for size: CGSize) -> some View {
        ZStack {
            HStack(spacing: 0) {
                ForEach(digitalCells) { cell in
                    GridCell(model: cell, size: size, textColor: .black, borderColor: .orange)
                        .onTapGesture {
                            if let value = cell.inputValue {
                                self.onDigitClicked(value)
                            }
                        }
                }
            }
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(lineWidth: lineWidth).foregroundColor(Color.orange)
        }
    }
    
    private let cornerRadius: CGFloat = 0
    private let lineWidth: CGFloat = 2
}

struct DigitalCellPanel_Previews: PreviewProvider {
    static var previews: some View {
        DigitalCellPanel(type: .nineNine, onDigitClicked: { _ in }).frame(width: nil, height: 40, alignment: .center).padding()
    }
}
