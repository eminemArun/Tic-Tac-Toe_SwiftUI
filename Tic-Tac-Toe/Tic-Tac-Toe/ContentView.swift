//
//  ContentView.swift
//  Tic-Tac-Toe
//
//  Created by Arun Negi on 08/09/2021.
//

import SwiftUI




struct GameView: View {
    let columns:[GridItem] = [GridItem(.flexible()),
                              GridItem(.flexible()),
                              GridItem(.flexible())]
    
    @State private var moves:[Move?] = Array(repeating: nil, count: 9)
    @State private var isGameBoardDisabled = false
    @State private var alertItem:AlertItem?
    
    var body: some View {
        GeometryReader{ geometry in
            VStack{
                Spacer()
                LazyVGrid(columns: columns,spacing:5){
                    ForEach(0..<9){ i in
                        ZStack{
                            Circle()
                                .foregroundColor(.red).opacity(0.5)
                                .frame(width: geometry.size.width/3-15, height: geometry.size.height/3-15,
                                       alignment: .center)
                            
                            Image(systemName: moves[i]?.indicator ?? "")
                                .resizable()
                                .frame(width: 40, height: 40, alignment: .center)
                                .foregroundColor(.white)
                        }
                        .onTapGesture{
                            if isSqureOccupied(in: moves, forindex: i) {return}
                            moves[i] = Move(player:.human, boardIndex: i)
                            
                            if checkWinCondition(for: .human, in: moves){
                                alertItem = AlertContext.humanWin
                                return
                            }
                            
                            if checkForDraw(in: moves){
                                alertItem = AlertContext.draw
                                return

                            }
                            isGameBoardDisabled = true
                                //check for win or draw
                            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                                let computerPosition = determineComputerMovePosition(in: moves)
                                moves[computerPosition] = Move(player:.computer, boardIndex: computerPosition)
                                isGameBoardDisabled = false
                                
                                if checkWinCondition(for: .computer, in: moves){
                                    alertItem = AlertContext.computerWin
                                    return
                                }
                                if checkForDraw(in: moves){
                                    alertItem = AlertContext.draw
                                    return
                                }
                            }
                        }
                    }
                }
                Spacer()
            }
            .disabled(isGameBoardDisabled)
            .padding()
            .alert(item: $alertItem, content: { alertItem in
                Alert(title: alertItem.title,message: alertItem.message,dismissButton: .default(alertItem.buttonTitle, action: {
                    resetgame()
                }))
            })
        }
    }
    func isSqureOccupied(in moves:[Move?],forindex index:Int) -> Bool {
        return moves.contains(where: {$0?.boardIndex==index})
    }
    
    func determineComputerMovePosition(in moves:[Move?]) -> Int{
        
        let winPatterns :Set<Set<Int>> = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]

        // get possible win position
        let computerMoves = moves.compactMap{$0}.filter({$0?.player == .computer})
        let computerPositions = Set(computerMoves.map{ $0!.boardIndex})
        
        for pattern in winPatterns{
            let winPosition = pattern.subtracting(computerPositions)
            
            if winPosition.count == 1{
                let isAvalible = !isSqureOccupied(in: moves, forindex: winPosition.first!)
                if isAvalible{
                    return winPosition.first!
                }
            }
        }
        
        // Cant win then block
        let humanMoves = moves.compactMap{$0}.filter({$0?.player == .human})
        let humanPositions = Set(humanMoves.map{ $0!.boardIndex})
        
        for pattern in winPatterns{
            let winPosition = pattern.subtracting(humanPositions)
            
            if winPosition.count == 1{
                let isAvalible = !isSqureOccupied(in: moves, forindex: winPosition.first!)
                if isAvalible{
                    return winPosition.first!
                }
            }
        }
        
        
        // take middle block
        let centerSquare = 4
        if !isSqureOccupied(in: moves, forindex: centerSquare){
            return centerSquare
        }
        
        var movePosition = Int.random(in: 0..<9)
        
        while isSqureOccupied(in: moves, forindex: movePosition){
            movePosition = Int.random(in: 0..<9)
        }
        return movePosition
    }
    
    func checkWinCondition(for player:Player, in moves:[Move?])->Bool{
        let winPatterns :Set<Set<Int>> = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]
        
        let playerMoves = moves.compactMap{$0}.filter({$0?.player == player})
        let playerPositions = Set(playerMoves.map{ $0!.boardIndex})
        
        for pattern in winPatterns where pattern.isSubset(of: playerPositions){
            return true
        }
        return false
    }
    
    func checkForDraw(in moved:[Move?])->Bool{
        return moves.compactMap{$0}.count == 9
    }
    
    func resetgame(){
        moves = Array(repeating: nil, count: 9)
    }
}


enum Player {
    case human,computer
}

struct Move {
    let player:Player
    let boardIndex:Int
    
    var indicator:String{
        return player == .human ? "xmark" : "circle"
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
