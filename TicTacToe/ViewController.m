#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelOne;
@property (weak, nonatomic) IBOutlet UILabel *labelTwo;
@property (weak, nonatomic) IBOutlet UILabel *labelThree;
@property (weak, nonatomic) IBOutlet UILabel *labelFour;
@property (weak, nonatomic) IBOutlet UILabel *labelFive;
@property (weak, nonatomic) IBOutlet UILabel *labelSix;
@property (weak, nonatomic) IBOutlet UILabel *labelSeven;
@property (weak, nonatomic) IBOutlet UILabel *labelEight;
@property (weak, nonatomic) IBOutlet UILabel *labelNine;
@property (weak, nonatomic) IBOutlet UILabel *whichPlayerName;
@property NSDictionary *labelsDictionary;
@property (weak, nonatomic) IBOutlet UILabel *labelX;
@property (weak, nonatomic) IBOutlet UILabel *labelO;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property CGPoint originalCenter;
@property (nonatomic, retain) NSTimer *ticTacTimer;
@property int time;
@property (weak, nonatomic) IBOutlet UILabel *secondsLeft;
@end

@implementation ViewController

- (void)loadDictionary {
    self.labelsDictionary = @{
                              @"1" : self.labelOne,
                              @"2" : self.labelTwo,
                              @"3" : self.labelThree,
                              @"4" : self.labelFour,
                              @"5" : self.labelFive,
                              @"6" : self.labelSix,
                              @"7" : self.labelSeven,
                              @"8" : self.labelEight,
                              @"9" : self.labelNine,
                              };
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.whichPlayerName.text = @"X";
    self.labelO.alpha = 0;
    [self loadDictionary];
    self.originalCenter = CGPointMake(160, 450);
    [self startTimer];
}

- (void) resetTimer{
    [self.ticTacTimer invalidate];
    [self startTimer];
}
- (void) startTimer{
    self.time = 10;
    self.secondsLeft.text = [NSString stringWithFormat:@"%d", self.time];
    self.ticTacTimer =[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
}

- (void) countDown{
    self.time -= 1;
    self.secondsLeft.text = [NSString stringWithFormat:@"%d", self.time];
    if (self.time == 0) {
        [self.ticTacTimer invalidate];
        [self startTimer];
        [self setNextPlayersTurn];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(UILabel*) findLabelUsingPoint: (CGPoint )point{
    UILabel *tapped;
    for (int i = 1; i<10; i++) {
        NSString *keyLabel =[NSString stringWithFormat:@"%d",i];
        UILabel *labelFromDictionary = self.labelsDictionary[keyLabel];
        if ( CGRectContainsPoint(labelFromDictionary.frame, point)) {
            return labelFromDictionary;
        }
    }
    return tapped;
}
- (IBAction)onLabelTapped:(UITapGestureRecognizer *)tapGesture {
        CGPoint labelPoint = [tapGesture locationInView:self.view];
        [self updateTappedLabel:[self findLabelUsingPoint:labelPoint]];
        [self setNextPlayersTurn];
    NSString *winner =[self whoWon];
    if (![winner isEqualToString:@"#"]) {
        [self showWinner:winner];
    }
}

-(void) showWinner: (NSString*) winner{
    UIAlertView *alertView =[[UIAlertView alloc] init];
    alertView.title = @"The winner is...";
    alertView.message=winner;
    [alertView addButtonWithTitle:@"OK"];
    [alertView show];
}

- (void)setNextPlayersTurn {
    if ([self.whichPlayerName.text isEqualToString:@"X"]) {
        self.whichPlayerName.text = @"O";
        self.labelO.alpha=1.0;
        self.labelX.alpha=0;
        [self computersMove];
        [self setNextPlayersTurn];
    }else{
        self.whichPlayerName.text = @"X";
        self.labelO.alpha=0;
        self.labelX.alpha=1.0;
    }
}

-(void) computersMove{
    for (int i = 1; i<10; i++) {
        int index = 1+ arc4random_uniform(9);
        NSString *keyLabel =[NSString stringWithFormat:@"%d",index];
        UILabel *labelFromDictionary = self.labelsDictionary[keyLabel];
        if ([labelFromDictionary.text isEqualToString:@"#"]) {
            [self updateTappedLabel:labelFromDictionary];
            return;
        }
    }
}

- (BOOL)isXPlayerTurn {
    return [self.whichPlayerName.text isEqualToString:@"X"];
}

- (void)updateTappedLabel:(UILabel *)sender {
    BOOL isXTurn = [self isXPlayerTurn];
    if (isXTurn) {
        sender.text = @"X";
        sender.textColor = [UIColor blueColor];
    }else{
        sender.text = @"O";
        sender.textColor = [UIColor redColor];
    }
}
-(NSString*) isLineCompleted:(int)index :(int)increment{
            NSString *firstIndex =[NSString stringWithFormat:@"%d",index];
            NSString *secondIndex =[NSString stringWithFormat:@"%d",index+(1*increment)];
            NSString *thirdIndex =[NSString stringWithFormat:@"%d",index+(2*increment)];
            UILabel *firstLabel = self.labelsDictionary[firstIndex];
            UILabel *secondLabel = self.labelsDictionary[secondIndex];
            UILabel *thirdLabel = self.labelsDictionary[thirdIndex];
    if ([firstLabel.text isEqualToString: secondLabel.text] && [firstLabel.text isEqualToString: thirdLabel.text] &&![firstLabel.text isEqualToString: @"#"] ) {
        return firstLabel.text;
    }
    return @"#";
}

-(NSString*) whoWon{
    for (int i =1; i<8; i=i+3) {
        NSString *winner =[self isLineCompleted:i :1] ;
        if (![winner isEqualToString:@"#"]) {
            return winner;
        }
    }
    
    for (int i =1; i<4; i++) {
        NSString *winner =[self isLineCompleted:i :3] ;
        if (![winner isEqualToString:@"#"]) {
            return winner;
        }
    }
    
    NSString *winner =[self isLineCompleted:1 :4] ;
    if (![winner isEqualToString:@"#"]) {
        return winner;
    }
    
    winner =[self isLineCompleted:3 :2] ;
    if (![winner isEqualToString:@"#"]) {
        return winner;
    }
    return @"#";
}

- (void)completeTheMove:(UILabel *)backLabel {
    [self updateTappedLabel:backLabel];
    [self setNextPlayersTurn];
    NSString *winner =[self whoWon];
    if (![winner isEqualToString:@"#"]) {
        [self showWinner:winner];
    }
}

- (CGPoint)draginTheLabel:(UIPanGestureRecognizer *)panGesture {
    CGPoint point= [panGesture locationInView:self.view];
    if ([self isXPlayerTurn]) {
        self.labelX.center=point;
    }else{
        self.labelO.center = point;
    }
    return point;
}

- (IBAction)onDrag:(UIPanGestureRecognizer *)panGesture{
    if (panGesture.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:1.0 animations:^{
            //[self.ticTacTimer invalidate];
            self.labelX.center=self.originalCenter;
            self.labelO.center = self.originalCenter;
            [self resetTimer];
        }];
    }else {
        CGPoint point;
        point = [self draginTheLabel:panGesture];
        UILabel* backLabel = [self findLabelUsingPoint:point];
        if (backLabel != nil && [backLabel.text isEqualToString:@"#"]) {
            [self completeTheMove:backLabel];
        }
    }
}

@end
