//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Edwin Przeźwiecki Jr. on 21/11/2022.
//

import SwiftUI

/// Project 3, challenge 3:
extension View {
    func titleStyle() -> some View {
        modifier(Title())
    }
}

struct ContentView: View {
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()

    @State private var correctAnswer = Int.random(in: 0...2)
    /// Challenge 1:
    @State private var score = 0
    @State private var correctAnswers = 0
    @State private var incorrectAnswers = 0
    /// Project 6, challenge 1:
    @State private var animationAmount = 0.0
    @State private var tappedButton = 0
    /// Project 6, challenge 2:
    @State private var didButtonsFadeOut = false

    @State private var showingScore = false
    
    @State private var scoreTitle = ""
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            VStack {
                Spacer()
                /// Project 3, challenge 3:
                Text("Guess the Flag")
                    .titleStyle()
                    /* .font(.largeTitle.weight(.bold))
//                  .font(.largeTitle.bold())
                    .foregroundColor(.white) */
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .font(.subheadline.weight(.heavy))
                            .foregroundColor(.white)
                        Text(countries[correctAnswer])
                            .foregroundStyle(.secondary)
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            /// Project 6, challenge 1:
                            tappedButton = number
                            /// Project 6, challenge 1:
                            withAnimation(.interpolatingSpring(stiffness: 10, damping: 5)) {
                                animationAmount += 360
                            }
                            /// Project 6, challenge 2:
                            didButtonsFadeOut.toggle()
                            
                            flagTapped(number)
                            
                        } label: {
                            /* Image(countries[number])
                                .renderingMode(.original)
                                .clipShape(Capsule())
                                .shadow(radius: 5) */
                            
                            /// Project 3, challenge 2:
                            FlagView(text: countries[number])
                            
                            /// Project 6, challenge 1:
                            .rotation3DEffect(.degrees(tappedButton == number ? animationAmount : 0), axis: (x: 0, y: 1, z: 0))
                            /// Project 6, challenge 2:
                            .opacity(didButtonsFadeOut && tappedButton != number ? 0.25 : 1)
                            /// Project 6, challenge 3:
                            .animation(.easeInOut(duration: 0.5), value: didButtonsFadeOut && tappedButton != number ? 3 : 0)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .alert(scoreTitle, isPresented: $showingScore) {
                    Button("Continue", action: askQuestion)
                } message: {
                    /// Challenge 3:
                    if correctAnswers + incorrectAnswers < 8 {
                        /// Challenge 1:
                        Text("You got it right \(correctAnswers) time(s)\nand you failed \(incorrectAnswers) time(s).")
                    } else {
                        Text("\nYou got it right \(correctAnswers) time(s)\nand you failed \(incorrectAnswers) time(s).\nYour overall score is \(score).\n\nTap \"Continue\" to restart the game.")
                    }
                }
                Spacer()
                Spacer()
                /// Challenge 1:
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                Spacer()
            }
            .padding()
        }
    }
    
    func flagTapped(_ number: Int) {
        
        if number == correctAnswer {
            /// Challenge 3:
            if correctAnswers + incorrectAnswers == 7 {
                scoreTitle = "Game over!"
                /// Challenge 1:
                score += 1
                correctAnswers += 1
            } else {
                scoreTitle = "Correct!"
                /// Challenge 1:
                score += 1
                correctAnswers += 1
            }
        } else {
            /// Challenge 3:
            if correctAnswers + incorrectAnswers == 7 {
                /// Challenge 2:
                scoreTitle = "Game over!\nAnd wrong, by the way:\nthat's the flag of \(countries[number])."
                /// Challenge 1:
                score -= 1
                incorrectAnswers += 1
            } else {
                /// Challenge 2:
                scoreTitle = "Wrong! That's the flag of \(countries[number])."
                /// Challenge 1:
                score -= 1
                incorrectAnswers += 1
            }
        }
        /// Used GCD syntax to display alerts with a delay not to cover the animations:
//      showingScore = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            showingScore = true
        }
    }
    
    func askQuestion() {
        
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        /// Project 6, challenge 2:
        didButtonsFadeOut.toggle()
        /// Challenge 3:
        if correctAnswers + incorrectAnswers == 8 {
            score = 0
            correctAnswers = 0
            incorrectAnswers = 0
        }
    }
}

/// Project 3, challenge 2:
struct FlagView: View {
    
    var text: String
    
    var body: some View {
        Image(text)
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 5)
    }
}

/// Project 3, challenge 3:
struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle.bold())
            .foregroundColor(.white)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
