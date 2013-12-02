//
//  ViewController.m
//  initiateVotes
//
//  Created by Shine Zhao on 11/18/13.
//  Copyright (c) 2013 Shine Zhao. All rights reserved.
//

#import "InitializeVoteViewController.h"

@interface InitializeVoteViewController ()
{
    GLfloat mainContainerHeight;
    GLfloat originalHeightOfMainContainerContentSize;
    CGRect originalSecondContainerFrame;
    CGRect originalThirdContainerFrame;
    CGRect originalFourthContainerFrame;
    CGRect originalFifthContainerFrame;
    CGRect originalSixthContainerFrame;
    
    //font size of Titles
    int fontSizeOfTitles;
    //font size of user's input
    int fontSizeOfInput;
    
    //names of arrows' images
    NSArray *arrowImages;
    
    NSArray *solidArrowImage;
    
    //the condition image's address
    NSString *onGoingIcon;
    NSString *waitingIcon;
    NSString *DoneIcon;
    NSString *FailedIcon;
    NSString *lineImage;
    NSString *optionIndexImage;
    NSString *addIcon;
    NSString *blueButtonBackground;
    NSString *redButtonBackground;
    
    //height of one line
    int heightOfOneLineInContainer;
    //interval between lines
    int intervalBetweenLines;
    //gap between first icon and words
    int leftMarginOfWords;
    //height of the line's icon
    int heightOfLineArrow;
    //height and width of the button
    int heightOfButton;
    int widthOfButton;
    //button interval
    int intervalOfButton;
    
    //height of one line in responder
    int heightOfOneLineInResponder;

    //calculate the number of lines in subject input section
    int numberOfLines;
    int numberOfOptions;
    int numberOfPeople;
    
    //names of circle images
    NSArray *circleImageArray;
    //index of circleImageArray
    int selectedColorIndex;
    //gap between circles
    int gapBetweenCircles;
    //interval between line and responder container
    int intervalBetweenLineAndResponder;
    //the radius of circles
    int circleSize;
    
    //used to store current responder
    UIView *currentRunningResponder;
    //used to store current moved container
    UIView *currentRunningContainer;
    //used to store current state icon to show the state of current task
    UIImageView *currentStateIcon;
    //store current title of container
    UILabel *currentTitleOfContainer;
    //store the current tap gesture recognizer
    UITapGestureRecognizer *currentTapGestureRecongnizer;
    //give a mark to show if every task in current responder is completed
    BOOL taskInCurrentResponderIsDone;
    

    //store current input view
    UIView *currentInputView;
    //store curent option textfield
    UITextField *currentTextfield;
    //store height of current responder
    CGFloat currentHeightOfCurrentResponder;
    //store current index
    int currentIndex;
    
    //store password textfield width
    GLfloat widthOfPasswordTextField;
    int passwordConfirmTimes;
    int tempPassword;
    int confirmedPassword;

    //time selected button
    UIButton *currentSelectedTimeButton;
    
    BOOL colorChoiceIsDone;
    BOOL subjectSetIsDone;
    BOOL optionSetIsDone;
    NSArray *eachOptionSetIsDoneArray;
    BOOL numberSetIsDone;
    BOOL passwordSetIsDone;
    BOOL timeSetIsDone;
    
    int stepsHasBeenFinished;
    
    CLLocationManager *_locationManager;
}

@end

@implementation InitializeVoteViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        // Custom initialization
        self.tabBarItem.image = [UIImage imageNamed:@"greenCircle"];
        
        /*
        //set the tab bar item background
        [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"InitializeTabBarHighlight"] withFinishedUnselectedImage:[UIImage imageNamed:@"InitializeTabBarNormal"]];
        
        self.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
         */
        
        self.title =@"Initiate";
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    _mainContainer.userInteractionEnabled = YES;
    //initiate a bouch of variable
    fontSizeOfTitles = 22;
    fontSizeOfInput = 16;
    heightOfOneLineInContainer = 28;
    heightOfLineArrow = 15;
    intervalBetweenLines = 25;
    leftMarginOfWords = 32;
    selectedColorIndex = 0;
    gapBetweenCircles = 23;
    intervalBetweenLineAndResponder = 10;
    circleSize = 35;
    numberOfOptions = 2;
    heightOfButton = 30;
    widthOfButton = heightOfButton *176 /97;
    intervalOfButton = 30;
    numberOfLines = 1;
    heightOfOneLineInResponder = 35;
    numberOfPeople = 0;
    stepsHasBeenFinished = 0;
    
    colorChoiceIsDone = NO;
    subjectSetIsDone = NO;
    optionSetIsDone = NO;
    numberSetIsDone = NO;
    passwordSetIsDone = NO;
    timeSetIsDone = NO;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //draw a rectangular around the arrow
    _arrowRect.layer.borderWidth = 2;
    _arrowRect.layer.borderColor = [UIColor grayColor].CGColor;
    _arrowRect.layer.cornerRadius = 8;
    
    circleImageArray = [[NSArray alloc] initWithObjects:@"greenCircle", @"blueCircle", @"yellowCircle", @"redCircle", @"blackCircle", nil];
    
    arrowImages = [[NSArray alloc] initWithObjects:@"greenArrowBorder", @"blueArrowBorder", @"yellowArrowBorder", @"redArrowBorder", @"grayArrowBorder", nil];
    
    solidArrowImage = [[NSArray alloc] initWithObjects:@"GreenSolidArrow", @"BlueSolidArrow", @"YellowSolidArrow", @"RedSolidArrow", @"GraySolidArrow", nil];
   
    //set onGoingIcon and WaitingIcon
    onGoingIcon = @"inProgressImage";
    waitingIcon = @"undoImage";
    DoneIcon = @"DoneImage";
    FailedIcon = @"redCross";
    lineImage = @"Line_marker";
    optionIndexImage = @"CellIndexCircle";
    addIcon = @"addIcon";
    redButtonBackground = @"RedTitleBackground";
    blueButtonBackground = @"BlueTitleBackground";
  
    //title
    _arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:arrowImages[0]]];
    _arrow.frame = CGRectMake(19, 13, 260, 50);
    [_arrowRect addSubview:_arrow];
    
    //set scrollview height
    mainContainerHeight = ScreenHeigh - 165 - 49;
    originalHeightOfMainContainerContentSize = 5 * (heightOfOneLineInContainer + intervalBetweenLines) + heightOfOneLineInContainer;
    _mainContainer = [[UIScrollView alloc] init];
    _mainContainer.contentSize = CGSizeMake(298, originalHeightOfMainContainerContentSize);
    _mainContainer.frame = CGRectMake(11, 165, 298, mainContainerHeight);
    [self.view addSubview:_mainContainer];
    
    
#pragma -mark first responder and elements in it
    _theFirstResponder = [[UIView alloc] init];
    _theFirstResponder.frame = CGRectMake(-320, heightOfOneLineInContainer + intervalBetweenLineAndResponder, 298, heightOfOneLineInResponder);
    [_mainContainer addSubview:_theFirstResponder];

    
    _greenChoiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _greenChoiceButton.frame = CGRectMake(gapBetweenCircles, 0, circleSize, circleSize);
    [_greenChoiceButton setImage:[UIImage imageNamed:circleImageArray[0]] forState:UIControlStateNormal];
    [_greenChoiceButton setImage:[UIImage imageNamed:circleImageArray[0]] forState:UIControlStateNormal];
    [_theFirstResponder addSubview:_greenChoiceButton];
    [_greenChoiceButton addTarget:self action:@selector(greenSelected:) forControlEvents:UIControlEventTouchDown];
 

    _blueChoiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _blueChoiceButton.frame = CGRectMake( circleSize + gapBetweenCircles + gapBetweenCircles, 0, circleSize, circleSize);
    [_blueChoiceButton setImage:[UIImage imageNamed:circleImageArray[1]] forState:UIControlStateNormal];
    [_blueChoiceButton setImage:[UIImage imageNamed:circleImageArray[1]] forState:UIControlStateNormal];
    [_theFirstResponder addSubview:_blueChoiceButton];
    [_blueChoiceButton addTarget:self action:@selector(blueSelected:) forControlEvents:UIControlEventTouchDown];
    
    _yellowChoiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _yellowChoiceButton.frame = CGRectMake( 2 * (circleSize + gapBetweenCircles) + gapBetweenCircles, 0, circleSize, circleSize);
    [_yellowChoiceButton setImage:[UIImage imageNamed:circleImageArray[2]] forState:UIControlStateNormal];
    [_yellowChoiceButton setImage:[UIImage imageNamed:circleImageArray[2]] forState:UIControlStateNormal];
    [_theFirstResponder addSubview:_yellowChoiceButton];
    [_yellowChoiceButton addTarget:self action:@selector(yellowSelected:) forControlEvents:UIControlEventTouchDown];
    
    _redChoiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _redChoiceButton.frame = CGRectMake( 3 * (circleSize + gapBetweenCircles) + gapBetweenCircles, 0, circleSize, circleSize);
    [_redChoiceButton setImage:[UIImage imageNamed:circleImageArray[3]] forState:UIControlStateNormal];
    [_redChoiceButton setImage:[UIImage imageNamed:circleImageArray[3]] forState:UIControlStateNormal];
    [_theFirstResponder addSubview:_redChoiceButton];
    [_redChoiceButton addTarget:self action:@selector(redSelected:) forControlEvents:UIControlEventTouchDown];
    
    _blackChoiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _blackChoiceButton.frame = CGRectMake( 4 * (circleSize + gapBetweenCircles) + gapBetweenCircles, 0, circleSize, circleSize);
    [_blackChoiceButton setImage:[UIImage imageNamed:circleImageArray[4]] forState:UIControlStateNormal];
    [_blackChoiceButton setImage:[UIImage imageNamed:circleImageArray[4]] forState:UIControlStateNormal];
    [_theFirstResponder addSubview:_blackChoiceButton];
    [_blackChoiceButton addTarget:self action:@selector(blackSelected:) forControlEvents:UIControlEventTouchDown];


    
#pragma - mark first container
    _firstContainer = [[UIView alloc] init];
    _firstContainer.frame = CGRectMake(0, 0, 298, heightOfOneLineInContainer);
    [_mainContainer addSubview:_firstContainer];
    
    //theme
    _themeColorIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:waitingIcon]];
    _themeColorIcon.frame = CGRectMake(0, 0, heightOfOneLineInContainer, heightOfOneLineInContainer);
    [_firstContainer addSubview:_themeColorIcon];
    
    _themeColorLabel = [[UILabel alloc] init];
    _themeColorLabel.frame = CGRectMake(leftMarginOfWords, 0, 250, heightOfOneLineInContainer);
    _themeColorLabel.textColor = [UIColor darkGrayColor];
    _themeColorLabel.font = [UIFont systemFontOfSize:fontSizeOfTitles];
    _themeColorLabel.text = @"Choose theme color";
    [_firstContainer addSubview:_themeColorLabel];
    
    //tap the choice of colors
    _tapColorChoiceRecognizer = [[UITapGestureRecognizer alloc]
                                 initWithTarget:self
                                 action:@selector(respondToTapColorChoiceGesture)];
    
    // Specify that the gesture must be a single tap
    _tapColorChoiceRecognizer.numberOfTapsRequired = 1;
    
    // Add the tap gesture recognizer to the view
    _themeColorLabel.userInteractionEnabled = YES;
    [_themeColorLabel addGestureRecognizer:_tapColorChoiceRecognizer];
    

    
 
    
