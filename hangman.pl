#!/usr/bin/perl

use strict;
use warnings;

local $| = 1;
my $EOL  = "\n";
my $EMPTY_STRING = q{};

my $menuAnswer   = $EMPTY_STRING;
my $difficulty   = $EMPTY_STRING;
my $playerGuess  = $EMPTY_STRING;
my $selectedWord = $EMPTY_STRING;

my @guessedLetters        = ('1');
my @selectedWordDisplay   = ();
my $wrongGuessesRemaining = 6;

my @activeWordList = qw();









##########################################################
#       WORD LISTS - SPOILERS! SPOILERS! SPOILERS!       #
##########################################################

my @easierWordList = qw (
  ACROSS     ATTACK      BASKET 
  BETTER     BOTTLE      CARRY 
  CAT        CERTAIN     CHAIR 
  CHOCOLATE  CHOOSE      CIRCLE 
  CLEAN      CLOTHES     COLOR 
  CORRECT    COUNT       EARTH 
  ELECTRIC   EVENING     FALSE 
  FLOOR      FOOTBALL    FRIEND 
  GATE       GOODBYE     GRASS 
  GREEN      HAPPEN      HEALTH 
  HEART      HEIGHT      HELLO 
  HORSE      HOTEL       IMPORTANT 
  INSIDE     IRON        ISLAND 
  JUST       KITCHEN     LADDER 
  LATELY     LEARN       LEFT 
  LENGTH     LESSON      LETTER 
  LIBRARY    LISTEN      LITTLE 
  LONELY     LOOK        MARKET 
  MATTER     MEAT        MILLION 
  MOMENT     MONTH       NATURE 
  NEEDLE     NEITHER     NOISE 
  NOSE       NOTHING     ORDER 
  OUTSIDE    PARENT      PARTNER 
  PART       PAST        PATH 
  PEOPLE     PHOTOGRAPH  PICTURE 
  PLASTIC    PLEASED     POISON 
  POLITE     POTATO      PRESENT 
  PRETTY     PROTECT     QUESTION 
  RECEIVE    RESTAURANT  RESULT 
  RUBBER     RULER       SALT 
  SENTENCE   SILLY       SIMILAR 
  SMALL      SMELL       SMILE 
  SOMEONE    SOMETHING   SOMETIMES 
  SPEED      SPELL       SPOON 
  SPRING     STEAL       STEAM 
  STONE      STOP        STORE 
  STREET     STUDENT     SUCCESS 
  TABLE      TASTE       TELEPHONE 
  TENNIS     TERRIBLE    THAT 
  THREE      TITLE       TOGETHER 
  TOMORROW   TONIGHT     TOOL 
  TOOTH      TOTAL       TREE 
  TRUE       TRUST       USUAL 
);

my @harderWordList = qw(
  AMBIDEXTROUS     BANDWAGON       BLITZ 
  BLIZZARD         BAYOU           EXCOMMUNICATION 
  GALVANIZE        GNARLY          HAPHAZARD 
  JOVIAL           KHAKI           KILOBYTE 
  LARYNX           LYCANTHROPES    MALNOURISHED 
  MEGAHERTZ        METALWORKING    ONYX 
  PIZAZZ           PROBLEMATIC     PSEUDOMYTHICAL 
  QUESTIONABLY     QUIXOTIC        SPHINX 
  SUBVOCALISED     SYNDROME        TWELFTHS 
  UNCOPYRIGHTABLE  UNDISCOVERABLE  UTOPIA 
  VOYEURISM        WALTZ           XYLOPHONE 
);

my @extraWordList = qw(
  BOOKKEEPER  BRIEFCASE    COMPUTER 
  DOCTOR      EMPHASIZE    FLAMETHROWER 
  HANGMAN     MASTERPIECE  PUMPKIN 
  SASSAFRASS  SEISMIC      TAPESTRY 
);









##########################
#       START GAME       #
##########################

mainMenu();

sub attemptToSolve {
  print 'What is the solution?' . $EOL;
  my $solutionGuess = <STDIN>;
  chomp($solutionGuess);
  if ( $selectedWord eq uc($solutionGuess) ) {
    print $EOL . 'Congratlutions. You have bested me and saved a life.' . $EOL x2;
    sleep(1);
    print 'Goodbye.' . $EOL x2;
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

sub checkIfSolved {
  my $checkSelectedWord = join('', @selectedWordDisplay);
  $checkSelectedWord =~ s/\s+//g;
  if ( $selectedWord eq $checkSelectedWord ) {
    print $EOL . $EOL . 'Congratlutions. You have bested me and saved a life.' . $EOL x2;
    sleep(1);
    print 'Goodbye.' . $EOL x2;
    return 0;
  } else {
    return 1;
  }
}

sub chooseDifficulty {
  print $EOL . 'Which difficulty do you choose? EASY/HARD/ALL' . $EOL;
  $difficulty = <STDIN>;
  chomp($difficulty);
  if ( uc($difficulty) eq 'EASY' ) {
    push(@activeWordList, @easierWordList);
    sleep(1);
    print $EOL . 'You have chosen EASY.' . $EOL;
  } elsif ( uc($difficulty) eq 'HARD' ) {
    push(@activeWordList, @harderWordList);
    sleep(1);
    print $EOL . 'You have chosen HARD.' . $EOL;
  } elsif ( uc($difficulty) eq 'ALL' ) {
    push(@activeWordList, @easierWordList);
    push(@activeWordList, @harderWordList);
    push(@activeWordList, @extraWordList);
    sleep(1);
    print $EOL . 'You have chosen ALL.' . $EOL;
  } else {
    sleep(1);
    print $EOL . 'I ask again...';
    chooseDifficulty();
  }
}

sub guessLetter {
  if ( checkIfSolved() ) {
    if ( $wrongGuessesRemaining == 0 ) {
      print 'You have lost. Another life has been taken.' . $EOL x2;
      sleep(1);
      print 'Goodbye.' . $EOL x2;
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
  } else {
    return;
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
    chooseDifficulty();
    sleep(1);
    print $EOL . 'Then the game shall begin.';
    sleep(1);
    startGame();
  } elsif ( uc($menuAnswer) eq 'NO' ) {
    sleep(1);
    print $EOL . 'Goodbye.' . $EOL x2;
  } else {
    sleep(1);
    print $EOL . 'I ask again...';
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
  $selectedWord = $activeWordList[rand @activeWordList];
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
