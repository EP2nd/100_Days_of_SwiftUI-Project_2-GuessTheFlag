//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Edwin Przeźwiecki Jr. on 21/11/2022.
//

import SwiftUI

/// Project 3, challenge 3:
struct TitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle.bold())
            .foregroundColor(.white)
    }
}

/// Project 3, challenge 3:
extension View {
    func styledTitle() -> some View {
        modifier(TitleModifier())
    }
}

struct ContentView: View {
    
    @State private var countries = allCountries.shuffled()
    
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
    
    @State private var counrtiesWithArticle = ["UK", "US"]
    static let allCountries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"]
    
    /// Project 15:
    let labels = [
        "Estonia": "Flag with three horizontal stripes of equal size. Top stripe blue, middle stripe black, bottom stripe white",
        "France": "Flag with three vertical stripes of equal size. Left stripe blue, middle stripe white, right stripe red",
        "Germany": "Flag with three horizontal stripes of equal size. Top stripe black, middle stripe red, bottom stripe gold",
        "Ireland": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe orange",
        "Italy": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe red",
        "Nigeria": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe green",
        "Poland": "Flag with two horizontal stripes of equal size. Top stripe white, bottom stripe red",
        "Russia": "Flag with three horizontal stripes of equal size. Top stripe white, middle stripe blue, bottom stripe red",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background",
        "US": "Flag with red and white stripes of equal size, with white stars on a blue background in the top-left corner"
    ]
    
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
                    .styledTitle()
                /* .font(.largeTitle.weight(.bold))
                 // Shorter: .font(.largeTitle.bold())
                 .foregroundColor(.white) */
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .font(.subheadline.weight(.heavy))
                            .foregroundColor(.white)
                        Text(withOrWithoutArticle())
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
                            FlagImage(name: countries[number])
                            
                            /// Project 6, challenge 1:
                                .rotation3DEffect(.degrees(tappedButton == number ? animationAmount : 0), axis: (x: 0, y: 1, z: 0))
                            /// Project 6, challenge 2:
                                .opacity(didButtonsFadeOut && tappedButton != number ? 0.25 : 1)
                                .scaleEffect(didButtonsFadeOut && tappedButton != number ? 0.75 : 1)
//                                .saturation(didButtonsFadeOut && tappedButton != number ? 0 : 1)
//                                .blur(radius: didButtonsFadeOut && tappedButton != number ? 0 : 3)
                            /// Project 6, challenge 3:
                                .animation(.easeInOut(duration: 0.5), value: didButtonsFadeOut && tappedButton != number ? 3 : 0)
                            /// Project 15:
                                .accessibilityLabel(labels[countries[number], default: "Unknown flag"])
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
                        Text("\nYou got it right \(correctAnswers) time(s)\nand you failed \(incorrectAnswers) time(s).\nYour overall score was \(score).\n\nTap \"Continue\" to restart the game.")
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
    
    func withOrWithoutArticle() -> String {
        if counrtiesWithArticle.contains(countries[correctAnswer]) {
            return "the \(countries[correctAnswer])"
        } else {
            return "\(countries[correctAnswer])"
        }
    }
    
    func flagTapped(_ number: Int) {
        
        let playersAnswer = countries[number]
        
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
                if counrtiesWithArticle.contains(playersAnswer) {
                    scoreTitle = "Game over!\nAnd wrong, by the way:\nthat's the flag of the \(playersAnswer)."
                } else {
                    scoreTitle = "Game over!\nAnd wrong, by the way:\nthat's the flag of \(playersAnswer)."
                }
                /// Challenge 1:
                score -= 1
                incorrectAnswers += 1
            } else {
                /// Challenge 2:
                if counrtiesWithArticle.contains(playersAnswer) {
                    scoreTitle = "Wrong! That's the flag of the \(playersAnswer)."
                } else {
                    scoreTitle = "Wrong! That's the flag of \(playersAnswer)."
                }
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
        countries.remove(at: correctAnswer)
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        /// Project 6, challenge 2:
        didButtonsFadeOut.toggle()
        /// Challenge 3:
        if correctAnswers + incorrectAnswers == 8 {
            countries = Self.allCountries
            score = 0
            correctAnswers = 0
            incorrectAnswers = 0
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