#pragma -mark second container
    //build second content view container
    _secondContainer = [[UIView alloc] init];
    originalSecondContainerFrame = CGRectMake(0, heightOfOneLineInContainer + intervalBetweenLines, 298, 4 * ( heightOfOneLineInContainer + intervalBetweenLines ) + heightOfOneLineInContainer);
    _secondContainer.frame = originalSecondContainerFrame;
    [_mainContainer addSubview:_secondContainer];
    
    //subject
    _subjectIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:waitingIcon]];
    _subjectIcon.frame = CGRectMake(0, 0, heightOfOneLineInContainer, heightOfOneLineInContainer);
    [_secondContainer addSubview:_subjectIcon];
    
    _subjectLabel = [[UILabel alloc] init];
    _subjectLabel.frame = CGRectMake(leftMarginOfWords, 0, 120, heightOfOneLineInContainer);
    _subjectLabel.textColor = [UIColor darkGrayColor];
    _subjectLabel.font = [UIFont systemFontOfSize:fontSizeOfTitles];
    _subjectLabel.text = @"Subject";
    [_secondContainer addSubview:_subjectLabel];
    
    //tap the choice of subject
    _tapSubjectRecognizer = [[UITapGestureRecognizer alloc]
                                 initWithTarget:self
                                 action:@selector(respondToTapSubjectGesture)];
    
    // Specify that the gesture must be a single tap
    _tapSubjectRecognizer.numberOfTapsRequired = 1;
    
    // Add the tap gesture recognizer to the view
    _subjectLabel.userInteractionEnabled = YES;
    [_subjectLabel addGestureRecognizer:_tapSubjectRecognizer];
    
    
#pragma -mark second responder
    _secondResponder = [[UIView alloc] init];
    _secondResponder.frame = CGRectMake(-320, heightOfOneLineInContainer + intervalBetweenLineAndResponder, 298, heightOfOneLineInResponder);
    [_secondContainer addSubview:_secondResponder];
    _secondResponder.userInteractionEnabled = YES;
   // _secondResponder.layer.borderWidth = 1;
    
    _lineMarkerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:lineImage]];
    _lineMarkerImageView.frame = CGRectMake( (leftMarginOfWords - heightOfLineArrow) / 2, ( heightOfOneLineInResponder - heightOfLineArrow ) / 2, heightOfLineArrow, heightOfLineArrow);
    [_secondResponder addSubview:_lineMarkerImageView];
    

    _subjectTextView = [[UITextView alloc] init];
    _subjectTextView.editable = YES;
    _subjectTextView.frame = CGRectMake(leftMarginOfWords, 0, 298 - leftMarginOfWords, heightOfOneLineInResponder);
   // _subjectTextView.layer.borderWidth = 1;
    _subjectTextView.font = [UIFont systemFontOfSize:fontSizeOfInput];
    _subjectTextView.returnKeyType = UIReturnKeyDone;
    _subjectTextView.scrollEnabled = NO;
    _subjectTextView.userInteractionEnabled = YES;
    _subjectTextView.delegate = self;
    [_secondResponder addSubview:_subjectTextView];
    
    
#pragma -mark third container
    //build third view container
    _thirdContainer = [[UIView alloc] init];
    originalThirdContainerFrame = CGRectMake(0, heightOfOneLineInContainer + intervalBetweenLines, 298, 3 * (heightOfOneLineInContainer + intervalBetweenLines ) + heightOfOneLineInContainer);
    _thirdContainer.frame = originalThirdContainerFrame;
    [_secondContainer addSubview:_thirdContainer];
    
    //options
    _optionIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:waitingIcon]];
    _optionIcon.frame = CGRectMake(0, 0, heightOfOneLineInContainer, heightOfOneLineInContainer);
    [_thirdContainer addSubview:_optionIcon];
    
    _optionLabel = [[UILabel alloc] init];
    _optionLabel.frame = CGRectMake(leftMarginOfWords, 0, 100, heightOfOneLineInContainer);
    _optionLabel.textColor = [UIColor darkGrayColor];
    _optionLabel.font = [UIFont systemFontOfSize:fontSizeOfTitles];
    _optionLabel.text = @"Options";
    [_thirdContainer addSubview:_optionLabel];
    
    //tap the choice of subject
    _tapOptionGestureRecognizer = [[UITapGestureRecognizer alloc]
                             initWithTarget:self
                             action:@selector(respondToTapOptionGesture)];
    
    // Specify that the gesture must be a single tap
    _tapOptionGestureRecognizer.numberOfTapsRequired = 1;
    
    // Add the tap gesture recognizer to the view
    _optionLabel.userInteractionEnabled = YES;
    [_optionLabel addGestureRecognizer:_tapOptionGestureRecognizer];
    
#pragma -mark third responder
    //initiate array of option index
    UIButton *firstIndexButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *secondIndexButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _optionIndexArray = @[firstIndexButton, secondIndexButton];
    UIButton *tempButton;
    
    //initiate array of text field
    UITextField *firstTextField = [[UITextField alloc] init];
    UITextField *secondTextField = [[UITextField alloc] init];
    _optionTextfieldArray = @[firstTextField, secondTextField];
    UITextField *tempTextField;
    
    //initate array of input view array
    UIView *firstInputView = [[UIView alloc] init];
    UIView *secondInputView = [[UIView alloc] init];
    _optionInputViewArray = @[firstInputView, secondInputView];
    UIView *tempInputView;
    
    eachOptionSetIsDoneArray = [NSArray arrayWithObjects:[NSNumber numberWithBool:NO], [NSNumber numberWithBool:NO], nil];


    
    //initiate responder
    _thirdResponder = [[UIView alloc] init];
    _thirdResponder.frame = CGRectMake(-320, heightOfOneLineInContainer + intervalBetweenLineAndResponder, 298, heightOfOneLineInResponder * 3);
    [_thirdContainer addSubview:_thirdResponder];
    _thirdResponder.userInteractionEnabled = YES;
    
    //first option
    tempButton = _optionIndexArray[0];
 //   tempButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tempButton.frame = CGRectMake( 0, (heightOfOneLineInResponder - heightOfOneLineInContainer ) / 2, heightOfOneLineInContainer, heightOfOneLineInContainer);
    [tempButton setImage:[UIImage imageNamed:optionIndexImage] forState:UIControlStateNormal];
    [tempButton setImage:[UIImage imageNamed:optionIndexImage] forState:UIControlStateHighlighted];
    [tempButton addTarget:self action:@selector(tapOnIndexOfOption:) forControlEvents:UIControlEventTouchDown];
    [_thirdResponder addSubview:tempButton];
    
    UILabel *firstIndexLabel = [[UILabel alloc] init];
    firstIndexLabel.frame = CGRectMake(9, 8, 15, 15);
    [firstIndexLabel setText:@"1"];
    [tempButton addSubview:firstIndexLabel];
    
    //Input Section
    tempInputView = _optionInputViewArray[0];
    tempInputView.frame = CGRectMake(heightOfOneLineInContainer, 0, 298 - heightOfOneLineInContainer, heightOfOneLineInResponder);
    [_thirdResponder addSubview:tempInputView];
  //  tempInputView.hidden = YES;
    
    UIImageView *firstLineMarkerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:lineImage]];
    firstLineMarkerImageView.frame = CGRectMake( 0 , ( heightOfOneLineInResponder - heightOfLineArrow ) / 2, heightOfLineArrow, heightOfLineArrow);
    [tempInputView addSubview:firstLineMarkerImageView];
    
    tempTextField = _optionTextfieldArray[0];
    tempTextField.frame = CGRectMake(heightOfLineArrow, 0, 298 - leftMarginOfWords, heightOfOneLineInResponder);
    tempTextField.keyboardType = UIKeyboardTypeDefault;
    tempTextField.delegate = self;
    tempTextField.returnKeyType = UIReturnKeyDone;
    [tempInputView addSubview:tempTextField];
    
    //second option
    tempButton = _optionIndexArray[1];
    [tempButton setImage:[UIImage imageNamed:optionIndexImage] forState:UIControlStateNormal];
    [tempButton setImage:[UIImage imageNamed:optionIndexImage] forState:UIControlStateHighlighted];
    tempButton.frame = CGRectMake( 0, (heightOfOneLineInResponder - heightOfOneLineInContainer ) / 2 + heightOfOneLineInResponder, heightOfOneLineInContainer, heightOfOneLineInContainer);
    [tempButton addTarget:self action:@selector(tapOnIndexOfOption:) forControlEvents:UIControlEventTouchDown];
    [_thirdResponder addSubview:tempButton];
    
    UILabel *secondIndexLabel = [[UILabel alloc] init];
    secondIndexLabel.frame = CGRectMake(9, 8, 15, 15);
    [secondIndexLabel setText:@"2"];
    [tempButton addSubview:secondIndexLabel];
    
    //input part
    tempInputView = _optionInputViewArray[1];
    tempInputView.frame = CGRectMake(heightOfOneLineInContainer, heightOfOneLineInResponder, 298 - heightOfOneLineInContainer, heightOfOneLineInResponder);
    [_thirdResponder addSubview:tempInputView];
    
    UIImageView *secondLineMarkerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:lineImage]];
    secondLineMarkerImageView.frame = CGRectMake( 0 , ( heightOfOneLineInResponder - heightOfLineArrow ) / 2, heightOfLineArrow, heightOfLineArrow);
    [tempInputView addSubview:secondLineMarkerImageView];
    
    tempTextField = _optionTextfieldArray[1];
    tempTextField.frame = CGRectMake( heightOfLineArrow, 0, 298 - leftMarginOfWords, heightOfOneLineInResponder);
    tempTextField.keyboardType = UIKeyboardTypeDefault;
    tempTextField.delegate = self;
    tempTextField.returnKeyType = UIReturnKeyDone;
    [tempInputView addSubview:tempTextField];

    
    _addTipView = [[UIView alloc] init];
    _addTipView.frame = CGRectMake(0, 2 * heightOfOneLineInResponder, 298, heightOfOneLineInResponder);
    [_thirdResponder addSubview:_addTipView];
    
    _addIconButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _addIconButton.frame = CGRectMake( 0, 0, heightOfOneLineInContainer, heightOfOneLineInContainer);
    [_addIconButton setImage:[UIImage imageNamed:addIcon] forState:UIControlStateNormal];
    [_addIconButton setImage:[UIImage imageNamed:addIcon] forState:UIControlStateHighlighted];
    [_addIconButton addTarget:self action:@selector(addOneOption:) forControlEvents:UIControlEventTouchDown];
    [_addTipView addSubview:_addIconButton];
    
    _addTipButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _addTipButton.frame = CGRectMake(leftMarginOfWords, 0, 130, heightOfOneLineInResponder);
    [_addTipButton setTitle:@"Add an option" forState:UIControlStateNormal];
    [_addTipButton setTitleColor:[UIColor colorWithRed:0.0 green:0.443 blue:0.737 alpha:1.0] forState:UIControlStateNormal];
    [_addTipButton setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [_addTipButton addTarget:self action:@selector(addOneOption:) forControlEvents:UIControlEventTouchDown];
    [_addTipView addSubview:_addTipButton];
    
  
#pragma -mark fourth container
    //build fourth view container
    _fourthContainer = [[UIView alloc] init];
    originalFourthContainerFrame = CGRectMake(0, heightOfOneLineInContainer + intervalBetweenLines, 298, 2 * (heightOfOneLineInContainer + intervalBetweenLines) + heightOfOneLineInContainer);
    _fourthContainer.frame = originalFourthContainerFrame;
    [_thirdContainer addSubview:_fourthContainer];
    
    //numbers of participants
    _numbersIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:waitingIcon]];
    _numbersIcon.frame = CGRectMake(0, 0, heightOfOneLineInContainer, heightOfOneLineInContainer);
    [_fourthContainer addSubview:_numbersIcon];
    
    _numbersLabel = [[UILabel alloc] init];
    _numbersLabel.frame = CGRectMake(leftMarginOfWords, 0, 270, heightOfOneLineInContainer);
    _numbersLabel.textColor = [UIColor darkGrayColor];
    _numbersLabel.font = [UIFont systemFontOfSize:fontSizeOfTitles];
    _numbersLabel.text = @"Number of participants";
    [_fourthContainer addSubview:_numbersLabel];

    //tap the choice of subject
    _tapNumberGestureRecognizer = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(respondToTapNumberGesture)];
    
    // Specify that the gesture must be a single tap
    _tapNumberGestureRecognizer.numberOfTapsRequired = 1;
    
    // Add the tap gesture recognizer to the view
    _numbersLabel.userInteractionEnabled = YES;
    [_numbersLabel addGestureRecognizer:_tapNumberGestureRecognizer];
    
