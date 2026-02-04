//
//  ContentView.swift
//  MathTutor
//
//  Created by Richard Gagg on 4/2/2026.
//

import SwiftUI
import AVFAudio

struct ContentView: View {
  
  @State private var firstNumber: Int = 0
  @State private var secontNumber: Int = 0
  @State private var firstEmoji: String = "🐵"
  @State private var secondEmoji: String = "👽"
  @State private var answer: String = ""
  @State private var message: String = ""
  @State private var guessButtonIsDisabled: Bool = true
  @FocusState private var answerHasFocus: Bool
  @State private var audioPlayer: AVAudioPlayer!
  
  private let emojis: [String] = [
    "🍕", "🍎", "🍏", "🐵", "👽", "🧠", "🧜🏽‍♀️", "🧙🏿‍♂️", "🥷", "🐶", "🐹", "🐣", "🦄", "🐝", "🦉", "🦋", "🦖", "🐙", "🦞", "🐟", "🦔", "🐲", "🌻", "🌍", "🌈", "🍔", "🌮", "🍦", "🍩", "🍪"
  ]
  
  var body: some View {
    VStack {
      // MARK: Emojis And Sums
      Group {
        Text("\(String(repeating: firstEmoji, count: firstNumber))")
        Text("+")
        Text("\(String(repeating: secondEmoji, count: secontNumber))")
      }
      .font(Font.system(size: 80))
      .lineLimit(2)
      .multilineTextAlignment(.center)
      .minimumScaleFactor(0.5)
      .animation(.default, value: message)

      HStack {
        Text("\(firstNumber)")
        Text("+")
        Text("\(secontNumber)")
        Text("=")
      }
      .font(.largeTitle)
      .animation(.default, value: message)
      
      // MARK: Answer Text Field
      TextField("", text: $answer)
        .font(.largeTitle)
        .textFieldStyle(.roundedBorder)
        .multilineTextAlignment(.center)
        .frame(width: 60)
        .overlay {
          RoundedRectangle(cornerRadius: 10)
            .stroke(.gray, lineWidth: 2)
        }
        .keyboardType(.numberPad)
        .autocorrectionDisabled(true)
        .focused($answerHasFocus)
        .onChange(of: answer) {
          //
        }
      
      // MARK: Guess Button
      Button {
        answerHasFocus = false
        guessButtonIsDisabled = true
        
        if answer == "\(Int(firstNumber) + Int(secontNumber))" {
          playSound(soundName: "correct")
          message = "Correct!"
        } else {
          playSound(soundName: "wrong")
          message = "Sorry, the correct answer is \(Int(firstNumber) + Int(secontNumber))."
        }
        
      } label: {
        Text("Guess")
      }
      .buttonStyle(.glassProminent)
      .font(.largeTitle)
      .fontWeight(.medium)
      .disabled(answer.isEmpty || guessButtonIsDisabled)
      
      Spacer()
      
      // MARK: Message Text
      Text(message)
        .font(.largeTitle)
        .fontWeight(.black)
        .multilineTextAlignment(.center)
        .foregroundStyle(message == "Correct!" ? .green : .red)
        .animation(.default, value: message)
      
      // MARK: Play Again Button
      if message != "" {
        Button {
          gameSetup()
        } label: {
          Text("Play Agian?")
        }
      }
      
    }
    .onAppear(perform: {
      gameSetup()
    })
    .padding()
    
  }
  
  
  //  MARK: Functions
  // MARK: Game Setup Func
  func gameSetup() {
    firstNumber = Int.random(in: 1...10)
    secontNumber = Int.random(in: 1...10)
    firstEmoji = emojis[Int.random(in: 0..<emojis.count)]
    secondEmoji = emojis[Int.random(in: 0..<emojis.count)]
    message = ""
    answer = ""
    guessButtonIsDisabled = false
  }
  
  // MARK: Plat Sound Func
  func playSound(soundName: String) {
    /*
     Import needed module
     import AVFAudio
     
     Declare audio player
     @State private var audioPlayer: AVAudioPlayer! //Initialise audio player without data
     
     Use the follering function call ensuring you use a
     sound file in the asset catalog
     */
    
    if audioPlayer != nil && audioPlayer.isPlaying {
      audioPlayer.stop()
    }
    
    guard let soundFile = NSDataAsset(name: soundName) else {
      print("🤬 Could not find sound file \(soundName)")
      return
    }
    do {
      audioPlayer = try AVAudioPlayer(data: soundFile.data)
      audioPlayer.play()
    } catch {
      print("🤬 Error: \(error.localizedDescription) creating audio player")
    }
  }
}

#Preview {
  ContentView()
}
