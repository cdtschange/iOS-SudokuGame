//
//  ActionCell.swift
//  Sudoku
//
//  Created by 毛蔚 on 2022/4/3.
//  Copyright © 2022 Cdts. All rights reserved.
//

import SwiftUI

struct ActionCell: View {
    let icon: Image
    let title: String
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .foregroundColor(Color(hex: "dcdcdc"))
                
                VStack(alignment: .center, spacing: 0) {
                    icon
                        .font(Font.system(size: 24))
                        .frame(height: 25)
                        .foregroundColor(Color.black)
                        .padding(.vertical, 5)
                    Text(title)
                        .font(Font.system(size: 7))
                        .foregroundColor(Color.black)
                        .padding(.horizontal, 2)
                }
                .frame(height: geometry.size.height)
            }
        }
    }
}

struct ActionCell_Previews: PreviewProvider {
    static var previews: some View {
        ActionCell(icon: Image(systemName: "pencil"), title: "Draft: ON")
            .frame(height: 50)
    }
}
