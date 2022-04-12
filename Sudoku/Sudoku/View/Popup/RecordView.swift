//
//  RecordView.swift
//  Sudoku
//
//  Created by 毛蔚 on 2020/9/30.
//  Copyright © 2020 Cdts. All rights reserved.
//

import SwiftUI

struct RecordView: View {
    let type: SudokuGame.GridType
    let bestRecordEasy: Int?
    let bestRecordNormal: Int?
    let bestRecordHard: Int?
    
    var easyRecord: String {
        let time = bestRecordEasy ?? 0
        return time.recordTime
    }
    var normalRecord: String {
        let time = bestRecordNormal ?? 0
        return time.recordTime
    }
    var hardRecord: String {
        let time = bestRecordHard ?? 0
        return time.recordTime
    }
    
    var types = SudokuGame.GridType.allCases
    
    var body: some View {
        VStack {
            Text("Best Record")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.top)
            Text(type.displayName)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.bottom)
            Spacer()
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
    static let bestRecordEasy: Int? = 80
    static let bestRecordNormal: Int? = 0
    static let bestRecordHard: Int? = 80
    static var previews: some View {
        RecordView(type: .nineNine, bestRecordEasy: bestRecordEasy, bestRecordNormal: bestRecordNormal, bestRecordHard: bestRecordHard).background(Color(hex: "3d5a80"))
    }
}
