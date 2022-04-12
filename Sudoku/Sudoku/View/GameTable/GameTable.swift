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
    @ObservedObject var bluetoothViewModel = BluetoothViewModel()
    
    @Environment(\.presentationMode) var presentationMode
    @State private var devicesViewIsPresented = false
    @State private var isDraft: Bool = false
    @State private var showingRecord: Bool = false
    @State private var confirmationShown: Bool = false
    @State private var showingFailure: Bool = false
    @State private var battleProgress: Double = 0
    @State private var isReady: Bool = false
    
    private var owner = false
    
    var cells: [DigitalCell] {
        viewModel.cells
    }
    
    init(type: SudokuGame.GridType, level: SudokuGame.Level, music: Bool, battle: Bool, owner: Bool) {
        viewModel = SudokuGameViewModel(type: type, level: level, music: music, battle: battle)
        self.owner = owner
    }
    
    var body: some View {
        GeometryReader { geometry in
            self.body(for: geometry.size)
        }
    }

    func record(by type: SudokuGame.GridType, level: SudokuGame.Level) -> Int? {
        switch level {
        case .easy:
            return viewModel.bestRecordEasy
        case .normal:
            return viewModel.bestRecordNormal
        case .hard:
            return viewModel.bestRecordHard
        }
    }
    
    private func chalkFont(with size: CGFloat) -> Font {
        return Font.custom("ChalkBoard SE", size: size)
    }
    
    @ViewBuilder
    private func body(for size: CGSize) -> some View {
        ZStack {
            if isReady {
                ZStack {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(alignment: .bottom) {
                            Text("Sudoku").font(chalkFont(with: 32).bold())
                            Spacer()
                            Text(viewModel.level.displayName).font(chalkFont(with: 14))
                                .padding(.trailing, 4)
                            Button(action: {
                                confirmationShown = true
                            }, label: {
                                Image(systemName: "figure.walk")
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundColor(.black)
                                    .aspectRatio(contentMode: ContentMode.fit)
                                    .frame(height: 14)
                            })
                            .padding(.bottom, 2)
                            .padding(.trailing, 5)
                            if !self.viewModel.battle {
                                Button(action: {
                                    self.viewModel.pause()
                                }, label: {
                                    Image(systemName: self.viewModel.paused ? "play.circle" : "pause.circle")
                                        .resizable()
                                        .renderingMode(.template)
                                        .foregroundColor(.black)
                                        .aspectRatio(contentMode: ContentMode.fit)
                                        .frame(height: 14)
                                })
                                .padding(.bottom, 2)
                                .padding(.trailing, 5)
                            }
                            Button(action: {
                                self.showingRecord = true
                            }, label: {
                                Image("best")
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundColor(.black)
                                    .aspectRatio(contentMode: ContentMode.fit)
                                    .frame(height: 14)
                            })
                            .padding(.bottom, 2)
                            Text("\(viewModel.time.displayTime)").font(Font.custom("Helvetica", size: 16)).foregroundColor(.gray)
                        }
                        VStack(spacing: 0) {
                            ProgressView(value: viewModel.progress, total: 1)
                            if viewModel.battle {
                                ProgressView(value: battleProgress, total: 1)
                                    .accentColor(.red)
                                    .padding(.top, 2)
                            }
                        }
                        Spacer(minLength: 5)
                        GridTable(viewModel: viewModel, type: self.viewModel.type, cells: cells) { cell in
                            self.viewModel.select(cell: cell)
                        }
                        .blur(radius: self.viewModel.paused ? 5 : 0)
                        .frame(maxHeight: min(size.width, size.height))
                        InputCellPanel(type: self.viewModel.type, isDraft: isDraft, onDigitClicked: { digit in
                            print("Select Digit: \(digit)")
                            self.viewModel.input(value: digit)
                            let bt = BTData(type: BTDataType.update.rawValue, data: nil, progress: viewModel.progress, gridType: nil, level: nil)
                            let encoder = PropertyListEncoder()
                            if let data = try? encoder.encode(bt) {
                                bluetoothViewModel.send(data: data)
                            }
                        }, onActionClicked: { action in
                            switch action {
                            case .draft:
                                isDraft.toggle()
                                self.viewModel.isDraft.toggle()
                            case .clear:
                                self.viewModel.clearSelectedValue()
                            case .undo:
                                self.viewModel.undo()
                            }
                            let bt = BTData(type: BTDataType.update.rawValue, data: nil, progress: viewModel.progress, gridType: nil, level: nil)
                            let encoder = PropertyListEncoder()
                            if let data = try? encoder.encode(bt) {
                                bluetoothViewModel.send(data: data)
                            }
                        }).frame(height: 100)
                        Spacer()
                    }.padding()
                    .popup(isPresented: $viewModel.showCongratulations, type: .`default`, closeOnTap: false) {
                        createPopupCongratulations()
                    }
                    .popup(isPresented: $showingFailure, type: .`default`, closeOnTap: false) {
                        createPopupLoseGame()
                    }
                    .popup(isPresented: $showingRecord, type: .`default`, closeOnTap: false) {
                        createPopupRecord()
                    }
                }
                
        //        .sheet(isPresented: $devicesViewIsPresented) {
        //            DevicesView(peripheral: $bluetoothViewModel.peripheral) { peripheral in
        //                bluetoothViewModel.connect(with: peripheral)
        //            }
        //        }
                .alert("Are you sure to exit?", isPresented: $confirmationShown) {
                    Button("Yes", role: .destructive) {
                        self.viewModel.stop()
                        presentationMode.wrappedValue.dismiss()
                    }
                    Button("No", role: .cancel) { }
                }
            } else {
                VStack(alignment: .center) {
                    Spacer()
                    HStack(alignment: .center) {
                        Spacer()
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                        Spacer()
                    }
                    Spacer()
                }
            }
            }
            .onAppear {
                if viewModel.battle {
                    if owner {
                        bluetoothViewModel.start(isServer: true) {
                            let gameData = viewModel.generateGame()
                            let bt = BTData(type: BTDataType.create.rawValue, data: gameData, progress: nil, gridType: viewModel.type.rawValue, level: viewModel.level.rawValue)
                            let encoder = PropertyListEncoder()
                            if let data = try? encoder.encode(bt) {
                                bluetoothViewModel.send(data: data)
                                viewModel.newGame(source: gameData)
                                isReady = true
                            }
                        } onReceived: { data in
                            let decoder = PropertyListDecoder()
                            if let rdata = try? decoder.decode(BTData.self, from: data) {
                                if let progress = rdata.progress {
                                    battleProgress = progress
                                    if progress == 1 {
                                        //Failure
                                        showingFailure = true
                                        viewModel.onFailure()
                                    }
                                }
                            }
                        }
                    } else {
                        bluetoothViewModel.start(isServer: false) { data in
                            let decoder = PropertyListDecoder()
                            if let rdata = try? decoder.decode(BTData.self, from: data) {
                                if rdata.type == BTDataType.create.rawValue,
                                   let data = rdata.data,
                                   let gridType = rdata.gridType,
                                   let level = rdata.level {
                                    viewModel.newGame(type: SudokuGame.GridType(rawValue: gridType), level: SudokuGame.Level(rawValue: level), source: data)
                                    isReady = true
                                } else if let progress = rdata.progress {
                                    battleProgress = progress
                                    if progress == 1 {
                                        //Failure
                                        showingFailure = true
                                        viewModel.onFailure()
                                    }
                                }
                            }
                        }
                    }
                } else {
                    viewModel.newGame()
                    isReady = true
                }
            }
            .navigationBarHidden(true)
    }
    
    func createPopupCongratulations() -> some View {
        ZStack {
            VStack(spacing: 10) {
                GameWinView(level: self.viewModel.level, time: self.viewModel.time, bestTime: record(by: self.viewModel.type, level: self.viewModel.level), newRecord: self.viewModel.breakRecord)
                    .frame(height: 300)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 40, trailing: 0))

                Button(action: {
                    self.viewModel.showCongratulations = false
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Good job!")
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
        .padding(10)
    }
    func createPopupLoseGame() -> some View {
        ZStack {
            VStack(spacing: 10) {
                GameLoseView()
                    .frame(height: 300)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 40, trailing: 0))

                Button(action: {
                    self.showingFailure = false
                    presentationMode.wrappedValue.dismiss()
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
        .padding(10)
    }
    func createPopupRecord() -> some View {
        ZStack {
            VStack(spacing: 10) {
                RecordView(type: self.viewModel.type, bestRecordEasy: self.viewModel.bestRecordEasy, bestRecordNormal: self.viewModel.bestRecordNormal, bestRecordHard: self.viewModel.bestRecordHard)
                    .frame(height: 300)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 40, trailing: 0))

                Button(action: {
                    self.showingRecord = false
                }) {
                    Text("Got it")
                        .font(.headline)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
        .padding(10)
    }
    
    private let popupBackgroundColor = Color(hex: "3d5a80")
}

struct GameTable_Previews: PreviewProvider {
    static var previews: some View {
        GameTable(type: .nineNine, level: .normal, music: true, battle: false, owner: false)
    }
}
