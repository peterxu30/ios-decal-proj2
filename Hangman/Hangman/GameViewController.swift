//
//  GameViewController.swift
//  Hangman
//
//  Created by Shawn D'Souza on 3/3/16.
//  Copyright © 2016 Shawn D'Souza. All rights reserved.
//


/*
Need to do:
1. Guess button functionality
    - Remove "-" when right
    - Displays incorrect guesses
2. Update image based on game state
*/

import UIKit

class GameViewController: UIViewController {
    
    @IBAction func startOverAction(sender: AnyObject) {
        guessedLetters.removeAll()
        wrongLettersGuessed.removeAll()
        playerIsVictorious = false
        playerIsDefeated = false
        print(currentPhrase)
        updateWrongGuessesLabel()
        wordBeingGuessed.text = currentWordBeingGuessed()        
    }
    
    @IBOutlet weak var wrongGuessesLabel: UILabel!
    var currentPhrase: String!
    var guessedLetters = Array<Character>()
    var playerIsVictorious = false
    var playerIsDefeated = false
    var wrongLettersGuessed = Array<Character>()
    
    @IBOutlet weak var guessLetterButton: UIButton!
    @IBOutlet weak var letterGuessField: UITextField!
    @IBOutlet weak var hangManImage: UIImageView!
    @IBOutlet weak var wordBeingGuessed: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let hangmanPhrases = HangmanPhrases()
        currentPhrase = hangmanPhrases.getRandomPhrase()
        print(currentPhrase)
        wordBeingGuessed.text = currentWordBeingGuessed()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func guessLetterAction(sender: AnyObject) {
        let guessedLetter = letterGuessField.text?.capitalizedString
        if let letter = guessedLetter {
            if playerIsDefeated {
                letterGuessField.text = ""
            }
            if playerIsVictorious {
                print("Game is over!")
                letterGuessField.text = ""
                return
            }
            if letter.characters.count == 1 && letter.unicodeScalars.first?.value >= 65 && letter.unicodeScalars.first?.value <= 90 {
                if guessedLetters.contains(letter.characters.first!) {
                    print("Already guessed")
                } else {
                    guessedLetters.append(letter.characters.first!)
                    updateWordBeingGuessedLabel(letter)
                }
            } else {
                print("Not a letter")
            }
        } else {
            print("Nothing entered.")
        }
        letterGuessField.text = ""
        view.endEditing(true)
    }
    
    func updateWordBeingGuessedLabel(letter: String) {
        if !currentPhrase.containsString(letter) {
            wrongLettersGuessed.append(letter.characters.first!)
        }
        updateWrongGuessesLabel()
        let wordBeingBuilt = currentWordBeingGuessed()
        wordBeingGuessed.text = wordBeingBuilt
        playerIsVictorious = currentPhrase == wordBeingBuilt
        checkIfGameOver()
    }
    
    func currentWordBeingGuessed() -> String {
        var wordBeingBuilt = ""
        for letter in currentPhrase.characters {
            if guessedLetters.contains(letter) {
                wordBeingBuilt.appendContentsOf("\(letter)")
                
            } else if letter == " " {
                wordBeingBuilt.appendContentsOf(" ")
            } else {
                wordBeingBuilt.appendContentsOf("-")
            }
        }
        return wordBeingBuilt
    }
    
    func updateWrongGuessesLabel() {
        var label = "Wrong Guesses:\n"
        for letter in wrongLettersGuessed {
            label.appendContentsOf("\(letter) ")
        }
        updateHangmanImage(wrongLettersGuessed.count+1)
        wrongGuessesLabel.text = label
        print(wrongGuessesLabel.text)
        checkIfGameOver()
    }
    
    func updateHangmanImage(count: Int) {
        let url = "hangman\(count).gif"
        print(url)
        hangManImage.image = UIImage(named: url)
    }
    
    func checkIfGameOver() {
        let currentWord = currentWordBeingGuessed()
        if wrongLettersGuessed.count == 6 {
            playerIsDefeated = true
            gameOverLossAlert()
        } else if currentWord == currentPhrase {
            playerIsVictorious = true
            gameOverWinAlert()
        }
    }
    
    func gameOverLossAlert() {
        let alertController = UIAlertController(title: "Game Over", message:
            "You lost!", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Play again", style: UIAlertActionStyle.Default,handler: startNewGameHandler))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func gameOverWinAlert() {
        let alertController = UIAlertController(title: "Victory!", message:
            "You win!", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Play again", style: UIAlertActionStyle.Default,handler: startNewGameHandler))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func startNewGameHandler(actionTarget: UIAlertAction) {
        let hangmanPhrases = HangmanPhrases()
        currentPhrase = hangmanPhrases.getRandomPhrase()
        guessedLetters.removeAll()
        wrongLettersGuessed.removeAll()
        playerIsVictorious = false
        playerIsDefeated = false
        print(currentPhrase)
        updateWrongGuessesLabel()
        wordBeingGuessed.text = currentWordBeingGuessed()
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
