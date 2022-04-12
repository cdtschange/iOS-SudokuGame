//
//  GridCell.swift
//  Sudoku
//
//  Created by 毛蔚.
//  Copyright © 2020 Cdts. All rights reserved.
//

import SwiftUI

struct DraftItem: Identifiable {
    var id: Int
}

struct GridCell: View {
    @ObservedObject var viewModel: SudokuGameViewModel
    var model: DigitalCell
    var size: CGSize
    var normalTextColor: Color = Color(hex: "21abcd")
    var errorTextColor: Color = Color(hex: "a52a2a")
    var draftTextColor: Color = Color(hex: "848482")
    var originalTextColor: Color = .black
    var normalBgColor: Color = .white
    var selectedBgColor: Color = Color(hex: "a4c639")
    var relatedBgColor: Color = Color(hex: "f5f5dc")
    var sameValueBgColor: Color = Color(hex: "5d8aa8")
    var borderColor: Color = .black
    
    var body: some View {
        self.body(for: size)
    }
    
    private func body(for size: CGSize) -> some View {
        return ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(lineWidth: lineWidth)
                .foregroundColor(borderColor)
            Text(model.displayValue)
                .font(chalkFont(with: fontSize(for: size)))
                .foregroundColor(textColor)
                .opacity(model.drafts.isEmpty ? 1 : 0)
            Group {
                Grid(items: Array(1...9).map { DraftItem(id: $0) }) { item in
                    Text("\(item.id)")
                            .font(chalkFont(with: draftFontSize(for: size)))
                            .foregroundColor(draftTextColor)
                            .opacity(model.drafts.contains(item.id) ? 1 : 0)
                }
            }
            .frame(width: size.width, height: size.height)
        }
        .frame(width: size.width,
               height: size.height)
        .background(backgroundColor)
    }
    
    private let cornerRadius: CGFloat = 0
    private let lineWidth: CGFloat = 1
    private func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * 0.7
    }
    private func draftFontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * 0.3
    }
    private func chalkFont(with size: CGFloat) -> Font {
        return Font.custom("ChalkBoard SE", size: size)
    }
    private var textColor: Color {
        if model.isOriginal {
            return originalTextColor
        } else if model.isConflicted {
            return errorTextColor
        }
        return normalTextColor
    }
    private var backgroundColor: Color {
        if model.isSelected {
            return selectedBgColor
        } else if model.isSameValue {
            return sameValueBgColor
        } else if model.isRelated {
            return relatedBgColor
        }
        return normalBgColor
    }
}

struct GridCell_Previews: PreviewProvider {
    static var previews: some View {
        var model = DigitalCell(model: Sudoku9x9Cell(index: 1, value: 1), isOriginal: true)
        model.isSameValue = false
        model.drafts = [1, 4, 8]
        return GridCell(viewModel: SudokuGameViewModel(type: .nineNine, level: .normal, music: true, battle: false), model: model, size: CGSize(width: 100, height: 100))
    }
}
