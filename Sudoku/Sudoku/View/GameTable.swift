//
//  GameTable.swift
//  Sudoku
//
//  Created by 毛蔚.
//  Copyright © 2020 Cdts. All rights reserved.
//

import SwiftUI

struct GameTable: View {
    @ObservedObject var viewModel: SudokuGameViewModel
    
    @State private var level: Int = 0
    @State private var type: Int = 0
    @State private var isDraftValue: Int = 0
    @State private var timeCost = 0.0
    @State private var showingRecord: Bool = false
    private var isDraft: Bool { isDraftValue > 0 }
    var cells: [DigitalCell] {
        viewModel.cells
    }
    var levels = SudokuGame.Level.allCases
    var types = SudokuGame.GridType.allCases
    
    var backgroundPlayer = Sounds()
    
    init(viewModel: SudokuGameViewModel) {
        self.viewModel = viewModel
        backgroundPlayer.playSounds(with: .background, needRepeat: true)
    }
    
    var body: some View {
        GeometryReader { geometry in
            self.body(for: geometry.size)
        }
    }
    
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()

    func record(by type: SudokuGame.GridType, level: SudokuGame.Level) -> Binding<Int?> {
        switch type {
        case .nineNine:
            switch level {
            case .easy:
                return $viewModel.bestRecordEasy9
            case .normal:
                return $viewModel.bestRecordNormal9
            case .hard:
                return $viewModel.bestRecordHard9
            }
        case .sixSix:
            switch level {
            case .easy:
                return $viewModel.bestRecordEasy6
            case .normal:
                return $viewModel.bestRecordNormal6
            case .hard:
                return $viewModel.bestRecordHard6
            }
        }
    }
    
    private func chalkFont(with size: CGFloat) -> Font {
        return Font.custom("ChalkBoard SE", size: size)
    }
    
    @ViewBuilder
    private func body(for size: CGSize) -> some View {
        ZStack {
            VStack(alignment: .leading) {
                HStack(alignment: .bottom) {
                    Text("Sudoku").font(chalkFont(with: 32).bold())
                        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                            self.backgroundPlayer.pause()
                        }
                        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                            self.backgroundPlayer.resume()
                        }
                    Spacer(minLength: 20)
                    Button(action: {
                        self.showingRecord = true
                    }, label: {
                        Image("best")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.black)
                            .aspectRatio(contentMode: ContentMode.fit)
                            .frame(width: nil, height: 20)
                    })
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
                    Text("\(timeCost.timeDisplayForTimer)").font(Font.custom("Helvetica", size: 18)).foregroundColor(.gray)
                        .onReceive(timer) { _ in
                            if !viewModel.gameCompletion {
                                timeCost += 0.5
                            }
                        }
                }
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0))
                HStack {
                    Picker("Game Level", selection: $level) {
                        ForEach(0 ..< self.levels.count) { index in
                            Text(self.levels[index].displayName).tag(index)
                        }
                        }.pickerStyle(SegmentedPickerStyle())
                    Button(action: {
                        self.timeCost = 0
                        self.viewModel.newGame(type: SudokuGame.GridType(rawValue: type)!, level: SudokuGame.Level(rawValue: level)!)
                    }, label: {
                        Text("New Game").font(chalkFont(with: 16)).foregroundColor(.white).frame(width: 100, height: 30, alignment: .center)
                            .background(Color.blue)
                            .cornerRadius(5)
                    })
                }
                HStack {
                    Picker("Game Type", selection: $type) {
                        ForEach(0 ..< self.types.count) { index in
                            Text(self.types[index].displayName).tag(index)
                        }
                        }.pickerStyle(SegmentedPickerStyle())
                }
                Spacer(minLength: 20)
                GridTable(type: self.viewModel.type, cells: cells) { cell in
                    self.viewModel.select(cell: cell)
                }
                HStack {
                    Text("Select Digit")
                        .font(chalkFont(with: 18))
                        .foregroundColor(.orange)
                    Spacer()
                    Picker("Draft Model", selection: $isDraftValue) {
                        ForEach(0 ..< 2) { index in
                            Text(["Formal", "Draft"][index]).tag(index)
                        }
                        }.pickerStyle(SegmentedPickerStyle())
                    .frame(width: 120, height: nil, alignment: .center)
                    Button(action: {
                        print("Clear")
                        self.viewModel.choose(number: nil, isDraft: isDraft)
                    }, label: {
                        Text("Clear").font(chalkFont(with: 16)).foregroundColor(.white).frame(width: 60, height: 30, alignment: .center)
                            .background(Color.orange)
                            .cornerRadius(5)
                    })
                }
                DigitalCellPanel(type: self.viewModel.type, onDigitClicked: { digit in
                    print("Select Digit: \(digit)")
                    self.viewModel.choose(number: digit, isDraft: isDraft)
                }).frame(width: nil, height: 36, alignment: .center)
                Spacer()
            }.padding()
            .popup(isPresented: $viewModel.showCongratulations, type: .`default`, closeOnTap: false) {
                createPopupCongratulations()
            }
            .popup(isPresented: $showingRecord, type: .`default`, closeOnTap: false) {
                createPopupRecord()
            }
        }
    }
    
    func createPopupCongratulations() -> some View {
        VStack(spacing: 10) {
            GameWinView(level: $level, time: $timeCost, bestTime: record(by: self.viewModel.type, level: self.viewModel.level), newRecord: $viewModel.breakRecord)
                .frame(width: 280, height: 360)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 40, trailing: 0))

            Button(action: {
                self.viewModel.showCongratulations = false
            }) {
                Text("Continue")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(self.popupBackgroundColor)
            }
            .frame(width: 200, height: 40)
            .background(Color.white)
            .cornerRadius(20.0)
        }
        .padding(EdgeInsets(top: 70, leading: 20, bottom: 40, trailing: 20))
        .background(self.popupBackgroundColor)
        .cornerRadius(10.0)
        .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.13), radius: 10.0)
    }
    func createPopupRecord() -> some View {
        VStack(spacing: 10) {
            RecordView(type: $type, bestRecordEasy9: $viewModel.bestRecordEasy9, bestRecordNormal9: $viewModel.bestRecordNormal9, bestRecordHard9: $viewModel.bestRecordHard9, bestRecordEasy6: $viewModel.bestRecordEasy6, bestRecordNormal6: $viewModel.bestRecordNormal6, bestRecordHard6: $viewModel.bestRecordHard6)
                .frame(width: 280, height: 300)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 40, trailing: 0))

            Button(action: {
                self.showingRecord = false
            }) {
                Text("Got it")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(self.popupBackgroundColor)
            }
            .frame(width: 200, height: 40)
            .background(Color.white)
            .cornerRadius(20.0)
        }
        .padding(EdgeInsets(top: 70, leading: 20, bottom: 40, trailing: 20))
        .background(self.popupBackgroundColor)
        .cornerRadius(10.0)
        .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.13), radius: 10.0)
    }
    
    private let popupBackgroundColor = Color(hex: "3d5a80")
}

struct GameTable_Previews: PreviewProvider {
    static var previews: some View {
        var gameData = [DigitalCell]()
        for index in 1...81 {
            let value = Int.random(in: 1...9)
            gameData.append(DigitalCell(model: Sudoku9x9Cell(index: index), originalValue: value))
        }
        let viewModel = SudokuGameViewModel()
        viewModel.select(cell: gameData[0])
        return GameTable(viewModel: viewModel)
    }
}
