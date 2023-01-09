//
//  FlagImage.swift
//  GuessTheFlag
//
//  Created by Edwin Przeźwiecki Jr. on 09/01/2023.
//

import SwiftUI

/// Project 3, challenge 2:
struct FlagImage: View {
    var name: String
    
    var body: some View {
        Image(name)
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 5)
    }
}

struct FlagImage_Previews: PreviewProvider {
    static var previews: some View {
        FlagImage(name: "Poland")
    }
}
