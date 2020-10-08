//
//  GameWinView.swift
//  Sudoku
//
//  Created by 毛蔚 on 2020/9/30.
//  Copyright © 2020 Cdts. All rights reserved.
//

import SwiftUI

struct GameWinView: View {
    @Binding var level: Int
    @Binding var time: Double
    @Binding var bestTime: Int?
    @Binding var newRecord: Bool
    
    var body: some View {
        VStack {
            Text("Congratulations")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.vertical)
            ZStack {
                Image("star")
                    .resizable()
                    .aspectRatio(contentMode: ContentMode.fit)
                    .padding(3)
                Circle()
                    .strokeBorder(Color.white,lineWidth: 3)
            }
                .frame(width: nil, height: 100)
                .padding(20)
            Text("You set a new record 🎉🎉🎉")
                .font(.body)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.vertical)
                .opacity(newRecord ? 1 : 0)
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
                    Text(SudokuGame.Level(rawValue: level)!.displayName)
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
                    Text(Int(time).timeDisplay)
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
                    Text(bestTime?.timeDisplay ?? "No record")
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
    @State static var level = SudokuGame.Level.easy.rawValue
    @State static var time = 80.0
    @State static var bestTime: Int? = 80
    @State static var newRecord = true
    static var previews: some View {
        GameWinView(level: $level, time: $time, bestTime: $bestTime, newRecord: $newRecord).background(Color(hex: "3d5a80"))
    }
}
