## Project #1: Analysis of Resistor Values
Concepts explored: functions, for loops, while & do while loops, switch-case.
Functions, and properties used: char(), float(), int()

This program allows users to input ther resistor values withtin a specified range and is built to range and character proof stray user inputs that are not allowed or in range. it allows user to check for statistical data on resistor values inputed and to re-run the program again once they are done.

## Project #2: Exploring Hardware(circuit Board) Implementation of Simon Says Game
Concepts explored: functions, for loops, while & do while loops, switch-case.
Functions, and properties used: char(), float(), int()

The main program is located in sources folder as main.c . This is an implementation of a simon say game for an nxp freedom development board and was programmed in the kinetis design studio(IDE specifically for the board). It makes use of a touch slider and pwm led to interface with the user. User has to remember colors shown in the initial phase of the round and input the missing colors with the touch pad. Difficulty increases per round, colors missing per round will show as white and are removed randomly. The user inputs are made to be robust for double touches and touches when no input is required. The led shows purple as feedback for user when input is accepted. Upon failure user can restart the game without resetting the board.

## Project #3: Using Matlab to Model Digital Communication Systems
The Matlab scripts written in this folder were used to model digital modulation techniques for modern communication systems. based on theory an ideal transmitter, channel and receiver is implemented in each code. Simulations are then run for varying signal to noise ratios to see the effect on demodulation and thus ideal efficiencies of the system. C programming knowledge was used to implement the scripts.
