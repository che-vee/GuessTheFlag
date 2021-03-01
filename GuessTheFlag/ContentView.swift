//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Chepkorir Lang'at on 25/01/2021.
//

import SwiftUI


struct FlagImage: View {
    var country: String
    
    var body: some View {
        Image(country)
            .renderingMode(.original)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.clear, lineWidth: 0.1))
            .shadow(color: .black, radius: 0.2)
    }
}

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var scoreMessage = ""
    @State private var scoreTotal = 0
    
    @State private var animationAmount = 0.0
    @State private var wrongAnswerOpacity = 1.0

    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(red: 0.91, green: 0.39, blue: 0.26), Color(red: 0.56, green: 0.31, blue: 0.58)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                        .font(.title3)
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                
                ForEach(0..<3) { number in
                    Button(action: {
                        withAnimation {
                            self.flagTapped(number)
                            if number == correctAnswer {
                                self.animationAmount += 360
                            }
                            self.wrongAnswerOpacity = 0.25
                            
                        }
                    }) {
                        FlagImage(country: self.countries[number])
                            .rotation3DEffect(
                                .degrees(number == correctAnswer ? animationAmount : 0),
                                axis: (x: 0.0, y: 1.0, z: 0.0))
                            .opacity(number == correctAnswer ? 1 : wrongAnswerOpacity)
                    }
                    
                }
            
                VStack {
                    Text("Current score: \(scoreTotal)")
                        .foregroundColor(.white)
                        .font(.title3)
                }
                Spacer()
            }
        }
        .alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle), message: Text(scoreMessage), dismissButton: .default(Text("Continue")) {
            self.askQuestion()
        })
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            scoreTotal += 1
            scoreMessage = "Your score is \(scoreTotal)"
            
        } else {
            scoreTitle = "Oops! ☹️"
            scoreMessage = "That's the flag of \(countries[number])"
        }
        
        self.showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        wrongAnswerOpacity = 1.0

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
