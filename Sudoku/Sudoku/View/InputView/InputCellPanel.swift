//
//  DigitalCellPanel.swift
//  Sudoku
//
//  Created by 毛蔚.
//  Copyright © 2020 Cdts. All rights reserved.
//

import SwiftUI

struct InputCellPanel: View {
    enum ActionType {
        case draft, clear, undo
    }
    var type: SudokuGame.GridType
    var isDraft: Bool
    var onDigitClicked: (Int) -> Void
    var onActionClicked: (ActionType) -> Void
    
    var digitalCells: [InputCell] {
        var cells = [InputCell]()
        switch type {
        case .nineNine:
            for index in 1...9 {
                cells.append(InputCell(value: index, isDraft: isDraft))
            }
        case .sixSix:
            for index in 1...6 {
                cells.append(InputCell(value: index, isDraft: isDraft))
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
        GeometryReader { geometry in
            LazyVGrid(columns: [.init(.flexible()),
                                .init(.flexible()),
                                .init(.flexible()),
                                .init(.flexible()),
                                .init(.flexible()),
                                .init(.flexible())]) {
                ForEach(digitalCells, id: \.self.value) { cell in
                    cell
                        .frame(height: size.height / 2)
                        .onTapGesture {
                        self.onDigitClicked(cell.value)
                    }
                }
                                    
                ActionCell(icon: Image(systemName: "pencil"), title: "Draft: \(isDraft ? "ON" : "OFF")")
                    .frame(height: size.height / 2)
                    .onTapGesture {
                        self.onActionClicked(.draft)
                }
                                    
                ActionCell(icon: Image(systemName: "trash"), title: "Clear")
                    .frame(height: size.height / 2)
                    .onTapGesture {
                        self.onActionClicked(.clear)
                    }
                                    
                                                        
                ActionCell(icon: Image(systemName: "arrow.uturn.backward.circle"), title: "Undo")
                    .frame(height: size.height / 2)
                    .onTapGesture {
                        self.onActionClicked(.undo)
                    }
            }
            .frame(width: geometry.size.width,
                   height: geometry.size.height)
        }
    }
}

struct InputCellPanel_Previews: PreviewProvider {
    static var previews: some View {
        InputCellPanel(type: .nineNine, isDraft: true, onDigitClicked: { _ in }, onActionClicked: { action in
            
        }).frame(width: nil, height: 100, alignment: .center).padding()
    }
}
