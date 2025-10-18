
-----

# Letradle

A word-guessing game inspired by titles like Termo, Letroso, and Wordle, developed in Flutter for Brazilian Portuguese.

## 📜 About the Game

Letradle challenges you to uncover a secret word within a limited number of attempts. With each guess, the game provides feedback, indicating which letters are in the correct position, which are in the word but in the wrong spot, and which are not part of the answer at all.

Use logic and deduction to decipher the word before you run out of tries\!

-----

## 🎮 How to Play

1.  **Set Up Your Game:** Before starting, define the **word length** and the **difficulty level** (which determines the number of attempts).
2.  **Make Your Guess:** Type a valid word with the chosen number of letters and press Enter.
3.  **Analyze the Colors:** The game will color-code the letters in your guess to provide clues about the secret word.
      * 🟩 **Green:** The letter is correct and in the exact position.
      * 🟨 **Yellow:** The letter exists in the secret word but is in the wrong position.
      * ⬛ **Gray/Black:** The letter is not in the secret word at all.
4.  **Repeat:** Continue making new guesses until you find the word or run out of attempts.

-----

## ⚙️ Game Settings

### Difficulty Level

  * **Easy:** 20 attempts
  * **Medium:** 15 attempts
  * **Hard:** 6 attempts

### Word Length

  * The player can choose a word length between **5 and 10 letters**.

-----

## 🛠️ Technical Details

This project uses a **hybrid approach** for word validation, combining the speed of a local dictionary with the comprehensiveness of an online API.

### Dictionary Logic

1.  **Fast Initialization:** When a game starts, words from the local file `assets/lexico.txt` are filtered by the chosen length and loaded into an in-memory `Set`. This ensures that most word checks are instantaneous ( **O(1)** complexity).
2.  **Secret Word Selection:** The secret word is chosen **exclusively** from this local list. This guarantees that the answer is always a word included in the game's base dictionary.
3.  **API Fallback:** If a player enters a word that is **not found** in the local dictionary, the application sends a real-time request to the **Dicionário Aberto API**.
      * If the API confirms the word exists, the guess is validated, and the game proceeds. The word is also added to the in-memory `Set` so that future checks for the same word are instant.
      * If the API does not find the word, the player is notified that the word is invalid.
4.  **String Normalization:** All words, both from the dictionary and user input, are normalized by removing accents (using the `diacritic` package). This ensures that "FÁCIL" and "FACIL" are treated as the same word, simplifying comparisons.

-----

## 🚀 How to Run the Project

To run this project locally, follow the steps below:

1.  **Clone the repository:**
    ```sh
    git clone https://github.com/LucasGaviao/letradle
    ```
2.  **Navigate to the project directory:**
    ```sh
    cd letradle
    ```
3.  **Install dependencies:**
    ```sh
    flutter pub get
    ```
4.  **Run the application:**
    ```sh
    flutter run
    ```

-----

## 🙏 Credits

  * **Dicionário Aberto API:** Used for online word validation.
      * [https://api.dicionario-aberto.net/](https://api.dicionario-aberto.net/)
  * **`pt-br` Lexicon:** Base file for the local dictionary.
      * [fserb/pt-br-dicionario](https://www.google.com/search?q=https://github.com/fserb/pt-br-dicionario)

-----