#pragma -mark fourth responder
    _fourthResponder = [[UIView alloc] init];
    _fourthResponder.frame = CGRectMake(-320, heightOfOneLineInContainer + intervalBetweenLineAndResponder, 298, heightOfOneLineInResponder);
    [_fourthContainer addSubview:_fourthResponder];
//    _fourthResponder.layer.borderWidth = 1;
    _fourthResponder.userInteractionEnabled = YES;
    
    //minus button
    UIButton *minusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    minusButton.frame = CGRectMake(intervalOfButton, (heightOfOneLineInResponder - heightOfButton) / 2, widthOfButton , heightOfButton);
    [minusButton setImage:[UIImage imageNamed:blueButtonBackground] forState:UIControlStateNormal];
    [minusButton setImage:[UIImage imageNamed:blueButtonBackground] forState:UIControlStateHighlighted];
    [minusButton addTarget:self action:@selector(minusNumber:) forControlEvents:UIControlEventTouchDown];
    [_fourthResponder addSubview:minusButton];
    
    UILabel *minusLabel = [[UILabel alloc] init];
    minusLabel.frame = CGRectMake(0, 0, widthOfButton, heightOfButton);
    minusLabel.font = [UIFont systemFontOfSize:fontSizeOfInput];
    minusLabel.textAlignment = NSTextAlignmentCenter;
    minusLabel.text = @"minus";
    minusLabel.textColor = [UIColor whiteColor];
    [minusButton addSubview:minusLabel];
    
    //textfield
    _numberOfPeopleTextField = [[UITextField alloc] init];
    _numberOfPeopleTextField.frame = CGRectMake( intervalOfButton + widthOfButton + intervalOfButton, 0, 50, heightOfOneLineInResponder);
    //_numberOfPeopleTextField.layer.borderWidth = 1;
    _numberOfPeopleTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    //Add number pad
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],nil];
    [numberToolbar sizeToFit];
    _numberOfPeopleTextField.inputAccessoryView = numberToolbar;
    
    _numberOfPeopleTextField.textAlignment = UITextAlignmentCenter;
    _numberOfPeopleTextField.delegate = self;
    _numberOfPeopleTextField.returnKeyType = UIReturnKeyDone;
    [_fourthResponder addSubview:_numberOfPeopleTextField];
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake(intervalOfButton * 3 + widthOfButton + 50, (heightOfOneLineInResponder - heightOfButton) / 2, widthOfButton , heightOfButton);
    [addButton setImage:[UIImage imageNamed:blueButtonBackground] forState:UIControlStateNormal];
    [addButton setImage:[UIImage imageNamed:blueButtonBackground] forState:UIControlStateHighlighted];
    [addButton addTarget:self action:@selector(addNumber:) forControlEvents:UIControlEventTouchDown];
    [_fourthResponder addSubview:addButton];
    
    UILabel *addLabel = [[UILabel alloc] init];
    addLabel.frame = CGRectMake(0, 0, widthOfButton, heightOfButton);
    addLabel.font = [UIFont systemFontOfSize:fontSizeOfInput];
    addLabel.textAlignment = UITextAlignmentCenter;
    addLabel.text = @"add";
    addLabel.textColor = [UIColor whiteColor];
    [addButton addSubview:addLabel];
    
#pragma -mark fifth container
    //build fifth view container
    _fifthContainer = [[UIView alloc] init];
    originalFifthContainerFrame = CGRectMake(0, heightOfOneLineInContainer + intervalBetweenLines, 298, heightOfOneLineInContainer + intervalBetweenLines + heightOfOneLineInContainer);
    _fifthContainer.frame = originalFifthContainerFrame;
    [_fourthContainer addSubview:_fifthContainer];
    
    //password
    _passwordIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:waitingIcon]];
    _passwordIcon.frame = CGRectMake(0, 0, heightOfOneLineInContainer, heightOfOneLineInContainer);
    [_fifthContainer addSubview:_passwordIcon];
    
    _passwordLabel = [[UILabel alloc] init];
    _passwordLabel.frame = CGRectMake(leftMarginOfWords, 0, 130, heightOfOneLineInContainer);
    _passwordLabel.textColor = [UIColor darkGrayColor];
    _passwordLabel.font = [UIFont systemFontOfSize:fontSizeOfTitles];
    _passwordLabel.text = @"Password";
    [_fifthContainer addSubview:_passwordLabel];
    
    //tap the choice of subject
     _tapPasswordGestureRecognizer = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(respondToTapPasswordGesture)];
    
    // Specify that the gesture must be a single tap
    _tapPasswordGestureRecognizer.numberOfTapsRequired = 1;
    
    // Add the tap gesture recognizer to the view
    _passwordLabel.userInteractionEnabled = YES;
    [_passwordLabel addGestureRecognizer:_tapPasswordGestureRecognizer];
    
#pragma -mark fifth responder
    widthOfPasswordTextField = 70;
    
    _fifthResponder = [[UIView alloc] init];
    _fifthResponder.frame = CGRectMake(-320, heightOfOneLineInContainer + intervalBetweenLineAndResponder, 298, heightOfOneLineInResponder);
    [_fifthContainer addSubview:_fifthResponder];
    _fifthResponder.userInteractionEnabled = YES;
    
    _passwordLineMarker = [[UIImageView alloc] initWithImage:[UIImage imageNamed:lineImage]];
    _passwordLineMarker.frame = CGRectMake( (leftMarginOfWords - heightOfLineArrow) / 2, ( heightOfOneLineInResponder - heightOfLineArrow ) / 2, heightOfLineArrow, heightOfLineArrow);
    [_fifthResponder addSubview:_passwordLineMarker];
    
    _passwordTextField = [[UITextField alloc] init];
    _passwordTextField.frame = CGRectMake(leftMarginOfWords, 0, widthOfPasswordTextField, heightOfOneLineInResponder);
    _passwordTextField.keyboardType = UIKeyboardTypeNumberPad;
    _passwordTextField.textAlignment = UITextAlignmentCenter;
    _passwordTextField.delegate = self;
    _passwordTextField.secureTextEntry = YES;
    [_fifthResponder addSubview:_passwordTextField];
    
    _passwordTip = [[UILabel alloc] init];
    _passwordTip.frame = CGRectMake(leftMarginOfWords + widthOfPasswordTextField, 0, 180, heightOfOneLineInResponder);
    _passwordTip.textColor = [UIColor colorWithRed:0.0 green:0.443 blue:0.737 alpha:1.0];
    _passwordTip.textAlignment = UITextAlignmentCenter;
    _passwordTip.font = [UIFont systemFontOfSize:fontSizeOfInput];
    _passwordTip.text = @"Tip: Need Six Numbers";
    [_fifthResponder addSubview:_passwordTip];
    
    _passwordConfirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _passwordConfirmButton.frame = CGRectMake(leftMarginOfWords + widthOfPasswordTextField, (heightOfOneLineInResponder - heightOfButton) / 2, widthOfButton, heightOfButton);
    [_passwordConfirmButton setImage:[UIImage imageNamed:blueButtonBackground] forState:UIControlStateNormal];
    [_passwordConfirmButton setImage:[UIImage imageNamed:blueButtonBackground] forState:UIControlStateHighlighted];
    [_passwordConfirmButton addTarget:self action:@selector(passwordConfirm:) forControlEvents:UIControlEventTouchDown];
    _passwordConfirmButton.hidden = YES;
    [_fifthResponder addSubview:_passwordConfirmButton];
    
    UILabel *confirmLabel = [[UILabel alloc] init];
    confirmLabel.frame = CGRectMake(0, 0, widthOfButton, heightOfButton);
    confirmLabel.textColor = [UIColor whiteColor];
    confirmLabel.textAlignment = UITextAlignmentCenter;
    confirmLabel.text = @"OK";
    [_passwordConfirmButton addSubview:confirmLabel];
    
    
#pragma -mark sixth container
    originalSixthContainerFrame = CGRectMake(0, heightOfOneLineInContainer + intervalBetweenLines, 298, heightOfOneLineInContainer + intervalBetweenLines + heightOfOneLineInContainer);
    
    _sixthContainer = [[UIView alloc] init];
    _sixthContainer.frame = originalSixthContainerFrame;
    [_fifthContainer addSubview:_sixthContainer];
    
    //time limit
    _timeIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:waitingIcon]];
    _timeIcon.frame = CGRectMake(0, 0, heightOfOneLineInContainer, heightOfOneLineInContainer);
    [_sixthContainer addSubview:_timeIcon];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.frame = CGRectMake(leftMarginOfWords, 0, 150, heightOfOneLineInContainer);
    _timeLabel.textColor = [UIColor darkGrayColor];
    _timeLabel.font = [UIFont systemFontOfSize:fontSizeOfTitles];
    _timeLabel.text = @"Time limit";
    [_sixthContainer addSubview:_timeLabel];
    
    //tap the choice of subject
    _tapTimeGestureRecoginizer = [[UITapGestureRecognizer alloc]
                                     initWithTarget:self
                                     action:@selector(respondToTapTimeGesture)];
    
    // Specify that the gesture must be a single tap
    _tapTimeGestureRecoginizer.numberOfTapsRequired = 1;
    
    // Add the tap gesture recognizer to the view
    _timeLabel.userInteractionEnabled = YES;
    [_timeLabel addGestureRecognizer:_tapTimeGestureRecoginizer];
    
