#!/usr/bin/perl

use strict;
use warnings;

local $| = 1;
my $EOL  = "\n";
my $EMPTY_STRING = q{};

my $menuAnswer   = $EMPTY_STRING;
my $playerGuess  = $EMPTY_STRING;
my $selectedWord = $EMPTY_STRING;

my @guessedLetters        = ('1');
my @selectedWordDisplay   = ();
my $wrongGuessesRemaining = 6;

my @wordList = qw(
  HORSE          PUMPKIN        COMPUTER 
  SASSAFRASS     LYCANTHROPES   HANGMAN 
  FLAMETHROWER   XYLOPHONE      EXCOMMUNICATION 
  UTOPIA         BRIEFCASE      DOCTOR 
  MASTERPIECE    BOOKKEEPER     EMPHASIZE
);

mainMenu();

sub attemptToSolve {
  print 'What is the solution?' . $EOL;
  my $solutionGuess = <STDIN>;
  chomp($solutionGuess);
  if ( $selectedWord eq uc($solutionGuess) ) {
    print 'Congratlutions. You have bested me and saved a life.' . $EOL x2;
    sleep(1);
    print 'Goodbye.';
  } else {
    handleGuessesRemaining();
    guessLetter();
  }
}

sub checkGuessedLetter {
  if ( $playerGuess =~ /^[a-zA-Z]+$/ ) {
    if ( $playerGuess ~~ @guessedLetters ) {
      print 'That letter has already been chosen.' . $EOL;
      sleep(1);
      printDisplay();
    } else {
      if ( $selectedWord =~ m/[$playerGuess]/ ) {
        updateDisplay();
        print 'Correct. ';
      } else {
        handleGuessesRemaining();
      }
      push(@guessedLetters, $playerGuess);
    }
  } else {
    print 'Do not overthink. Only letters are used. ' . $EOL;
    sleep(1);
    printDisplay();
  }
  sleep(1);
  guessLetter();
}

sub guessLetter {
  if ( $wrongGuessesRemaining == 0 ) {
    print 'You have lost. Another life has been taken.' . $EOL x2;
    sleep(1);
    print 'Goodbye.';
    return;
  } else {
    if ( scalar @guessedLetters == 1 ) {
      print 'What is your guess?' . $EOL;
    } else {
      print 'What is your next guess? (type SOLVE to solve)' . $EOL;
    }
    $playerGuess = <STDIN>;
    chomp($playerGuess);
    $playerGuess = uc($playerGuess);
    if ( $playerGuess eq 'SOLVE' ) {
      attemptToSolve();
    } else {
      checkGuessedLetter();
    }
  }
}

sub handleGuessesRemaining {
  $wrongGuessesRemaining = $wrongGuessesRemaining - 1;
  if ( $wrongGuessesRemaining == 0 ) {
    print 'You are out of guesses.' . $EOL x2;
  } elsif ( $wrongGuessesRemaining == 1 ) {
    print $EOL . "Incorrect. You have $wrongGuessesRemaining wrong guess remaining." . $EOL;
    sleep(1);
    printDisplay();
  } else {
    print $EOL . "Incorrect. You have $wrongGuessesRemaining wrong guesses remaining." . $EOL;
    sleep(1);
    printDisplay();
  }
}

sub mainMenu {
  print 'Would you like to play HANGMAN? YES/NO' . $EOL;
  $menuAnswer = <STDIN>;
  chomp($menuAnswer);
  if ( uc($menuAnswer) eq 'YES' ) {
    sleep(1);
    print $EOL . 'Then the game shall begin.';
    sleep(1);
    startGame();
  } elsif ( uc($menuAnswer) eq 'NO' ) {
    print 'Goodbye.';
  } else {
    sleep(1);
    print 'I ask again...';
    mainMenu();
  }
}

sub printDisplay {
  print $EOL . $EOL;
  for my $letter ( @selectedWordDisplay ) {
    print $letter;
  }
  print $EOL . $EOL;
}

sub selectWord {
  $selectedWord = $wordList[rand @wordList];
  setDisplay();
}

sub setDisplay {
  for ( 1..length $selectedWord ) {
    push(@selectedWordDisplay, '_ ');
  }
  printDisplay();
}

sub startGame {
  selectWord();
  guessLetter();
}

sub updateDisplay {
  my $offset = 0;
  my $letterIndex = index($selectedWord, $playerGuess, $offset);
  while ( $letterIndex != -1 ) {
    $selectedWordDisplay[$letterIndex] = "$playerGuess ";
    $offset = $letterIndex + 1;
    $letterIndex = index($selectedWord, $playerGuess, $offset);
  }
  printDisplay();
}