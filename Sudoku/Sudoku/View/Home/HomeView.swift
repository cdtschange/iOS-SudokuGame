//
//  HomeView.swift
//  Sudoku
//
//  Created by 毛蔚 on 2022/4/9.
//  Copyright © 2022 Cdts. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    
    @State private var type: Int = 0
    @State private var level: Int = 0
    @State private var mode: Int = 0
    @State private var music: Int = 0
    @State private var showBattleQuestion = false
    @State private var isShowingGameTable = false
    @State private var owner: Bool = true
    let levels = SudokuGame.Level.allCases
    let types = SudokuGame.GridType.allCases
    let models = ["Myself", "Battle"]
    let musics = ["ON", "OFF"]

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Sudoku").font(chalkFont(with: 32).bold())
                    .frame(maxWidth: .infinity)
                    .padding(.bottom)
                HStack {
                    Text("Type: ").font(chalkFont(with: 16).bold())
                    Picker("Game Type", selection: $type) {
                        ForEach(0..<2) { index in
                            Text(self.types[index].displayName).tag(index)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())

                    Spacer()
                }
                HStack {
                    Text("Level: ").font(chalkFont(with: 16).bold())
                    Picker("Game Level", selection: $level) {
                        ForEach(0..<3) { index in
                            Text(self.levels[index].displayName).tag(index)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    Spacer()
                }
                HStack {
                    Text("Mode: ").font(chalkFont(with: 16).bold())
                    Picker("Game Mode", selection: $mode) {
                        ForEach(0..<2) { index in
                            Text(self.models[index]).tag(index)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    Spacer()
                }
                HStack {
                    Text("Music: ").font(chalkFont(with: 16).bold())
                    Picker("Music", selection: $music) {
                        ForEach(0..<2) { index in
                            Text(self.musics[index]).tag(index)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    Spacer()
                }
                Text("Let's Go!")
                    .font(chalkFont(with: 20).bold())
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .foregroundColor(Color.white)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.top, 10)
                    .onTapGesture {
                        if mode == 0 {
                            isShowingGameTable = true
                        } else {
                            showBattleQuestion = true
                        }
                    }
                NavigationLink(destination: GameTable(type: SudokuGame.GridType(rawValue: type)!, level: SudokuGame.Level(rawValue: level)!, music: music == 0, battle: mode == 1, owner: owner), isActive: $isShowingGameTable) {
                    
                }
                Spacer()
            }
            .padding()
        }
        .alert("How do you want to start?", isPresented: $showBattleQuestion) {
            Button("Create Game") {
                owner = true
                isShowingGameTable = true
            }
            Button("Join Game") {
                owner = false
                isShowingGameTable = true
            }
            Button("Cancel", role: .cancel) {
                
            }
        }
        .navigationBarHidden(true)
//        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func chalkFont(with size: CGFloat) -> Font {
        return Font.custom("ChalkBoard SE", size: size)
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