#pragma -mark sixth responder
    GLfloat intervalBetweenTimeButtons = 10;
    
    _sixthResponder = [[UIView alloc] init];
    _sixthResponder.frame = CGRectMake(-320, heightOfOneLineInContainer + intervalBetweenLineAndResponder, 298, heightOfOneLineInResponder);
    [_sixthContainer addSubview:_sixthResponder];
    _sixthResponder.userInteractionEnabled = YES;
    
    UIButton *firstTimeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    firstTimeButton.frame = CGRectMake(leftMarginOfWords, (heightOfOneLineInResponder - heightOfButton) / 2, widthOfButton, heightOfButton);
    [firstTimeButton setImage:[UIImage imageNamed:blueButtonBackground] forState:UIControlStateNormal];
    [firstTimeButton setImage:[UIImage imageNamed:redButtonBackground] forState:UIControlStateHighlighted];
    [firstTimeButton addTarget:self action:@selector(choiceTime:) forControlEvents:UIControlEventTouchDown];
    [_sixthResponder addSubview:firstTimeButton];
 
    UILabel *firstTimeLabel = [[UILabel alloc] init];
    firstTimeLabel.frame = CGRectMake(0, 0, widthOfButton, heightOfButton);
    firstTimeLabel.textColor = [UIColor whiteColor];
    firstTimeLabel.textAlignment = UITextAlignmentCenter;
    firstTimeLabel.text = @"5 min";
    [firstTimeButton addSubview:firstTimeLabel];
  
    UIButton *secondTimeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    secondTimeButton.frame = CGRectMake(leftMarginOfWords + widthOfButton + intervalBetweenTimeButtons, (heightOfOneLineInResponder - heightOfButton) / 2, widthOfButton, heightOfButton);
    [secondTimeButton setImage:[UIImage imageNamed:blueButtonBackground] forState:UIControlStateNormal];
    [secondTimeButton setImage:[UIImage imageNamed:redButtonBackground] forState:UIControlStateHighlighted];
    [secondTimeButton addTarget:self action:@selector(choiceTime:) forControlEvents:UIControlEventTouchDown];
    [_sixthResponder addSubview:secondTimeButton];
    
    UILabel *secondTimeLabel = [[UILabel alloc] init];
    secondTimeLabel.frame = CGRectMake(0, 0, widthOfButton, heightOfButton);
    secondTimeLabel.textColor = [UIColor whiteColor];
    secondTimeLabel.textAlignment = UITextAlignmentCenter;
    secondTimeLabel.text = @"15 min";
    [secondTimeButton addSubview:secondTimeLabel];
    
    UIButton *thirdTimeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    thirdTimeButton.frame = CGRectMake(leftMarginOfWords + 2 * (widthOfButton + intervalBetweenTimeButtons), (heightOfOneLineInResponder - heightOfButton) / 2, widthOfButton, heightOfButton);
    [thirdTimeButton setImage:[UIImage imageNamed:blueButtonBackground] forState:UIControlStateNormal];
    [thirdTimeButton setImage:[UIImage imageNamed:redButtonBackground] forState:UIControlStateHighlighted];
    [thirdTimeButton addTarget:self action:@selector(choiceTime:) forControlEvents:UIControlEventTouchDown];
    [_sixthResponder addSubview:thirdTimeButton];
    
    UILabel *thirdTimeLabel = [[UILabel alloc] init];
    thirdTimeLabel.frame = CGRectMake(0, 0, widthOfButton, heightOfButton);
    thirdTimeLabel.textColor = [UIColor whiteColor];
    thirdTimeLabel.textAlignment = UITextAlignmentCenter;
    thirdTimeLabel.text = @"30 min";
    [thirdTimeButton addSubview:thirdTimeLabel];
    
    UIButton *fourthTimeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    fourthTimeButton.frame = CGRectMake(leftMarginOfWords + 3 * (widthOfButton + intervalBetweenTimeButtons), (heightOfOneLineInResponder - heightOfButton) / 2, widthOfButton, heightOfButton);
    [fourthTimeButton setImage:[UIImage imageNamed:blueButtonBackground] forState:UIControlStateNormal];
    [fourthTimeButton setImage:[UIImage imageNamed:redButtonBackground] forState:UIControlStateHighlighted];
    [fourthTimeButton addTarget:self action:@selector(choiceTime:) forControlEvents:UIControlEventTouchDown];
    [_sixthResponder addSubview:fourthTimeButton];
    
    UILabel *fourthTimeLabel = [[UILabel alloc] init];
    fourthTimeLabel.frame = CGRectMake(0, 0, widthOfButton, heightOfButton);
    fourthTimeLabel.textColor = [UIColor whiteColor];
    fourthTimeLabel.textAlignment = UITextAlignmentCenter;
    fourthTimeLabel.text = @"1 hour";
    [fourthTimeButton addSubview:fourthTimeLabel];
    
    
    //Done button
    _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _doneButton.frame = CGRectMake(leftMarginOfWords, 6 * (heightOfOneLineInContainer + intervalBetweenLines) + (heightOfOneLineInResponder - heightOfButton) / 2 + heightOfOneLineInResponder, widthOfButton, heightOfButton);
    [_doneButton setImage:[UIImage imageNamed:blueButtonBackground] forState:UIControlStateNormal];
    [_doneButton setImage:[UIImage imageNamed:redButtonBackground] forState:UIControlStateHighlighted];
    _doneButton.hidden = YES;
    [_doneButton addTarget:self action:@selector(doneWithAllSteps:) forControlEvents:UIControlEventTouchDown];
    [_mainContainer addSubview:_doneButton];
    
    UILabel *doneLabel = [[UILabel alloc] init];
    doneLabel.frame = CGRectMake(0, 0, widthOfButton, heightOfButton);
    doneLabel.textColor = [UIColor whiteColor];
    doneLabel.textAlignment = UITextAlignmentCenter;
    doneLabel.text = @"Done";
    [_doneButton addSubview:doneLabel];
    
    _locationManager = nil;
}

- (void)dealloc
{
    _locationManager = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //try to get the user's location,if the
    if ([CLLocationManager locationServicesEnabled]) {
        if (!_locationManager) {
            _locationManager = [[CLLocationManager alloc] init];
            _locationManager.delegate = self;
        }
        
        [_locationManager startUpdatingLocation];
    }
    
    //set the plankton server's delegate
    [[PLServer shareInstance] setDelegate:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_locationManager stopUpdatingLocation];
    [self dismissLoadingView];
    //[[PLServer shareInstance] closeConnection];
}

- (void)textViewDidChange:(UITextView *)textView
{
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    GLfloat oneLineInTextfield = 19;
    if (newFrame.size.height > textView.frame.size.height) {
        numberOfLines++;
        NSLog(@"%f",newFrame.size.height - textView.frame.size.height );
        _thirdContainer.frame = CGRectMake(originalThirdContainerFrame.origin.x, originalThirdContainerFrame.origin.y +  numberOfLines * oneLineInTextfield, originalThirdContainerFrame.size.width, originalThirdContainerFrame.size.height);
        
    }else if (newFrame.size.height < textView.frame.size.height)
    {
        numberOfLines--;
        _thirdContainer.frame = CGRectMake(originalThirdContainerFrame.origin.x, originalThirdContainerFrame.origin.y +  numberOfLines * oneLineInTextfield, originalThirdContainerFrame.size.width, originalThirdContainerFrame.size.height);
    }
    
    textView.frame = newFrame;
    CGRect responderFrame = _secondResponder.frame;
    _secondResponder.frame = CGRectMake(responderFrame.origin.x, responderFrame.origin.y, responderFrame.size.width, newFrame.size.height);
    if (numberOfLines > 7) {
        [_mainContainer setContentOffset:CGPointMake(0, heightOfOneLineInContainer + intervalBetweenLines + oneLineInTextfield * (numberOfLines - 7)) animated:NO];
    }else{
        [_mainContainer setContentOffset:CGPointMake(0, heightOfOneLineInContainer + intervalBetweenLines ) animated:NO];
    }
    currentHeightOfCurrentResponder = _secondResponder.frame.size.height;
    _mainContainer.contentSize = CGSizeMake(298, originalHeightOfMainContainerContentSize + currentHeightOfCurrentResponder);
    if ([textView.text isEqualToString:@""]) {
        subjectSetIsDone = NO;
    }else{
        subjectSetIsDone = YES;
    }

    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{

    
    if ([text isEqualToString:@"\n"]) {
        
        taskInCurrentResponderIsDone = subjectSetIsDone;
    
        [textView resignFirstResponder];

        [_mainContainer setContentOffset:CGPointMake(0, 0) animated:YES];
        
        return NO;
    }
    return  YES;
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    [_mainContainer setContentOffset:CGPointMake(0, 0) animated:YES];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    for (int i = 0; i < numberOfOptions; i++) {
        if ([textField isEqual:_optionTextfieldArray[i]]) {
            currentTextfield = _optionTextfieldArray[i];
            if (i < 3) {
                [_mainContainer setContentOffset:CGPointMake(0, 2 * (heightOfOneLineInContainer + intervalBetweenLines) ) animated:YES];
            }else{
                [_mainContainer setContentOffset:CGPointMake(0, (i - 2) * heightOfOneLineInResponder + 2 * (heightOfOneLineInContainer + intervalBetweenLines) ) animated:YES];
            }
        }
    }

}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    int tempNumber;

    if ([textField isEqual:_numberOfPeopleTextField]) {
        if (range.location >= 3) {
            return  NO;
        }
        tempNumber = [_numberOfPeopleTextField.text intValue];
        numberOfPeople = tempNumber * 10 + [string intValue];
    }else if ([textField isEqual:_passwordTextField]){
        if (range.location == 5) {
            tempPassword = [_passwordTextField.text intValue] * 10 + [string intValue];
            _passwordTip.hidden = YES;
            _passwordConfirmButton.hidden = NO;
        }
        
        if (range.location >= 6)
            return NO;
    }
    return  YES;
}



#pragma -mark action related to each title
- (void)respondToTapColorChoiceGesture
{
    [_mainContainer setContentOffset:CGPointMake(0, 0 ) animated:NO];
    //recomputer the main container's size
   // _mainContainer.frame = CGRectMake(_mainContainer.frame.origin.x, _mainContainer.frame.origin.y, _mainContainer.frame.size.width, mainContainerHeight + heightOfOneLineInResponder);
    
    taskInCurrentResponderIsDone = [self isCurrentTaskDone];
    
    [self calculateStepsHaveBeenFinished];
    
    //if there is a textfield having focous, then resign it
    if (currentTextfield) {
        [currentTextfield resignFirstResponder];
    }
    
    if (_subjectTextView) {
        [_subjectTextView resignFirstResponder];
    }
    
    if (currentRunningContainer) {
        //to judge if the task in current responder is completed
        if (taskInCurrentResponderIsDone) {
            currentStateIcon.image = [UIImage imageNamed:DoneIcon];
        } else {
            currentStateIcon.image = [UIImage imageNamed:FailedIcon];
        }
        
        //let the current responder move away(to the right)
        [Animations moveRight:currentRunningResponder andAnimationDuration:1.0 andWait:YES andLength:320.0];
        
        
        //replace the current responder to its original place
        CGRect tempFrame = currentRunningResponder.frame;
        currentRunningResponder.frame = CGRectMake(-320, tempFrame.origin.y, tempFrame.size.width, tempFrame.size.height);
        
        //reconnect the current title of container and the tap gesture resongnizer
        [currentTitleOfContainer addGestureRecognizer:currentTapGestureRecongnizer];
        
        //move the current container back
        [Animations moveUp:currentRunningContainer andAnimationDuration:1.0 andWait:YES andLength:currentHeightOfCurrentResponder];

    }

    
    //If it is the first time to
    //put current responder into currentRunningResponder
    currentRunningResponder = _theFirstResponder;
    
    //change the current state image :from waiting to onGoing
    _themeColorIcon.image = [UIImage imageNamed:onGoingIcon];
    
    //second view container move down
    [Animations moveDown:_secondContainer andAnimationDuration:1.0 andWait:YES andLength:heightOfOneLineInResponder];
    
    //first responder move right
    [Animations moveRight:_theFirstResponder andAnimationDuration:1.0 andWait:YES andLength:320.0];

    
    //remove the Theme color choice action
    [_themeColorLabel removeGestureRecognizer:_tapColorChoiceRecognizer];
    
    //store the current moved container
    currentRunningContainer = _secondContainer;
    
    //store the current stateIcon
    currentStateIcon = _themeColorIcon;
    
    
    //store the current container's title
    currentTitleOfContainer = _themeColorLabel;
    
    //store the current tap gesture recongnizer
    currentTapGestureRecongnizer = _tapColorChoiceRecognizer;
    
    //store the curent height of responder
    currentHeightOfCurrentResponder = _theFirstResponder.frame.size.height;
    
    currentHeightOfCurrentResponder = heightOfOneLineInResponder;
    
    colorChoiceIsDone = YES;
    
    taskInCurrentResponderIsDone = colorChoiceIsDone;
    
    //change the size of main container
    _mainContainer.contentSize = CGSizeMake(298, originalHeightOfMainContainerContentSize + currentHeightOfCurrentResponder );
    
}

