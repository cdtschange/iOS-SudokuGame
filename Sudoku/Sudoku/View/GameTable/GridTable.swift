//
//  GridUnit.swift
//  Sudoku
//
//  Created by 毛蔚.
//  Copyright © 2020 Cdts. All rights reserved.
//

import SwiftUI

struct GridTable: View {
    @ObservedObject var viewModel: SudokuGameViewModel
    var type: SudokuGame.GridType
    var cells: [DigitalCell]
    var onCellClicked: (DigitalCell) -> Void
    
    var body: some View {
        GeometryReader { geometry in
            self.body(for: geometry.size)
        }
    }
    
    @ViewBuilder
    private func body(for size: CGSize) -> some View {
        ZStack(alignment: .center) {
            ZStack {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(lineWidth: lineWidth)
                    .background(Color.black)
                Grid(items: cells) { cell in
                    GridCell(viewModel: viewModel, model: cell, size: self.cellSize(for: size))
                        .onTapGesture {
                            self.onCellClicked(cell)
                        }
                }
                path(for: size)
            }
        }
            .frame(width: self.width(for: size), height: self.height(for: size), alignment: .center)
    }
    
    private let cornerRadius: CGFloat = 0
    private let lineWidth: CGFloat = 2
    private func cellSize(for size: CGSize) -> CGSize {
        switch type {
        case .nineNine:
            return CGSize(width: self.width(for: size) / 9, height: self.height(for: size) / 9)
        case .sixSix:
            return CGSize(width: self.width(for: size) / 6, height: self.height(for: size) / 6)
        }
    }
    @ViewBuilder
    private func path(for size: CGSize) -> some View {
        switch type {
        case .nineNine:
            Group {
                Path() { path in
                    path.move(to: CGPoint(x: 0, y: self.height(for: size) / 3))
                    path.addLine(to: CGPoint(x: self.width(for: size), y: self.height(for: size) / 3))
                }
                .stroke(Color.black, lineWidth: 2)
                Path() { path in
                    path.move(to: CGPoint(x: 0, y: self.height(for: size) * 2 / 3))
                    path.addLine(to: CGPoint(x: self.width(for: size), y: self.height(for: size) * 2 / 3))
                }
                .stroke(Color.black, lineWidth: 2)
                Path() { path in
                    path.move(to: CGPoint(x: self.width(for: size) / 3, y: 0))
                    path.addLine(to: CGPoint(x: self.width(for: size) / 3, y: self.height(for: size)))
                }
                .stroke(Color.black, lineWidth: 2)
                Path() { path in
                    path.move(to: CGPoint(x: self.width(for: size) * 2 / 3, y: 0))
                    path.addLine(to: CGPoint(x: self.width(for: size) * 2 / 3, y: self.height(for: size)))
                }
                .stroke(Color.black, lineWidth: 2)
            }
        case .sixSix:
            Group {
                Path() { path in
                    path.move(to: CGPoint(x: 0, y: self.height(for: size) / 3))
                    path.addLine(to: CGPoint(x: self.width(for: size), y: self.height(for: size) / 3))
                }
                .stroke(Color.black, lineWidth: 2)
                Path() { path in
                    path.move(to: CGPoint(x: 0, y: self.height(for: size) * 2 / 3))
                    path.addLine(to: CGPoint(x: self.width(for: size), y: self.height(for: size) * 2 / 3))
                }
                .stroke(Color.black, lineWidth: 2)
                Path() { path in
                    path.move(to: CGPoint(x: self.width(for: size) / 2, y: 0))
                    path.addLine(to: CGPoint(x: self.width(for: size) / 2, y: self.height(for: size)))
                }
                .stroke(Color.black, lineWidth: 2)
            }
        }
    }
    private func width(for size: CGSize) -> CGFloat {
        switch type {
        case .nineNine:
            return minLength(for: size)
        case .sixSix:
            return minLength(for: size)
        }
    }
    private func height(for size: CGSize) -> CGFloat {
        switch type {
        case .nineNine:
            return minLength(for: size)
        case .sixSix:
            return minLength(for: size)
        }
    }
    private func minLength(for size: CGSize) -> CGFloat {
        return min(size.width, size.height)
    }
}

struct GridTable_Previews: PreviewProvider {
    static var previews: some View {
        var cells = [DigitalCell]()
        for index in 1...81 {
            let value = Int.random(in: 1...9)
            let isOriginal = Bool.random()
            cells.append(DigitalCell(model: Sudoku9x9Cell(index: index, value: value), isOriginal: isOriginal))
        }
        return GridTable(viewModel: SudokuGameViewModel(type: .nineNine, level: .normal, music: true, battle: false), type: .nineNine, cells: cells, onCellClicked: {_ in })
    }
}
