import SwiftUI

class WordleDataModel: ObservableObject {
    @Published var guesses: [Guess] = []
    @Published var incorrectAttempts = [Int](repeating: 0, count: 6)
    @Published var toastText: String?
    @Published var showStats = false
    @AppStorage("hardmode") var hardMode = false
    
    var keyColors = [String : Color]()
    var matchedLetters = [String]()
    var misplacedLetters = [String]()
    var correctlyPlacedLetters = [String](repeating: "-", count: 5)
    var selectedWord = ""
    var currentWord = ""
    var tryIndex = 0
    var inPlay = false
    var gameOver = false
    var toastWords = ["Genius", "Magnificent", "Impressive", "Splendid", "Great", "Phew"]
    var currentStat: Statistic
    
    var gameStarted: Bool {
        !currentWord.isEmpty || tryIndex > 0
    }
    
    var disabledKeys: Bool {
        !inPlay || currentWord.count == 5
    }
    
    init() {
        currentStat = Statistic.loadStat()
        newGame()
    }
    
    // MARK: - Setup
    func newGame() {
        populateDefaults()
        selectedWord = Global.commonWords.randomElement()!
        correctlyPlacedLetters = []
        currentWord = ""
        inPlay = true
        tryIndex = 0
        gameOver = false
        print(selectedWord)
    }
    
    func populateDefaults() {
        guesses = []
        for index in 0...5 {
            guesses.append(Guess(index: index))
        }
        // reset keyboard colors
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        for char in letters {
            keyColors[String(char)] = .unused
        }
        matchedLetters = []
        misplacedLetters = []
    }
    
    // MARK: - Game Play
    func addToCurrentWord(_ letter: String) {
        currentWord += letter
        updateRow()
    }
    
    func enterWord() {
        if currentWord == selectedWord {
            gameOver = true
            if hardMode {
                if let toastText = hardCorrectCheck() {
                    showToast(with: toastText)
                    return
                }
                if let toastText = hardMisplacedCheck() {
                    showToast(with: toastText)
                    return
                }
            }
            setCurrentGuessColors()
            currentStat.updateStat(win: true, index: tryIndex)
            showToast(with: toastWords[tryIndex])
            inPlay = false
        } else {
            if verifyWord() {
                print("Valid word")
                setCurrentGuessColors()
                tryIndex += 1
                currentWord = ""
                if tryIndex == 6 {
                    currentStat.updateStat(win: false)
                    gameOver = true
                    inPlay = false
                    showToast(with: selectedWord)
                }
            } else {
                withAnimation {
                    self.incorrectAttempts[tryIndex] += 1
                }
                showToast(with: "Not in word list.")
                incorrectAttempts[tryIndex] = 0
            }
        }
    }
    
    func removeLetterFromCurrentWord() {
        currentWord.removeLast()
        updateRow()
    }
    
    func updateRow() {
        let guessWord = currentWord.padding(toLength: 5, withPad: " ", startingAt: 0)
        guesses[tryIndex].word = guessWord
    }
    
    func verifyWord() -> Bool {
        UIReferenceLibraryViewController.dictionaryHasDefinition(forTerm: currentWord)
    }
    func hardCorrectCheck() -> String? {
        let guessLetters = guesses[tryIndex].guessLetters
        for i in 0...4 {
            if correctlyPlacedLetters[i] != "-" {
                if guessLetters[i] != correctlyPlacedLetters[i] {
                    let formatter = NumberFormatter()
                    formatter.numberStyle = .ordinal
                    return "\(formatter.string(for: i + 1)!) letter must be `\(correctlyPlacedLetters[i])`."
                }
            }
        }
        return nil
    }
    
    func hardMisplacedCheck() -> String? {
        let guessLetters = guesses[tryIndex].guessLetters
        for letter in guessLetters {
            if !guessLetters.contains(letter) {
                return ("Must contain the letter `\(letter)`")
            }
        }
        return nil
    }
    
    func setCurrentGuessColors() {
        let correctLetters = selectedWord.map { String($0) }
        var frequency = [String : Int]()
        for letter in correctLetters {
            frequency[letter, default: 0] += 1
        }
        for index in 0...4 {
            let correctLetter = correctLetters[index]
            let guessLetter = guesses[tryIndex].guessLetters[index]
            if guessLetter == correctLetter {
                guesses[tryIndex].bgColors[index] = .correctColor
                if !matchedLetters.contains(guessLetter) {
                    matchedLetters.append(guessLetter)
                    keyColors[guessLetter] = .correctColor
                }
                if misplacedLetters.contains(guessLetter) {
                    if let index = misplacedLetters.firstIndex(where: {$0 == guessLetter}) {
                        misplacedLetters.remove(at: index)
                    }
                }
                correctlyPlacedLetters[index] = correctLetter
                frequency[guessLetter]! -= 1
            }
        }
        
        for index in 0...4 {
            let guessLetter = guesses[tryIndex].guessLetters[index]
            if correctLetters.contains(guessLetter)
                && guesses[tryIndex].bgColors[index] != .correctColor
                && frequency[guessLetter]! > 0 {
                guesses[tryIndex].bgColors[index] = .misplacedColor
                if !misplacedLetters.contains(guessLetter) && !matchedLetters.contains(guessLetter) {
                    misplacedLetters.append(guessLetter)
                    keyColors[guessLetter] = .misplacedColor
                }
                frequency[guessLetter]! -= 1
            }
        }
        
        for index in 0...4 {
            let guessLetter = guesses[tryIndex].guessLetters[index]
            if keyColors[guessLetter] != .correctColor
                && keyColors[guessLetter] != .misplacedColor {
                keyColors[guessLetter] = .wrongColor
            }
        }
        flipCards(for: tryIndex)
    }
    
    func flipCards(for row: Int) {
        for col in 0...4 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(col) * 0.2) {
                self.guesses[row].cardFlipped[col].toggle()
            }
        }
    }
    
    func showToast(with text: String?) {
        withAnimation {
            toastText = text
        }
        withAnimation(Animation.linear(duration: 0.2).delay(3)) {
            toastText = nil
            if gameOver {
                withAnimation(Animation.linear(duration: 0.2).delay(3)) {
                    showStats.toggle()
                }
            }
        }
    }
    
    func shareResult() {
        let stat = Statistic.loadStat()
        let resultString = """
Wordle \(stat.games) \(tryIndex < 6 ? "\(tryIndex + 1)" : "")
\(guesses.compactMap{ $0.results}.joined(separator: "\n"))
"""
        let activityController = UIActivityViewController(activityItems: [resultString], applicationActivities: nil)
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            UIWindow.key?.rootViewController!
                .present(activityController, animated: true)
        case .pad:
            activityController.popoverPresentationController?.sourceView = UIWindow.key
            activityController.popoverPresentationController?.sourceRect = CGRect(x: Global.screenWidth / 2,
                                                                                  y: Global.screenHeight / 2,
                                                                                  width: 200,
                                                                                  height: 200
            )
            UIWindow.key?.rootViewController?.present(activityController, animated: true)
        default: break
        }
    }
}
