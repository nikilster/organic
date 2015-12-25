//
//  ViewController.m
//  Organic
//
//  Created by Nikil Viswanathan on 12/24/15.
//  Copyright © 2015 Nikil Viswanathan. All rights reserved.
//

#import "ViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface ViewController ()

@property (nonatomic, strong) UIView *overlay;
@property (nonatomic, strong) UIButton *scanButton;
@property (nonatomic, strong) UIView *scanningVisualizationView;
@property (nonatomic, strong) UIView *resultView;

@end

@implementation ViewController
SystemSoundID scanSound;

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self showCamera];
}

- (void)showCamera
{
    NSLog(@"Showing Camera");
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker = [[UIImagePickerController alloc] init];
    //picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.modalPresentationStyle = UIModalPresentationCurrentContext;
    picker.allowsEditing = NO;
    picker.showsCameraControls = NO;
    picker.navigationBarHidden = YES;
    
    
    // Fill the whole screen
    // http://stackoverflow.com/a/20228332/431387
    CGSize screenBounds = [UIScreen mainScreen].bounds.size;
    CGFloat cameraAspectRatio = 4.0f/3.0f;
    CGFloat camViewHeight = screenBounds.width * cameraAspectRatio;
    CGFloat scale = screenBounds.height / camViewHeight;
    picker.cameraViewTransform = CGAffineTransformMakeTranslation(0, (screenBounds.height - camViewHeight) / 2.0);
    picker.cameraViewTransform = CGAffineTransformScale(picker.cameraViewTransform, scale, scale);
    
    //Set the overlay
    [self setupOverlay:picker];
    
    //Show the view controller
    [self presentViewController:picker animated:NO completion:NULL];
}

- (void)setupOverlay:(UIImagePickerController *)picker
{
    // Setup the overlay
    self.overlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];

    //Add a button to start the scan
    self.scanButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.scanButton.frame = CGRectMake((self.view.frame.size.width-185)/2, self.view.frame.size.height-100, 185, 41); // Image is 75x75, we want it centered on the screen
    [self.scanButton setBackgroundImage:[UIImage imageNamed:@"Scan.png"] forState:UIControlStateNormal];
    [self.scanButton addTarget:self action:@selector(scanButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

    [self.overlay addSubview:self.scanButton];
    
    picker.cameraOverlayView = self.overlay;
}


- (void)scanButtonClicked:(id)sender
{
    // Disable Button
    self.scanButton.hidden = YES;
    
    self.scanningVisualizationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    //Organic Image
    UIImageView *greenLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"green line"]];
    greenLine.frame = CGRectMake(0, 0, 320, 4);
    [self.scanningVisualizationView  addSubview:greenLine];
    [self.overlay addSubview:self.scanningVisualizationView];
    

    // Show the scanning visualization
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse|UIViewAnimationOptionCurveEaseInOut animations:^{
        
        // Move down
        greenLine.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, 320, 4);
        
    } completion:^(BOOL finished) {
        
    }];
    
    // After 5 seconds
    #define SCAN_TIME 3
    if(randomBool())
        [self performSelector:@selector(scanResultOrganic) withObject:nil afterDelay:SCAN_TIME];
    else
        [self performSelector:@selector(scanResultNotOrganic) withObject:nil afterDelay:SCAN_TIME];

    // Play Sound
    NSString *scanSoundPath = [[NSBundle mainBundle]
                            pathForResource:@"scansound" ofType:@"wav"];
    NSURL *scanSoundURL = [NSURL fileURLWithPath:scanSoundPath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)scanSoundURL, &scanSound);
    AudioServicesPlaySystemSound(scanSound);
}


/* Return a random integer number between low and high inclusive */
int randomInt(int low, int high)
{
    return (arc4random() % (high-low+1)) + low;
}

/* Return a random BOOL value */
BOOL randomBool()
{
    return (BOOL)randomInt(0, 1);
}

- (void)scanResultOrganic
{
    // Remove scanning visualization
    [self.scanningVisualizationView removeFromSuperview];
    
    self.resultView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    //Organic Image
    UIImageView *organicView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"organic.png"]];
    organicView.frame = CGRectMake(65, 142, 191, 192);
    [self.resultView  addSubview:organicView];
    
    //Party Right
    UIImageView *partyRight = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"party right.png"]];
    partyRight.frame = CGRectMake(224, 26, 83, 80);
    [self.resultView  addSubview:partyRight];

    //Hands Up
    UIImageView *handsUp = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hands up.png"]];
    handsUp.frame = CGRectMake(109, 6, 103, 101);
    [self.resultView  addSubview:handsUp];

    //Party Left
    UIImageView *partyLeft = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"party left.png"]];
    partyLeft.frame = CGRectMake(18, 26, 83, 80);
    [self.resultView  addSubview:partyLeft];

    //Smiley
    UIImageView *smiley = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"smiley.png"]];
    smiley.frame = CGRectMake(18, 359, 90, 91);
    [self.resultView  addSubview:smiley];
    
    //Smiley Teeth
    UIImageView *smileyTeeth = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"smiley teeth.png"]];
    smileyTeeth.frame = CGRectMake(220, 359, 91, 92);
    [self.resultView  addSubview:smileyTeeth];

    
    //Scan Another Button
    UIButton *scanAnotherButton = [UIButton buttonWithType:UIButtonTypeSystem];
    scanAnotherButton.frame = CGRectMake((self.view.frame.size.width-185)/2, self.view.frame.size.height-100, 185, 41);
    [scanAnotherButton setBackgroundImage:[UIImage imageNamed:@"Scan Another.png"] forState:UIControlStateNormal];
    [scanAnotherButton addTarget:self action:@selector(resetState:) forControlEvents:UIControlEventTouchUpInside];
    [self.resultView addSubview:scanAnotherButton];
    
    // Display the overlay
    [self.overlay addSubview:self.resultView];
    
}


- (void)scanResultNotOrganic
{
    // Remove scanning visualization
    [self.scanningVisualizationView removeFromSuperview];
    
    self.resultView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    //Smiley surprised
    UIImageView *smileySurprised = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"smiley surprised.png"]];
    smileySurprised.frame = CGRectMake(82, 127, 145, 146);
    [self.resultView  addSubview:smileySurprised];
    
    //Not Organic
    UIImageView *notOrganic = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Not Organic.png"]];
    notOrganic.frame = CGRectMake(71, 329, 176, 31);
    [self.resultView  addSubview:notOrganic];
    
    
    //Scan Another Button
    UIButton *scanAnotherButton = [UIButton buttonWithType:UIButtonTypeSystem];
    scanAnotherButton.frame = CGRectMake((self.view.frame.size.width-185)/2, self.view.frame.size.height-100, 185, 41);
    [scanAnotherButton setBackgroundImage:[UIImage imageNamed:@"Scan Another.png"] forState:UIControlStateNormal];
    [scanAnotherButton addTarget:self action:@selector(resetState:) forControlEvents:UIControlEventTouchUpInside];
    [self.resultView addSubview:scanAnotherButton];
    
    // Display the overlay
    [self.overlay addSubview:self.resultView];
    
}


// Let them scan again!
- (void)resetState:(id)sender
{

    // Dispose of the sound
    AudioServicesDisposeSystemSoundID(scanSound);

    [self.resultView removeFromSuperview];
    
    self.scanButton.hidden = NO;
}
@end
