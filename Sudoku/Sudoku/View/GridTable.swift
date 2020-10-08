//
//  GridUnit.swift
//  Sudoku
//
//  Created by 毛蔚.
//  Copyright © 2020 Cdts. All rights reserved.
//

import SwiftUI

struct GridTable: View {
    var type: SudokuGame.GridType
    var cells: [DigitalCell]
    var onCellClicked: (DigitalCell) -> Void
    
    var body: some View {
        GeometryReader { geometry in
            self.body(for: geometry.size)
        }
    }
    private static var lastSelectIndex: Int?
    
    @ViewBuilder
    private func body(for size: CGSize) -> some View {
        ZStack(alignment: .center) {
            ZStack {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(lineWidth: lineWidth)
                Grid(items: cells) { cell in
                    GridCell(model: cell, size: self.cellSize(for: size), textColor: cellColor(for: cell), borderColor: .black)
                        .background(self.cellBackground(for: cell))
                        .onTapGesture {
                            withAnimation(.linear(duration: self.animationDuration)) {
                                self.onCellClicked(cell)
                            }
                            if !cell.isFixedValue {
                                DispatchQueue.main.asyncAfter(deadline: .now() + self.animationDuration) {
                                    GridTable.lastSelectIndex = cells.firstIndex(matching: cell)
                                }
                            }
                        }
                        .magnify(isSelected: cell.isSelected)
                        .zIndex(cell.isSelected == true ? 10 : GridTable.lastSelectIndex == cells.firstIndex(matching: cell) ? 5 : 0)
                }
            }
        }
            .frame(width: self.width(for: size), height: self.height(for: size), alignment: .center)
    }
    
    private let cornerRadius: CGFloat = 0
    private let lineWidth: CGFloat = 2
    private let animationDuration: Double = 0.25
    private let cellDarkBackgroundColor: Color = Color(red: 0.90, green: 1, blue: 1)
    private func cellBackground(for cell: DigitalCell) -> some View {
        switch type {
        case .nineNine:
            let index = cells.firstIndex(matching: cell)!
            if ([3, 4, 5].contains(index % 9) || [3, 4, 5].contains(index / 9)) &&
                !([3, 4, 5].contains(index % 9) && [3, 4, 5].contains(index / 9)) {
                return Rectangle().foregroundColor(cellDarkBackgroundColor)
            }
            return Rectangle().foregroundColor(.white)
        case .sixSix:
            let index = cells.firstIndex(matching: cell)!
            if ([0, 1, 2].contains(index % 6) &&
                    ![2, 3].contains(index / 6)) ||
                ([3, 4, 5].contains(index % 6) &&
                    [2, 3].contains(index / 6)) {
                return Rectangle().foregroundColor(cellDarkBackgroundColor)
            }
            return Rectangle().foregroundColor(.white)
        }
    }
    private func cellSize(for size: CGSize) -> CGSize {
        switch type {
        case .nineNine:
            return CGSize(width: self.width(for: size) / 9, height: self.height(for: size) / 9)
        case .sixSix:
            return CGSize(width: self.width(for: size) / 6, height: self.height(for: size) / 6)
        }
    }
    private func cellColor(for cell: DigitalCell) -> Color {
        if cell.isConflicted {
            return .red
        } else if cell.isDraft {
            return .gray
        } else {
            return .black
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
        var gameData = [DigitalCell]()
        for index in 1...81 {
            let value = Int.random(in: 1...9)
            gameData.append(DigitalCell(model: Sudoku9x9Cell(index: index), originalValue: value))
        }
        return GridTable(type: .nineNine, cells: gameData, onCellClicked: {_ in })
    }
}
