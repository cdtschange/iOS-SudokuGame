//
//  GameWinView.swift
//  Sudoku
//
//  Created by 毛蔚 on 2020/9/30.
//  Copyright © 2020 Cdts. All rights reserved.
//

import SwiftUI

struct GameLoseView: View {
    
    var body: some View {
        VStack {
            Text("You Lose")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.top)
                .frame(width: 240, height: nil, alignment: .center)
        }
    }
}

struct GameLoseView_Previews: PreviewProvider {
    static var previews: some View {
        GameLoseView()
            .frame(height: 300)
            .background(Color(hex: "3d5a80"))
    }
}
