# Type Rush

Tired of being called a boomer with how slow you type? 
__Show those pesky coworkers just how fast you can write on your phone.__

### Gameplay Loop

The player is given a word with missing letters and must write that word, submitting it to score points. They do this as a timer starts ticking the moment the game starts. With every correct word submited the timer is increased to allow the player to continue their streak, but get it wrong and the opposite happens, taking away time and potentially ending your run.

#### Why should I even play this?

It's addicting, once you start you'll always strive for a better score, but aside from it's replayability the game also develops your writing and comprehension skills as well as your cognitive recognition. These boons will only keep your brain healthy while giving you that itch to come back and try again, always improving with each run.

### MVP

To make this project a possibility, I will be focusing on the following functions:

1. Show word;
2. Accept keyboard input;
3. Compare input to correct word;
4. Add/remove time;
5. Timer countdown;
6. Score system;
7. Game over screen;
8. Load words from JSON;

With extra additions if there are no time constraints.

### Technical plan

Using Swift's SpriteKit I intend to devide the game into 3 scenes: the **Menu**, the **Game Screen** and the **End Game**.

#### Menu

Here the player will be shown a simple menu with the play option, there can be settings to add different languages and even to change aspects like sound effect and music volume. Given the game isn't all to complex, we can leave the menu and its options in a much simpler state.

#### Game Screen

Here is where the true meat and bones will come to play. How the game will work is that the player will be given a word with missing letters for which they will have to fill out a text box with the correct word to submit. This whole process will have a time limit after which, if the timer reaches zero, the game ends. Whenever the player submits the correct word they add points to their final score and add extra time to the timer allowing the player to prolongue their streak, but get the word wrong and time is removed to shorten it. 

#### End Game

Another simple screen with the players score displayed to them as well as the options to try again or to go back to the Menu.

### Challenge

The biggest challenge is having a large enough word library to make the game feel fresh with each run. As well as a way to keep the words anonymous enough to not be easy for the player to simply write without thinking much but also not to anonymous as to frustrate the player. To fix this what I have in mind is reading a JSON file with a list of words, along with these words would also be the anonymous version of them to be displayed to the player, however perhaps there is a way to make a function for this last bit. 