- (void)respondToTapSubjectGesture
{
    
    [_mainContainer setContentOffset:CGPointMake(0, 0 ) animated:NO];
    
    
    taskInCurrentResponderIsDone = [self isCurrentTaskDone];
    [self calculateStepsHaveBeenFinished];
    
    //if there is a textfield having focous, then resign it
    if (currentTextfield) {
        [currentTextfield resignFirstResponder];
    }
    
    if (_subjectTextView) {
        [_subjectTextView resignFirstResponder];
    }
    
    //to judge if the task in current responder is completed
    if (taskInCurrentResponderIsDone) {
        currentStateIcon.image = [UIImage imageNamed:DoneIcon];
    } else {
        currentStateIcon.image = [UIImage imageNamed:FailedIcon];
    }
    
    //let the current responder move away(to the right)
    [Animations moveRight:currentRunningResponder andAnimationDuration:1.0 andWait:YES andLength:320.0];


    //replace the current responder to its original place
    CGRect tempFrame = currentRunningResponder.frame;
    currentRunningResponder.frame = CGRectMake(-320, tempFrame.origin.y, tempFrame.size.width, tempFrame.size.height);

    //reconnect the current title of container and the tap gesture resongnizer
    [currentTitleOfContainer addGestureRecognizer:currentTapGestureRecongnizer];
    
    //move the current container back
    [Animations moveUp:currentRunningContainer andAnimationDuration:1.0 andWait:YES andLength:currentHeightOfCurrentResponder];
    
    //move down the next container
    [Animations moveDown:_thirdContainer andAnimationDuration:1.0 andWait:YES andLength:_secondResponder.frame.size.height];
    
    //change the state icon
    _subjectIcon.image = [UIImage imageNamed:onGoingIcon];
    
    //record third container to current container
    currentRunningContainer = _thirdContainer;
    
    //show the second responder
    [Animations moveRight:_secondResponder andAnimationDuration:1.0 andWait:YES andLength:320.0];

    //record the second responder to current responder
    currentRunningResponder = _secondResponder;
    
    //remove the action bond with the subject title
    [_subjectLabel removeGestureRecognizer:_tapSubjectRecognizer];
    
    
    //recompute the hiehgt of second container
    _secondContainer.frame = CGRectMake(originalSecondContainerFrame.origin.x, originalSecondContainerFrame.origin.y, originalSecondContainerFrame.size.width, originalSecondContainerFrame.size.height + heightOfOneLineInResponder);

    //store the current state icon
    currentStateIcon = _subjectIcon;

    
    //reset the mark
    taskInCurrentResponderIsDone = NO;
    
    //store the title of current container
    currentTitleOfContainer = _subjectLabel;
    
    //store the current tap gesture recognizer
    currentTapGestureRecongnizer = _tapSubjectRecognizer;
    
    [_mainContainer setContentOffset:CGPointMake(0, heightOfOneLineInContainer + intervalBetweenLines) animated:YES];
    
    
    currentHeightOfCurrentResponder = _secondResponder.frame.size.height;

    [_subjectTextView becomeFirstResponder];

    //change the size of main container
    _mainContainer.contentSize = CGSizeMake(298, originalHeightOfMainContainerContentSize + currentHeightOfCurrentResponder );
    
    [_subjectTextView becomeFirstResponder];
}


- (void)respondToTapOptionGesture
{

    [_mainContainer setContentOffset:CGPointMake(0, 0 ) animated:NO];
    
    taskInCurrentResponderIsDone = [self isCurrentTaskDone];
    [self calculateStepsHaveBeenFinished];
    
    //if there is a textfield having focous, then resign it
    if (currentTextfield) {
        [currentTextfield resignFirstResponder];
    }
    
    if (_subjectTextView) {
        [_subjectTextView resignFirstResponder];
    }
    
    //to judge if the task in current responder is completed
    if (taskInCurrentResponderIsDone) {
        currentStateIcon.image = [UIImage imageNamed:DoneIcon];
    } else {
        currentStateIcon.image = [UIImage imageNamed:FailedIcon];
    }
    
    //let the current responder move away(to the right)
    [Animations moveRight:currentRunningResponder andAnimationDuration:1.0 andWait:YES andLength:320.0];
    
    
    //replace the current responder to its original place
    CGRect tempFrame = currentRunningResponder.frame;
    currentRunningResponder.frame = CGRectMake(-320, tempFrame.origin.y, tempFrame.size.width, tempFrame.size.height);
    
    //reconnect the current title of container and the tap gesture resongnizer
    [currentTitleOfContainer addGestureRecognizer:currentTapGestureRecongnizer];
    
    //move the current container back
    [Animations moveUp:currentRunningContainer andAnimationDuration:1.0 andWait:YES andLength:currentHeightOfCurrentResponder];
    
    //move down the next container
    [Animations moveDown:_fourthContainer andAnimationDuration:1.0 andWait:YES andLength:(numberOfOptions + 1) * heightOfOneLineInResponder];
    
    //change the state icon
    _optionIcon.image = [UIImage imageNamed:onGoingIcon];
    
    //record fouth container to current container
    currentRunningContainer = _fourthContainer;
    
    //show the third responder
    [Animations moveRight:_thirdResponder andAnimationDuration:1.0 andWait:YES andLength:320.0];
    
    //record the third responder to current responder
    currentRunningResponder = _thirdResponder;
    
    //remove the action bond with the option title
    [_optionLabel removeGestureRecognizer:_tapOptionGestureRecognizer];

    
    //recompute the hiehgt of second container
    _secondContainer.frame = CGRectMake(originalSecondContainerFrame.origin.x, originalSecondContainerFrame.origin.y, originalSecondContainerFrame.size.width, originalSecondContainerFrame.size.height + (numberOfOptions + 1) * heightOfOneLineInResponder);
    
    //recompute the height of third container
    _thirdContainer.frame = CGRectMake(originalThirdContainerFrame.origin.x, originalThirdContainerFrame.origin.y, originalThirdContainerFrame.size.width, originalThirdContainerFrame.size.height + (numberOfOptions + 1) * heightOfOneLineInResponder);
    
    //store the current state icon
    currentStateIcon = _optionIcon;
    
    
    //reset the mark
    taskInCurrentResponderIsDone = NO;
    
    //store the title of current container
    currentTitleOfContainer = _optionLabel;
    
    //store the current tap gesture recognizer
    currentTapGestureRecongnizer = _tapOptionGestureRecognizer;
    
    [_mainContainer setContentOffset:CGPointMake(0, 2 * (heightOfOneLineInContainer + intervalBetweenLines) ) animated:YES];
    
    currentHeightOfCurrentResponder = _thirdResponder.frame.size.height;
    
    //change the size of main container
    _mainContainer.contentSize = CGSizeMake(298, originalHeightOfMainContainerContentSize + currentHeightOfCurrentResponder );
    
    currentTextfield = _optionTextfieldArray[0];
    
    [_optionTextfieldArray[0] becomeFirstResponder];
}


- (void)respondToTapNumberGesture
{
    [_mainContainer setContentOffset:CGPointMake(0, 0 ) animated:NO];
    
    taskInCurrentResponderIsDone = [self isCurrentTaskDone];
    [self calculateStepsHaveBeenFinished];
    
    if (currentTextfield) {
        [currentTextfield resignFirstResponder];
    }
    
    if (_subjectTextView) {
        [_subjectTextView resignFirstResponder];
    }
    
    //to judge if the task in current responder is completed
    if (taskInCurrentResponderIsDone) {
        currentStateIcon.image = [UIImage imageNamed:DoneIcon];
    } else {
        currentStateIcon.image = [UIImage imageNamed:FailedIcon];
    }
    
    //let the current responder move away(to the right)
    [Animations moveRight:currentRunningResponder andAnimationDuration:1.0 andWait:YES andLength:320.0];
    
    
    //replace the current responder to its original place
    CGRect tempFrame = currentRunningResponder.frame;
    currentRunningResponder.frame = CGRectMake(-320, tempFrame.origin.y, tempFrame.size.width, tempFrame.size.height);
    
    //reconnect the current title of container and the tap gesture resongnizer
    [currentTitleOfContainer addGestureRecognizer:currentTapGestureRecongnizer];
    
    //move the current container back
    
    [Animations moveUp:currentRunningContainer andAnimationDuration:1.0 andWait:YES andLength:currentHeightOfCurrentResponder];
    
    //move down the next container
    [Animations moveDown:_fifthContainer andAnimationDuration:1.0 andWait:YES andLength:heightOfOneLineInResponder];
    
    //change the state icon
    _numbersIcon.image = [UIImage imageNamed:onGoingIcon];
    
    //record fifth container to current container
    currentRunningContainer = _fifthContainer;
    
    //show the fourth responder
    [Animations moveRight:_fourthResponder andAnimationDuration:1.0 andWait:YES andLength:320.0];
    
    //record the fourth responder to current responder
    currentRunningResponder = _fourthResponder;
    
    //remove the action
    [_numbersLabel removeGestureRecognizer:_tapNumberGestureRecognizer];

    
    //recompute the hiehgt of second container
    _secondContainer.frame = CGRectMake(originalSecondContainerFrame.origin.x, originalSecondContainerFrame.origin.y, originalSecondContainerFrame.size.width, originalSecondContainerFrame.size.height + heightOfOneLineInResponder);
    
    //recompute the height of third container
    _thirdContainer.frame = CGRectMake(originalThirdContainerFrame.origin.x, originalThirdContainerFrame.origin.y, originalThirdContainerFrame.size.width, originalThirdContainerFrame.size.height + heightOfOneLineInResponder);
    
    _fourthContainer.frame = CGRectMake(originalFourthContainerFrame.origin.x, originalFourthContainerFrame.origin.y, originalFourthContainerFrame.size.width, originalFourthContainerFrame.size.height + heightOfOneLineInResponder);
    
    //store the current state icon
    currentStateIcon = _numbersIcon;
    
    //reset the mark
    taskInCurrentResponderIsDone = NO;
    
    //store the title of current container
    currentTitleOfContainer = _numbersLabel;
    
    //store the current tap gesture recognizer
    currentTapGestureRecongnizer = _tapNumberGestureRecognizer;
    
    [_mainContainer setContentOffset:CGPointMake(0, 3 * (heightOfOneLineInContainer + intervalBetweenLines) ) animated:NO];
    
    //_mainContainer.frame = CGRectMake(_mainContainer.frame.origin.x, _mainContainer.frame.origin.y, _mainContainer.frame.size.width, 187);
    
    currentTextfield = _numberOfPeopleTextField;
    
    currentHeightOfCurrentResponder = _fourthResponder.frame.size.height;
    
    //change the size of main container
    _mainContainer.contentSize = CGSizeMake(298, originalHeightOfMainContainerContentSize + currentHeightOfCurrentResponder );
    
    [_numberOfPeopleTextField becomeFirstResponder];
    
}


