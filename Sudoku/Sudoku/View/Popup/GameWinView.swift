//
//  GameWinView.swift
//  Sudoku
//
//  Created by 毛蔚 on 2020/9/30.
//  Copyright © 2020 Cdts. All rights reserved.
//

import SwiftUI

struct GameWinView: View {
    let level: SudokuGame.Level
    let time: Int
    let bestTime: Int?
    let newRecord: Bool
    
    var body: some View {
        VStack {
            Text("Congratulations")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.top)
            if newRecord {
                Text("You set a new record 🎉🎉🎉")
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.vertical)
            }
            ZStack {
                Image("star")
                    .resizable()
                    .aspectRatio(contentMode: ContentMode.fit)
                    .padding(3)
                Circle()
                    .strokeBorder(Color.white,lineWidth: 3)
            }
                .frame(width: nil, height: 100)
            Spacer()
            VStack(spacing: 8) {
                HStack {
                    Image("level")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.white)
                        .aspectRatio(contentMode: ContentMode.fit)
                        .frame(width: nil, height: 20)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
                    Text("Difficulty")
                        .font(.body)
                        .foregroundColor(.white)
                    Spacer()
                    Text(level.displayName)
                        .font(.body)
                        .foregroundColor(.white)
                }
                Rectangle()
                    .frame(width: nil, height: 1, alignment: .center)
                    .foregroundColor(.white)
                    .padding(EdgeInsets(top: 0, leading: 34, bottom: 10, trailing: 0))
                HStack {
                    Image("clock")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.white)
                        .aspectRatio(contentMode: ContentMode.fit)
                        .frame(width: nil, height: 20)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
                    Text("Time")
                        .font(.body)
                        .foregroundColor(.white)
                    Spacer()
                    Text(time.recordTime)
                        .font(.body)
                        .foregroundColor(.white)
                }
                Rectangle()
                    .frame(width: nil, height: 1, alignment: .center)
                    .foregroundColor(.white)
                    .padding(EdgeInsets(top: 0, leading: 34, bottom: 10, trailing: 0))
                HStack {
                    Image("best")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.white)
                        .aspectRatio(contentMode: ContentMode.fit)
                        .frame(width: nil, height: 20)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
                    Text("Best Time")
                        .font(.body)
                        .foregroundColor(.white)
                    Spacer()
                    Text((bestTime ?? 0).recordTime)
                        .font(.body)
                        .foregroundColor(.white)
                }
                Rectangle()
                    .frame(width: nil, height: 1, alignment: .center)
                    .foregroundColor(.white)
                    .padding(EdgeInsets(top: 0, leading: 34, bottom: 10, trailing: 0))
            }
                .padding()
                .frame(width: 240, height: nil, alignment: .center)
        }
    }
}

struct GameWinView_Previews: PreviewProvider {
    static let time = 80
    static let bestTime: Int? = nil
    static let newRecord = true
    static var previews: some View {
        GameWinView(level: .easy, time: time, bestTime: bestTime, newRecord: newRecord).background(Color(hex: "3d5a80"))
            .frame(height: 300)
    }
}
