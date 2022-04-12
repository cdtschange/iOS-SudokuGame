//
//  InputCell.swift
//  Sudoku
//
//  Created by 毛蔚 on 2022/4/3.
//  Copyright © 2022 Cdts. All rights reserved.
//

import SwiftUI

struct InputCell: View {
    var value: Int
    var isDraft: Bool
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .foregroundColor(Color(hex: "dcdcdc"))
                Text("\(value)")
                    .font(chalkFont(with: fontSize(for: geometry.size)))
                    .foregroundColor(Color.black)
                HStack {
                    Spacer()
                    VStack {
                        Image(systemName: "pencil.circle.fill")
                            .font(Font.system(size: iconSize(for: geometry.size)))
                            .foregroundColor(Color(hex: "808080"))
                            .padding(5)
                        Spacer()
                    }
                }
                .opacity(isDraft ? 1 : 0)
            }
        }
    }
    
    private func iconSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * 0.2
    }
    private func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * 0.7
    }
    private func chalkFont(with size: CGFloat) -> Font {
        return Font.custom("ChalkBoard SE", size: size)
    }
}

struct InputCell_Previews: PreviewProvider {
    static var previews: some View {
        InputCell(value: 1, isDraft: true)
    }
}