- (void)respondToTapPasswordGesture
{
    [_mainContainer setContentOffset:CGPointMake(0, 0 ) animated:NO];
    
    taskInCurrentResponderIsDone = [self isCurrentTaskDone];
    [self calculateStepsHaveBeenFinished];
    
    if (currentTextfield) {
        [currentTextfield resignFirstResponder];
    }
    
    if (_subjectTextView) {
        [_subjectTextView resignFirstResponder];
    }
    
    //to judge if the task in current responder is completed
    if (taskInCurrentResponderIsDone) {
        currentStateIcon.image = [UIImage imageNamed:DoneIcon];
    } else {
        currentStateIcon.image = [UIImage imageNamed:FailedIcon];
    }
    
    //let the current responder move away(to the right)
    [Animations moveRight:currentRunningResponder andAnimationDuration:1.0 andWait:YES andLength:320.0];
    
    
    //replace the current responder to its original place
    CGRect tempFrame = currentRunningResponder.frame;
    currentRunningResponder.frame = CGRectMake(-320, tempFrame.origin.y, tempFrame.size.width, tempFrame.size.height);
    
    //reconnect the current title of container and the tap gesture resongnizer
    [currentTitleOfContainer addGestureRecognizer:currentTapGestureRecongnizer];
    
    //move the current container back
    [Animations moveUp:currentRunningContainer andAnimationDuration:1.0 andWait:YES andLength:currentHeightOfCurrentResponder];

    //move down the next container
    [Animations moveDown:_sixthContainer andAnimationDuration:1.0 andWait:YES andLength:heightOfOneLineInResponder];
    
    //change the state icon
    _passwordIcon.image = [UIImage imageNamed:onGoingIcon];
    
    //record fifth container to current container
    currentRunningContainer = _sixthContainer;
    
    //show the fourth responder
    [Animations moveRight:_fifthResponder andAnimationDuration:1.0 andWait:YES andLength:320.0];
    
    //record the fourth responder to current responder
    currentRunningResponder = _fifthResponder;
    
    //remove the action
    [_passwordLabel removeGestureRecognizer:_tapPasswordGestureRecognizer];
    
    
    //recompute the hiehgt of second container
    _secondContainer.frame = CGRectMake(originalSecondContainerFrame.origin.x, originalSecondContainerFrame.origin.y, originalSecondContainerFrame.size.width, originalSecondContainerFrame.size.height + heightOfOneLineInResponder);
    
    //recompute the height of third container
    _thirdContainer.frame = CGRectMake(originalThirdContainerFrame.origin.x, originalThirdContainerFrame.origin.y, originalThirdContainerFrame.size.width, originalThirdContainerFrame.size.height + heightOfOneLineInResponder);
    
    _fourthContainer.frame = CGRectMake(originalFourthContainerFrame.origin.x, originalFourthContainerFrame.origin.y, originalFourthContainerFrame.size.width, originalFourthContainerFrame.size.height + heightOfOneLineInResponder);
    
    _fifthContainer.frame = CGRectMake(originalFifthContainerFrame.origin.x, originalFifthContainerFrame.origin.y, originalFifthContainerFrame.size.width, originalFifthContainerFrame.size.height + heightOfOneLineInResponder);
    
    //store the current state icon
    currentStateIcon = _passwordIcon;
    
    //reset the mark
    taskInCurrentResponderIsDone = NO;
    
    //store the title of current container
    currentTitleOfContainer = _passwordLabel;
    
    //store the current tap gesture recognizer
    currentTapGestureRecongnizer = _tapPasswordGestureRecognizer;
    
    currentTextfield = _passwordTextField;
    
    currentHeightOfCurrentResponder = _fifthResponder.frame.size.height;
    
    //change the size of main container
    _mainContainer.contentSize = CGSizeMake(298, originalHeightOfMainContainerContentSize + currentHeightOfCurrentResponder );
    
    [_mainContainer setContentOffset:CGPointMake(0, 4 * (heightOfOneLineInContainer + intervalBetweenLines) ) animated:NO];
    
    [_passwordTextField becomeFirstResponder];
}


- (void)respondToTapTimeGesture
{
    [_mainContainer setContentOffset:CGPointMake(0, 0 ) animated:NO];

    
    taskInCurrentResponderIsDone = [self isCurrentTaskDone];
    [self calculateStepsHaveBeenFinished];
    
    if (currentTextfield) {
        [currentTextfield resignFirstResponder];
    }
    
    if (_subjectTextView) {
        [_subjectTextView resignFirstResponder];
    }
    
    //to judge if the task in current responder is completed
    if (taskInCurrentResponderIsDone) {
        currentStateIcon.image = [UIImage imageNamed:DoneIcon];
    } else {
        currentStateIcon.image = [UIImage imageNamed:FailedIcon];
    }
    
    //let the current responder move away(to the right)
    [Animations moveRight:currentRunningResponder andAnimationDuration:1.0 andWait:YES andLength:320.0];
    
    
    //replace the current responder to its original place
    CGRect tempFrame = currentRunningResponder.frame;
    currentRunningResponder.frame = CGRectMake(-320, tempFrame.origin.y, tempFrame.size.width, tempFrame.size.height);
    
    //reconnect the current title of container and the tap gesture resongnizer
    [currentTitleOfContainer addGestureRecognizer:currentTapGestureRecongnizer];
    
    //move the current container back
    [Animations moveUp:currentRunningContainer andAnimationDuration:1.0 andWait:YES andLength:currentHeightOfCurrentResponder];
    
    //change the state icon
    _timeIcon.image = [UIImage imageNamed:onGoingIcon];
    
    //record fifth container to current container
    currentRunningContainer = nil;
    
    //show the fourth responder
    [Animations moveRight:_sixthResponder andAnimationDuration:1.0 andWait:YES andLength:320.0];
    
    //record the fourth responder to current responder
    currentRunningResponder = _sixthResponder;
    
    //remove the action
    [_timeLabel removeGestureRecognizer:_tapTimeGestureRecoginizer];
    
    
    //recompute the hiehgt of second container
    _secondContainer.frame = CGRectMake(originalSecondContainerFrame.origin.x, originalSecondContainerFrame.origin.y, originalSecondContainerFrame.size.width, originalSecondContainerFrame.size.height + heightOfOneLineInResponder + intervalBetweenLineAndResponder);
    
    //recompute the height of third container
    _thirdContainer.frame = CGRectMake(originalThirdContainerFrame.origin.x, originalThirdContainerFrame.origin.y, originalThirdContainerFrame.size.width, originalThirdContainerFrame.size.height + heightOfOneLineInResponder + intervalBetweenLineAndResponder);
    
    _fourthContainer.frame = CGRectMake(originalFourthContainerFrame.origin.x, originalFourthContainerFrame.origin.y, originalFourthContainerFrame.size.width, originalFourthContainerFrame.size.height + heightOfOneLineInResponder + intervalBetweenLineAndResponder);
    
    _fifthContainer.frame = CGRectMake(originalFifthContainerFrame.origin.x, originalFifthContainerFrame.origin.y, originalFifthContainerFrame.size.width, originalFifthContainerFrame.size.height + heightOfOneLineInResponder + intervalBetweenLineAndResponder);
    
    _sixthContainer.frame = CGRectMake(originalSixthContainerFrame.origin.x, originalSixthContainerFrame.origin.y, originalSixthContainerFrame.size.width, originalSixthContainerFrame.size.height + heightOfOneLineInResponder + intervalBetweenLineAndResponder);
    
    //store the current state icon
    currentStateIcon = _timeIcon;
    
    //reset the mark
    taskInCurrentResponderIsDone = NO;
    
    //store the title of current container
    currentTitleOfContainer = _timeLabel;
    
    //store the current tap gesture recognizer
    currentTapGestureRecongnizer = _tapTimeGestureRecoginizer;
    
    currentTextfield = nil;
    
    currentHeightOfCurrentResponder = _sixthResponder.frame.size.height;
    
    //change the size of main container
    _mainContainer.contentSize = CGSizeMake(298, originalHeightOfMainContainerContentSize + currentHeightOfCurrentResponder );
    
    timeSetIsDone = YES;
    
}

#pragma -mark other

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma circle button action
- (void)greenSelected:(UIButton *)sender
{
    selectedColorIndex = 0;
    _arrow.image = [UIImage imageNamed:arrowImages[selectedColorIndex]];
}

- (void)blueSelected:(UIButton *)sender
{
    selectedColorIndex = 1;
    _arrow.image = [UIImage imageNamed:arrowImages[selectedColorIndex]];
}

- (void)yellowSelected:(UIButton *)sender
{
    selectedColorIndex = 2;
    _arrow.image = [UIImage imageNamed:arrowImages[selectedColorIndex]];
}

- (void)redSelected:(UIButton *)sender
{
    selectedColorIndex = 3;
    _arrow.image = [UIImage imageNamed:arrowImages[selectedColorIndex]];
}

- (void)blackSelected:(UIButton *)sender
{
    selectedColorIndex = 4;
    _arrow.image = [UIImage imageNamed:arrowImages[selectedColorIndex]];
}

