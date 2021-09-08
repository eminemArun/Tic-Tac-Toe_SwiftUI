//
//  Alerts.swift
//  Tic-Tac-Toe
//
//  Created by Arun Negi on 08/09/2021.
//

import SwiftUI

struct AlertItem:Identifiable {
    let id = UUID()
    var title:Text
    var message:Text
    var buttonTitle:Text
}

struct AlertContext {
   static let humanWin = AlertItem(title: Text("You win !"),
                             message:  Text("Wow"),
                             buttonTitle: Text("Okay"))
    
    static let computerWin = AlertItem(title: Text("You lost !"),
                                message:  Text("Whaaat"),
                                buttonTitle: Text("Rematch"))
    
    static let draw = AlertItem(title: Text("Drawwww !"),
                         message:  Text("Yeaaahh"),
                         buttonTitle: Text("Try Again"))
}
