//
//  ViewController.h
//  initiateVotes
//
//  Created by Shine Zhao on 11/18/13.
//  Copyright (c) 2013 Shine Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Animations.h"

@interface InitializeVoteViewController : UIViewController<UITextViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *arrowRect;

//@property (weak, nonatomic) IBOutlet UIScrollView *mainContainer;//width:298

@property (strong, nonatomic) UIScrollView *mainContainer;

//containers
@property (strong, nonatomic) UIView *firstContainer;
@property (strong, nonatomic) UIView *secondContainer;
@property (strong, nonatomic) UIView *thirdContainer;
@property (strong, nonatomic) UIView *fourthContainer;
@property (strong, nonatomic) UIView *fifthContainer;
@property (strong, nonatomic) UIView *sixthContainer;

//arrow image
@property (strong, nonatomic) UIImageView *arrow;
@property (strong, nonatomic) UIImageView *solidArrowImageView;

//about theme color
@property (strong, nonatomic) UIImageView *themeColorIcon;
@property (strong, nonatomic) UILabel *themeColorLabel;

//about subject
@property (strong, nonatomic) UIImageView *subjectIcon;
@property (strong, nonatomic) UILabel *subjectLabel;

//about options
@property (strong, nonatomic) UIImageView *optionIcon;
@property (strong, nonatomic) UILabel *optionLabel;

//numbers of participants
@property (strong, nonatomic) UIImageView *numbersIcon;
@property (strong, nonatomic) UILabel *numbersLabel;

//about password
@property (strong, nonatomic) UIImageView *passwordIcon;
@property (strong, nonatomic) UILabel *passwordLabel;

//about time limit
@property (strong, nonatomic) UIImageView *timeIcon;
@property (strong, nonatomic) UILabel *timeLabel;


//first responder color choice
@property (strong, nonatomic) UIView *theFirstResponder;
@property (strong, nonatomic) UIButton *greenChoiceButton;
@property (strong, nonatomic) UIButton *blueChoiceButton;
@property (strong, nonatomic) UIButton *yellowChoiceButton;
@property (strong, nonatomic) UIButton *redChoiceButton;
@property (strong, nonatomic) UIButton *blackChoiceButton;
//tap choice theme recognizer
@property (strong, nonatomic) UITapGestureRecognizer *tapColorChoiceRecognizer;

//second responder subject
@property (strong, nonatomic) UIView *secondResponder;
@property (strong, nonatomic) UITextView *subjectTextView;
@property (strong, nonatomic) UIImageView *lineMarkerImageView;
//tap subject part recognizer
@property (strong, nonatomic) UITapGestureRecognizer *tapSubjectRecognizer;

//third responder
@property (strong, nonatomic) UIView *thirdResponder;
@property (strong, nonatomic) NSArray *optionIndexArray; 
@property (strong, nonatomic) NSArray *optionTextfieldArray;
@property (strong, nonatomic) NSArray *optionInputViewArray;
@property (strong, nonatomic) UIView *deleteOptionView;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIButton *deleteButton;
@property (strong, nonatomic) UIView *addTipView;
@property (strong, nonatomic) UIButton *addIconButton;
@property (strong, nonatomic) UIButton *addTipButton;
@property (strong, nonatomic) UITapGestureRecognizer *tapOptionGestureRecognizer;

//fourth responder
@property (strong, nonatomic) UIView *fourthResponder;
@property (strong, nonatomic) UITextField *numberOfPeopleTextField;
@property (strong, nonatomic) UITapGestureRecognizer *tapNumberGestureRecognizer;

//fifth responder
@property (strong, nonatomic) UIView *fifthResponder;
@property (strong, nonatomic) UITextField *passwordTextField;
@property (strong, nonatomic) UILabel *passwordTip;
@property (strong, nonatomic) UIImageView *passwordLineMarker;
@property (strong, nonatomic) UIButton *passwordConfirmButton;
@property (strong, nonatomic) UITapGestureRecognizer *tapPasswordGestureRecognizer;
@property (strong, nonatomic) UIButton *resetPasswordButton;


//sixth respoder
@property (strong, nonatomic) UIView *sixthResponder;
@property (strong, nonatomic) UIButton *firstTimeButton;
@property (strong, nonatomic) UIButton *secondTimeButton;
@property (strong, nonatomic) UIButton *thirdTimeButton;
@property (strong, nonatomic) UIButton *fourthTimeButton;
@property (strong, nonatomic) UITapGestureRecognizer *tapTimeGestureRecoginizer;

//Done
@property (strong, nonatomic) UIButton *doneButton;
@end