//add one option
- (void) addOneOption:(UIButton *)sender
{
    //recalculate the number of options
    numberOfOptions ++;

    GLfloat tempHeight;
    tempHeight = _mainContainer.frame.size.height +  heightOfOneLineInResponder;
    
 /*   if (tempHeight < 403) {
        _mainContainer.frame = CGRectMake(_mainContainer.frame.origin.x, _mainContainer.frame.origin.y, _mainContainer.frame.size.width, tempHeight);
    }*/
    
    //test if it need to reset the main container's offset
    BOOL needScroll = YES;
    
    if (! _mainContainer.contentOffset.y) {
     //   needScroll = NO;
    }
    
    //move down the fourth container
    [Animations doubleMoveDown:_fourthContainer anotherView:_addTipView andAnimationDuration:1.0 andWait:YES andLength:heightOfOneLineInResponder];

    
    //modify the height of third responder
    CGRect currentResponderFrame = _thirdResponder.frame;
    _thirdResponder.frame = CGRectMake(currentResponderFrame.origin.x, currentResponderFrame.origin.y, currentResponderFrame.size.width, (numberOfOptions + 1) * heightOfOneLineInResponder);
 
    //modify the height of second container
    _secondContainer.frame = CGRectMake(originalSecondContainerFrame.origin.x, originalSecondContainerFrame.origin.y, originalSecondContainerFrame.size.width, originalSecondContainerFrame.size.height + (numberOfOptions + 1) * heightOfOneLineInResponder);

    //modify the height of third container
    _thirdContainer.frame = CGRectMake(originalThirdContainerFrame.origin.x, originalThirdContainerFrame.origin.y, originalThirdContainerFrame.size.width, originalThirdContainerFrame.size.height + (numberOfOptions +1) * heightOfOneLineInResponder);
    
    //use the tempArry to store all buttons
    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:_optionIndexArray];
    
    //add new button
    UIButton *tempButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tempButton.frame = CGRectMake(0, (heightOfOneLineInResponder - heightOfOneLineInContainer ) / 2 + currentResponderFrame.size.height - heightOfOneLineInResponder, heightOfOneLineInContainer, heightOfOneLineInContainer);
    [tempButton setImage:[UIImage imageNamed:optionIndexImage] forState:UIControlStateNormal];
    [tempButton setImage:[UIImage imageNamed:optionIndexImage] forState:UIControlStateHighlighted];
    [tempButton addTarget:self action:@selector(tapOnIndexOfOption:) forControlEvents:UIControlEventTouchDown];
    [_thirdResponder addSubview:tempButton];
    
    //index number
    UILabel *addedIndexLabel = [[UILabel alloc] init];
    addedIndexLabel.frame = CGRectMake(0, 0, heightOfOneLineInContainer, heightOfOneLineInContainer);
    addedIndexLabel.textAlignment = UITextAlignmentCenter;
    [addedIndexLabel setText:[NSString stringWithFormat:@"%d", numberOfOptions]];
    [tempButton addSubview:addedIndexLabel];
    
    
    [tempArray addObject:tempButton];
    _optionIndexArray = [[NSArray alloc] initWithArray:tempArray];

    
    //store the input views
    NSMutableArray *tempInputViewArray = [[NSMutableArray alloc] initWithArray:_optionInputViewArray];
    UIView *tempInputView = [[UIView alloc] init];
    tempInputView.frame = CGRectMake(heightOfOneLineInContainer, currentResponderFrame.size.height - heightOfOneLineInResponder, 298 - heightOfOneLineInContainer, heightOfOneLineInResponder);
    [_thirdResponder addSubview:tempInputView];
    
    //line marker
    UIImageView *addedOptionLineMarkerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:lineImage]];
    addedOptionLineMarkerImageView.frame = CGRectMake( 0 , ( heightOfOneLineInResponder - heightOfLineArrow ) / 2, heightOfLineArrow, heightOfLineArrow);
    [tempInputView addSubview:addedOptionLineMarkerImageView];

    //used to temparily store the current whole textfields
    NSMutableArray *tempTextFieldArray = [[NSMutableArray alloc] initWithArray:_optionTextfieldArray];
    
    //input field
    UITextField *tempOptionTextField = [[UITextField alloc] init];
    tempOptionTextField.frame = CGRectMake( heightOfLineArrow, 0, 298 - leftMarginOfWords, heightOfOneLineInResponder);
    tempOptionTextField.keyboardType = UIKeyboardAppearanceDefault;
    tempOptionTextField.delegate = self;
    tempOptionTextField.returnKeyType = UIReturnKeyDone;
    [tempInputView addSubview:tempOptionTextField];
    
    //store the current textfield
    currentTextfield = tempOptionTextField;
   
    
    [tempTextFieldArray addObject:tempOptionTextField];
    _optionTextfieldArray = [[NSArray alloc] initWithArray:tempTextFieldArray];
    
    [tempInputViewArray addObject:tempInputView];
    _optionInputViewArray = [[NSArray alloc] initWithArray:tempInputViewArray];
    
    UIView *tempDeleteView = [[UIView alloc] init];
    tempDeleteView .frame = CGRectMake(heightOfOneLineInContainer, currentResponderFrame.size.height - heightOfOneLineInResponder, 298 - heightOfOneLineInContainer, heightOfOneLineInResponder);
    [_thirdResponder addSubview:tempDeleteView ];
    tempDeleteView.hidden = YES;
    
    //"cancel" button
    UIButton *tempCancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tempCancelButton.frame = CGRectMake(intervalOfButton, (heightOfOneLineInResponder - heightOfButton) / 2, widthOfButton , heightOfButton);
    [tempCancelButton setImage:[UIImage imageNamed:blueButtonBackground] forState:UIControlStateNormal];
    [tempCancelButton setImage:[UIImage imageNamed:blueButtonBackground] forState:UIControlStateHighlighted];
    [tempCancelButton addTarget:self action:@selector(cancelButton:) forControlEvents:UIControlEventTouchDown];
    [tempDeleteView addSubview:tempCancelButton];

    UILabel *cancelLabel = [[UILabel alloc] init];
    cancelLabel.frame = CGRectMake(0, 0, widthOfButton, heightOfButton);
    cancelLabel.font = [UIFont systemFontOfSize:fontSizeOfInput];
    cancelLabel.textAlignment = UITextAlignmentCenter;
    cancelLabel.text = @"Cancel";
    cancelLabel.textColor = [UIColor whiteColor];
    [tempCancelButton addSubview:cancelLabel];
    
    //"delete" button
    UIButton *tempDeleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tempDeleteButton.frame = CGRectMake(intervalOfButton + leftMarginOfWords + widthOfButton, (heightOfOneLineInResponder - heightOfButton) / 2, widthOfButton , heightOfButton);
    [tempDeleteButton setImage:[UIImage imageNamed:redButtonBackground] forState:UIControlStateNormal];
    [tempDeleteButton setImage:[UIImage imageNamed:redButtonBackground] forState:UIControlStateHighlighted];
    [tempDeleteButton addTarget:self action:@selector(deleteButton:) forControlEvents:UIControlEventTouchDown];
    [tempDeleteView addSubview:tempDeleteButton];
    
    UILabel *deleteLabel = [[UILabel alloc] init];
    deleteLabel.frame = CGRectMake(0, 0, widthOfButton, heightOfButton);
    deleteLabel.font = [UIFont systemFontOfSize:fontSizeOfInput];
    deleteLabel.textAlignment = UITextAlignmentCenter;
    deleteLabel.text = @"Delete";
    deleteLabel.textColor = [UIColor whiteColor];
    [tempDeleteButton addSubview:deleteLabel];
    
    
    if ( needScroll) {
        if (numberOfOptions < 3) {
            [_mainContainer setContentOffset:CGPointMake(0, 2 * (heightOfOneLineInContainer + intervalBetweenLines) ) animated:NO];
        }else{
            [_mainContainer setContentOffset:CGPointMake(0, (numberOfOptions - 3) * heightOfOneLineInResponder + 2 * (heightOfOneLineInContainer + intervalBetweenLines) ) animated:NO];
        }
        
    }
    
    NSMutableArray *tempEachOptionSetIsDone = [NSMutableArray arrayWithArray:eachOptionSetIsDoneArray];
    [tempEachOptionSetIsDone addObject:[NSNumber numberWithBool:NO]];
    eachOptionSetIsDoneArray = [NSArray arrayWithArray:tempEachOptionSetIsDone];
    
    currentHeightOfCurrentResponder = (numberOfOptions + 1) * heightOfOneLineInResponder;
    
    //change the size of main container
    _mainContainer.contentSize = CGSizeMake(298, originalHeightOfMainContainerContentSize + currentHeightOfCurrentResponder );
    
     [currentTextfield becomeFirstResponder];
}

- (void)tapOnIndexOfOption:(UIButton *)sender
{
    [currentTextfield resignFirstResponder];
    for (int i = 0; i < numberOfOptions; i++) {
        
        if ([sender isEqual:_optionIndexArray[i]]) {
            if (_deleteOptionView) {
                
                if ([currentInputView isEqual:_optionInputViewArray[i]] ) {
                    //if the current delete view is being showed, then return to the input view
                    if ( currentInputView.isHidden) {
                        currentInputView.hidden = NO;
                        [_deleteOptionView removeFromSuperview];
                        return;
                    }else{
                        UIView *lastInputView = _optionInputViewArray[currentIndex];
                        lastInputView.hidden = NO;
                    }
                }
                
                
            }
            
            UIView *tempView = _optionInputViewArray[i];
            CGRect currentInputViewFrame = tempView.frame;
            
            _deleteOptionView = [[UIView alloc] init];
            _deleteOptionView.frame = currentInputViewFrame;
            [_thirdResponder addSubview:_deleteOptionView ];
            _deleteOptionView.hidden = NO;
            
            
            //"cancel" button
            _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _cancelButton.frame = CGRectMake(intervalOfButton, (heightOfOneLineInResponder - heightOfButton) / 2, widthOfButton , heightOfButton);
            [_cancelButton setImage:[UIImage imageNamed:blueButtonBackground] forState:UIControlStateNormal];
            [_cancelButton setImage:[UIImage imageNamed:blueButtonBackground] forState:UIControlStateHighlighted];
            [_cancelButton addTarget:self action:@selector(cancelButton:) forControlEvents:UIControlEventTouchDown];
            [_deleteOptionView addSubview:_cancelButton];
            
            UILabel *cancelLabel = [[UILabel alloc] init];
            cancelLabel.frame = CGRectMake(0, 0, widthOfButton, heightOfButton);
            cancelLabel.font = [UIFont systemFontOfSize:fontSizeOfInput];
            cancelLabel.textAlignment = UITextAlignmentCenter;
            cancelLabel.text = @"Cancel";
            cancelLabel.textColor = [UIColor whiteColor];
            [_cancelButton addSubview:cancelLabel];
            
            //"delete" button
            _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _deleteButton.frame = CGRectMake(intervalOfButton + leftMarginOfWords + widthOfButton, (heightOfOneLineInResponder - heightOfButton) / 2, widthOfButton , heightOfButton);
            [_deleteButton setImage:[UIImage imageNamed:redButtonBackground] forState:UIControlStateNormal];
            [_deleteButton setImage:[UIImage imageNamed:redButtonBackground] forState:UIControlStateHighlighted];
            [_deleteButton addTarget:self action:@selector(deleteButton:) forControlEvents:UIControlEventTouchDown];
            [_deleteOptionView addSubview:_deleteButton];
            
            UILabel *deleteLabel = [[UILabel alloc] init];
            deleteLabel.frame = CGRectMake(0, 0, widthOfButton, heightOfButton);
            deleteLabel.font = [UIFont systemFontOfSize:fontSizeOfInput];
            deleteLabel.textAlignment = UITextAlignmentCenter;
            deleteLabel.text = @"Delete";
            deleteLabel.textColor = [UIColor whiteColor];
            [_deleteButton addSubview:deleteLabel];
            
            //if tap the button that has just been taped
            
            
            currentInputView = _optionInputViewArray[i];
          //  currentDeleteView = _optionDeleteViewArray[i];
            
            currentInputView.hidden = YES;
          //  currentDeleteView.hidden = NO;
            currentIndex = i;
            
            }
    }

}

- (void)cancelButton:(UIButton *)sender
{
    
    [_deleteOptionView removeFromSuperview];
    currentInputView.hidden = NO;

}

- (void)deleteButton:(UIButton *)sender
{
 //   currentDeleteView.hidden = YES;
    [_deleteOptionView removeFromSuperview];
    currentInputView.hidden = NO;
    NSMutableArray *tempOptionTextfieldArray = [[NSMutableArray alloc] init];
    NSMutableArray *tempOptionInputArray = [[NSMutableArray alloc] init];
    NSMutableArray *tempOptionIndexArray = [[NSMutableArray alloc] init];
    UIView *tempView;
    
    if (numberOfOptions > 2) {
        
        for (int i = 0; i < currentIndex; i++) {
            [tempOptionTextfieldArray addObject:_optionTextfieldArray[i]];
            [tempOptionInputArray addObject:_optionInputViewArray[i]];
        }
        
        tempView = _optionInputViewArray[currentIndex];
        CGRect currentFrame, nextFrame;
        currentFrame = tempView.frame;
        [tempView removeFromSuperview];
        
        for (int i = currentIndex; i < (numberOfOptions -1) ; i++) {
            NSLog(@"%f %f", currentFrame.origin.y, nextFrame.origin.y);
            tempView = _optionInputViewArray[i+1];
            nextFrame = tempView.frame;
            tempView.frame = currentFrame;
            currentFrame = nextFrame;
            [tempOptionTextfieldArray addObject:_optionTextfieldArray[i+1]];
            [tempOptionInputArray addObject:_optionInputViewArray[i+1]];
        }

        
        for (int i = 0; i< numberOfOptions - 1; i++) {
            UITextField *try = tempOptionTextfieldArray[i]  ;
            NSLog(@"%@", try.text);
        }
        
        for (int i = 0; i < (numberOfOptions - 1); i++) {
            [tempOptionIndexArray  addObject:_optionIndexArray[i]];
        }
        
        numberOfOptions --;
        UIButton *tempIndexButton = _optionIndexArray[numberOfOptions];
        [tempIndexButton removeFromSuperview];
        
        _optionIndexArray = [[NSArray alloc] initWithArray:tempOptionIndexArray];
        _optionInputViewArray = [[NSArray alloc] initWithArray:tempOptionInputArray];
        _optionTextfieldArray = [[NSArray alloc] initWithArray:tempOptionTextfieldArray];
        
        [Animations doubleMoveUp:_fourthContainer anotherView:_addTipView  andAnimationDuration:1.0 andWait:YES andLength:heightOfOneLineInResponder];
        
        //modify the frame of third responder, third container, seconde container, main container
        CGRect tempFrame = _thirdResponder.frame;
        _thirdResponder.frame = CGRectMake(tempFrame.origin.x, tempFrame.origin.y, tempFrame.size.width, tempFrame.size.height - heightOfOneLineInResponder);
        
        tempFrame = _thirdContainer.frame;
        _thirdContainer.frame = CGRectMake(tempFrame.origin.x, tempFrame.origin.y, tempFrame.size.width, tempFrame.size.height - heightOfOneLineInResponder);
        
        tempFrame = _secondContainer.frame;
        _secondContainer.frame = CGRectMake(tempFrame.origin.x, tempFrame.origin.y, tempFrame.size.width, tempFrame.size.height);
        
        currentHeightOfCurrentResponder = _thirdResponder.frame.size.height;
        
        //change the size of main container
        _mainContainer.contentSize = CGSizeMake(298, originalHeightOfMainContainerContentSize + currentHeightOfCurrentResponder );
    }

}

