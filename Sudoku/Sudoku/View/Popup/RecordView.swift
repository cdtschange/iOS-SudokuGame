//
//  RecordView.swift
//  Sudoku
//
//  Created by 毛蔚 on 2020/9/30.
//  Copyright © 2020 Cdts. All rights reserved.
//

import SwiftUI

struct RecordView: View {
    @Binding var type: Int
    @Binding var bestRecordEasy9: Int?
    @Binding var bestRecordNormal9: Int?
    @Binding var bestRecordHard9: Int?
    @Binding var bestRecordEasy6: Int?
    @Binding var bestRecordNormal6: Int?
    @Binding var bestRecordHard6: Int?
    
    var easyRecord: String {
        let gridType = SudokuGame.GridType(rawValue: type)!
        var time = 0
        switch gridType {
        case .nineNine:
            time = bestRecordEasy9 ?? 0
        case .sixSix:
            time = bestRecordEasy6 ?? 0
        }
        return time.timeDisplay
    }
    var normalRecord: String {
        let gridType = SudokuGame.GridType(rawValue: type)!
        var time = 0
        switch gridType {
        case .nineNine:
            time = bestRecordNormal9 ?? 0
        case .sixSix:
            time = bestRecordNormal6 ?? 0
        }
        return time.timeDisplay
    }
    var hardRecord: String {
        let gridType = SudokuGame.GridType(rawValue: type)!
        var time = 0
        switch gridType {
        case .nineNine:
            time = bestRecordHard9 ?? 0
        case .sixSix:
            time = bestRecordHard6 ?? 0
        }
        return time.timeDisplay
    }
    
    var types = SudokuGame.GridType.allCases
    
    var body: some View {
        VStack {
            Text("Best Record")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.vertical)
            ZStack {
                Image("best")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(.white)
                    .aspectRatio(contentMode: ContentMode.fit)
                    .padding(10)
                Circle()
                    .strokeBorder(Color.white,lineWidth: 3)
            }
                .frame(width: nil, height: 100)
                .padding(10)
            Spacer()
            VStack(spacing: 8) {
                Picker("Game Type", selection: $type) {
                    ForEach(0 ..< self.types.count) { index in
                        Text(self.types[index].displayName).tag(index)
                    }
                    }.pickerStyle(SegmentedPickerStyle())
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                HStack {
                    Text("Easy")
                        .font(.body)
                        .foregroundColor(.white)
                    Spacer()
                    Text(easyRecord)
                        .font(.body)
                        .foregroundColor(.white)
                }
                Rectangle()
                    .frame(width: nil, height: 1, alignment: .center)
                    .foregroundColor(.white)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
                HStack {
                    Text("Normal")
                        .font(.body)
                        .foregroundColor(.white)
                    Spacer()
                    Text(normalRecord)
                        .font(.body)
                        .foregroundColor(.white)
                }
                Rectangle()
                    .frame(width: nil, height: 1, alignment: .center)
                    .foregroundColor(.white)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
                HStack {
                    Text("Hard")
                        .font(.body)
                        .foregroundColor(.white)
                    Spacer()
                    Text(hardRecord)
                        .font(.body)
                        .foregroundColor(.white)
                }
                Rectangle()
                    .frame(width: nil, height: 1, alignment: .center)
                    .foregroundColor(.white)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
            }
            .padding()
            .frame(width: 240, height: nil, alignment: .center)
        }
    }
}

struct RecordView_Previews: PreviewProvider {
    @State static var type = 1
    @State static var bestRecordEasy9: Int? = 80
    @State static var bestRecordNormal9: Int? = 0
    @State static var bestRecordHard9: Int? = 80
    @State static var bestRecordEasy6: Int? = 80
    @State static var bestRecordNormal6: Int? = 80
    @State static var bestRecordHard6: Int? = 0
    static var previews: some View {
        RecordView(type: $type, bestRecordEasy9: $bestRecordEasy9, bestRecordNormal9: $bestRecordNormal9, bestRecordHard9: $bestRecordHard9, bestRecordEasy6: $bestRecordEasy6, bestRecordNormal6: $bestRecordNormal6, bestRecordHard6: $bestRecordHard6).background(Color(hex: "3d5a80"))
    }
}