- (void) addNumber:(UIButton *)sender
{
    numberOfPeople ++;
    _numberOfPeopleTextField.text = [NSString stringWithFormat:@"%d",numberOfPeople];
}

- (void) minusNumber:(UIButton *)sender
{
    numberOfPeople --;
    if (numberOfPeople < 0) {
        numberOfPeople = 0;
    }
    _numberOfPeopleTextField.text = [NSString stringWithFormat:@"%d",numberOfPeople];
}

- (void)keyboardWillShow:(NSNotification*)notification
{
    CGRect keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    _mainContainer.frame = CGRectMake(_mainContainer.frame.origin.x, _mainContainer.frame.origin.y, _mainContainer.frame.size.width, ScreenHeigh - _mainContainer.frame.origin.y - keyboardRect.size.height );
    
    _mainContainer.contentSize = CGSizeMake(298, originalHeightOfMainContainerContentSize + currentHeightOfCurrentResponder);
}

- (void)keyboardWillHide:(NSNotification*)notification
{
    _mainContainer.frame = CGRectMake(_mainContainer.frame.origin.x, _mainContainer.frame.origin.y, _mainContainer.frame.size.width, mainContainerHeight);
    _mainContainer.contentSize = CGSizeMake(298, originalHeightOfMainContainerContentSize + currentHeightOfCurrentResponder);
}

- (void)passwordConfirm:(UIButton *)sender
{
    passwordConfirmTimes++;
    
    if (passwordConfirmTimes == 1) {
        confirmedPassword = tempPassword;
        _passwordConfirmButton.hidden = YES;
        _passwordTip.text = @"Tip:Please enter again";
        _passwordTip.hidden = NO;
        [_passwordTextField setText:nil];
    }else{
        if (tempPassword == confirmedPassword) {
            _passwordTip.text = @"Your password is saved!";
            _passwordTip.hidden = NO;
            _passwordLineMarker.hidden = YES;
            _passwordTextField.hidden = YES;
            _passwordConfirmButton.hidden = YES;
            [Animations moveLeft:_passwordTip andAnimationDuration:1.0 andWait:YES andLength:widthOfPasswordTextField];
            _resetPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _resetPasswordButton.frame = CGRectMake(leftMarginOfWords + 180, 0, widthOfButton, heightOfButton);
            [_resetPasswordButton setImage:[UIImage imageNamed:blueButtonBackground] forState:UIControlStateNormal];
            [_resetPasswordButton setImage:[UIImage imageNamed:blueButtonBackground] forState:UIControlStateHighlighted];
            [_resetPasswordButton addTarget:self action:@selector(resetPassword:) forControlEvents:UIControlEventTouchDown];
            [_fifthResponder addSubview:_resetPasswordButton];
            
            UILabel *resetLabel = [[UILabel alloc] init];
            resetLabel.frame = CGRectMake(0, 0, widthOfButton, heightOfButton);
            resetLabel.textColor = [UIColor whiteColor];
            resetLabel.textAlignment = UITextAlignmentCenter;
            resetLabel.text = @"reset";
            [_resetPasswordButton addSubview:resetLabel];
        }else{
            passwordConfirmTimes = 0;
            _passwordTip.text = @"Don't match. Start over!";
            _passwordTip.hidden = NO;
            _passwordConfirmButton.hidden = YES;
            [_passwordTextField setText:nil];
        }
    }
}

- (void)resetPassword:(UIButton *)sender
{
    passwordConfirmTimes = 0;
    [_resetPasswordButton removeFromSuperview];
    _passwordTip.text = @"Tip: Need Six Numbers";
    [Animations moveRight:_passwordTip andAnimationDuration:1.0 andWait:YES andLength:widthOfPasswordTextField];
    [_passwordTextField setText:nil];
    _passwordLineMarker.hidden = NO;
    _passwordTextField.hidden = NO;
    
}

- (void)choiceTime:(UIButton *)sender
{
    if (currentSelectedTimeButton) {
        [currentSelectedTimeButton setImage:[UIImage imageNamed:blueButtonBackground] forState:UIControlStateNormal];
    }
    [sender setImage:[UIImage imageNamed:redButtonBackground] forState:UIControlStateNormal];
    currentSelectedTimeButton = sender;
    [self calculateStepsHaveBeenFinished];
    if (stepsHasBeenFinished == 6) {
        _doneButton.hidden = NO;
        [_mainContainer setContentOffset:CGPointMake(0,  heightOfOneLineInContainer + intervalBetweenLines ) animated:YES];
        _mainContainer.contentSize = CGSizeMake(298, originalHeightOfMainContainerContentSize + currentHeightOfCurrentResponder + heightOfOneLineInResponder + intervalBetweenLines);
    }
    
}


- (void)isOptionPartDone
{
    optionSetIsDone = YES;
    for (int i = 0; i < numberOfOptions; i++) {
        UITextField *tempTextField = _optionTextfieldArray[i];
        if ([tempTextField.text isEqualToString:@""]) {
            optionSetIsDone = NO;
        }
    }
}

- (BOOL)isCurrentTaskDone{
    
    if ([currentRunningResponder isEqual:_theFirstResponder]) {
        
        colorChoiceIsDone = YES;
        return colorChoiceIsDone;
        
    } else if([currentRunningResponder isEqual:_secondResponder]){
        subjectSetIsDone = YES;
        
        if (_subjectTextView.text == nil || [_subjectTextView.text isEqualToString:@""])
        {
            subjectSetIsDone = NO;
        }
        return subjectSetIsDone;
        
    }else if ([currentRunningResponder isEqual:_thirdResponder]){
        optionSetIsDone = YES;
        for (int i = 0; i < numberOfOptions; i++) {
            UITextField *tempTextField = _optionTextfieldArray[i];
            if (tempTextField.text == nil || [tempTextField.text isEqualToString:@""]) {
                optionSetIsDone = NO;
            }
        }
        return optionSetIsDone;
        
    }else if ([currentRunningResponder isEqual:_fourthResponder]){
        numberSetIsDone = YES;
        if (_numberOfPeopleTextField.text == nil || [_numberOfPeopleTextField.text isEqualToString:@""]) {
            numberSetIsDone = NO;
        }
        return numberSetIsDone;
        
    }else if ([currentRunningResponder isEqual:_fifthResponder]){
        if ([_passwordTip.text isEqualToString:@"Your password is saved!"]) {
            passwordSetIsDone = YES;
        }
        return passwordSetIsDone;
        
    }else if ([currentRunningResponder isEqual:_sixthResponder]){
        timeSetIsDone = YES;
        return timeSetIsDone;
        
    }else{
        return NO;
    }
}

- (void)calculateStepsHaveBeenFinished
{
    stepsHasBeenFinished = 0;
    
    if (colorChoiceIsDone) {
        stepsHasBeenFinished++;
    }
    
    if (subjectSetIsDone) {
        stepsHasBeenFinished++;
    }
    
    if (optionSetIsDone) {
        stepsHasBeenFinished++;
    }
    
    if (numberSetIsDone) {
        stepsHasBeenFinished++;
    }
    
    if (passwordSetIsDone) {
        stepsHasBeenFinished++;
    }
    
    if (timeSetIsDone) {
        stepsHasBeenFinished++;
    }

}

- (void)doneWithAllSteps:(UIButton *)sender
{
    //prepare data
    //get current location and prepare the data
    CLLocationCoordinate2D location = _locationManager.location.coordinate;
    
    NSMutableDictionary *dic = [NSMutableDictionary getRequestDicWithRequestType:InitialVote];
    [dic setObject:_subjectTextView.text forKey:@"title"];
    [dic setObject:[NSNumber numberWithInteger:[_numberOfPeopleTextField.text intValue]] forKey:@"maxvaliduser"];
    [dic setObject:_passwordTextField.text forKey:@"password"];
    //TODO:need end time
    [dic setObject:[NSNumber numberWithInt:5] forKey:@"endtime"];
    [dic setObject:[NSNumber numberWithInt:[[[NSUserDefaults standardUserDefaults] valueForKey:@"userid"] integerValue]] forKey:@"userid"];
    [dic setObject:[NSNumber numberWithInt:selectedColorIndex] forKey:@"color"];
    [dic setObject:[NSNumber numberWithDouble:location.longitude] forKey:@"longitude"];
    [dic setObject:[NSNumber numberWithDouble:location.latitude] forKey:@"latitude"];
    
    //add options
    NSMutableArray *optionArray = [NSMutableArray arrayWithCapacity:3];
    for (UITextField *textField in _optionTextfieldArray) {
        [optionArray addObject:textField.text];
    }
    
    [dic setObject:optionArray forKey:@"contents"];
    
    //NSLog(@"%@",[dic description]);
    
    [[PLServer shareInstance] sendDataWithDic:dic];
}

- (void)doneWithNumberPad
{
    [currentTextfield resignFirstResponder];
}

#pragma mark - PLServer delegate
- (void)plServer:(PLServer *)plServer didReceivedJSONString:(id)jsonString
{
    [self dismissLoadingView];
    
    NSDictionary *cacheDic = (NSDictionary*)jsonString;
    BOOL result = [[cacheDic valueForKey:@"success"] boolValue];
    if (result) {
        //check if is the refresh by location
        VoteRequestType requetType = [cacheDic getRequestType];
        
        switch (requetType) {
            case SearchVote:{
                
                break;
            }
                
            default:
                break;
        }
        
    }else{
        [self showErrorMessage:[cacheDic valueForKey:@"msg"]];
    }
}

- (void)plServer:(PLServer *)plServer failedWithError:(NSError *)error
{
    [self dismissLoadingView];
    if (error) {
        [self showErrorMessage:[error description]];
    }else{
        [self showErrorMessage:@"We're experiencing some technique problems, please try again later."];
    }
}

- (void)connectionClosed:(PLServer *)plServer
{
    if (isShowingLoadingView) {
        [self dismissLoadingView];
        [self showErrorMessage:@"Lost connection,check your internet connection."];
    }
}

@end
