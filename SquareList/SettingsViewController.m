//
//  SettingsViewController.m
//  SquareList
//
//  Created by Skylar Peterson on 11/28/13.
//  Copyright (c) 2013 Class Apps. All rights reserved.
//

#import "SettingsViewController.h"
#import <Twitter/Twitter.h>
#import <MessageUI/MessageUI.h>

#import "ColorPaletteView.h"
#import "ColorSelectionView.h"

#import "Colors.h"
#import "Fonts.h"

@interface SettingsViewController () <UIAlertViewDelegate, MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *settingsLabel;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *mainColorControl;
@property (weak, nonatomic) IBOutlet UIImageView *cloudImage;
@property (weak, nonatomic) IBOutlet UILabel *cloudLabel;
//@property (weak, nonatomic) IBOutlet UIImageView *soundImage;
//@property (weak, nonatomic) IBOutlet UILabel *soundLabel;
@property (weak, nonatomic) IBOutlet UIImageView *badgeImage;
@property (weak, nonatomic) IBOutlet UILabel *badgeLabel;
@property (weak, nonatomic) IBOutlet UILabel *colorPaletteLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentPaletteLabel;
@property (weak, nonatomic) IBOutlet UIButton *paletteButton;
@property (weak, nonatomic) IBOutlet UISwitch *badgeSwitcher;
@property (weak, nonatomic) IBOutlet UIButton *tutorialButton;
@property (weak, nonatomic) IBOutlet UIButton *contactButton;

@property (nonatomic) BOOL oniPad;
@end

#define SHOW_BADGE_KEY @"ShowBadgeIcon"

@implementation SettingsViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    if (self.oniPad) return UIStatusBarStyleDefault;
    if ([[Colors backdropColor] isEqual:[UIColor blackColor]]) {
        return UIStatusBarStyleLightContent;
    } else {
        return UIStatusBarStyleDefault;
    }
}

- (void)updatePaletteButton
{
    self.currentPaletteLabel.text = [Colors currentPaletteName];
    ColorPaletteView *paletteView = [[ColorPaletteView alloc] initWithFrame:self.paletteButton.frame];
    paletteView.colors = [Colors currentPalette];
    [self.paletteButton setBackgroundImage:[paletteView imageFromView] forState:UIControlStateNormal];
    [self.delegate paletteChanged];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	[self.closeButton setBackgroundImage:[[UIImage imageNamed:@"CloseIcon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [self.tutorialButton setBackgroundImage:[ColorSelectionView imageWithColor:[Colors mainInteractiveColor]] forState:UIControlStateNormal];
    [self.contactButton setBackgroundImage:[ColorSelectionView imageWithColor:[Colors mainInteractiveColor]] forState:UIControlStateNormal];
    
    if ([[Colors backdropColor] isEqual:[UIColor whiteColor]]) {
        self.mainColorControl.selectedSegmentIndex = 0;
    } else {
        self.mainColorControl.selectedSegmentIndex = 1;
    }
    [self.mainColorControl addTarget:self
                              action:@selector(changeGlobalColor)
                    forControlEvents:UIControlEventValueChanged];
    
    self.settingsLabel.font = [Fonts mainTitleFont];
    [self.mainColorControl setTitleTextAttributes:@{ NSFontAttributeName : [Fonts subBodyTextFont] }
                                         forState:UIControlStateNormal];
    //self.cloudLabel.font = [Fonts bodyTextFont];
    //self.soundLabel.font = [Fonts bodyTextFont];
    //self.badgeLabel.font = [Fonts bodyTextFont];
    self.cloudLabel.font = [Fonts settingsFont];
    self.badgeLabel.font = [Fonts settingsFont];
    self.colorPaletteLabel.font = [Fonts boldBodyTextFont];
    self.currentPaletteLabel.font = [Fonts bodyTextFont];
    
    self.tutorialButton.titleLabel.font = [Fonts subTitleFont];
    [self.tutorialButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.contactButton.titleLabel.font = [Fonts subTitleFont];
    [self.contactButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.oniPad = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad);
    if (self.oniPad) {
        self.paletteButton.layer.borderColor = [[UIColor blackColor] CGColor];
    } else {
        [self adaptToColors];
        self.paletteButton.layer.borderColor = [[Colors oppositeBackdropColor] CGColor];
    }
    self.paletteButton.layer.borderWidth = 0.5f;
    [self updatePaletteButton];
    
    NSNumber *badgeNum = [[NSUserDefaults standardUserDefaults] objectForKey:SHOW_BADGE_KEY];
    self.badgeSwitcher.on = badgeNum.boolValue;
    [self.badgeSwitcher addTarget:self action:@selector(badgeSwitched:) forControlEvents:UIControlEventValueChanged];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self updatePaletteButton];
}

- (void)changeGlobalColor
{
    [Colors switchBackdropColor];
    [UIView transitionWithView:self.view
                      duration:0.35
                       options:UIViewAnimationOptionCurveEaseInOut
                    animations:^{
                        if(!self.oniPad) [self adaptToColors];
                        [self.delegate backdropColorChanged];
                    }
                    completion:^(BOOL finished){
                        [self setNeedsStatusBarAppearanceUpdate];
                    }];
}

- (void)adaptToColors
{
    self.view.backgroundColor = [Colors backdropColor];
    
    if ([[Colors oppositeBackdropColor] isEqual:[UIColor blackColor]]) {
        self.cloudImage.image = [UIImage imageNamed:@"BlackCloud.png"];
        //self.soundImage.image = [UIImage imageNamed:@"BlackSound.png"];
        self.badgeImage.image = [UIImage imageNamed:@"BlackBadge.png"];
    } else {
        self.cloudImage.image = [UIImage imageNamed:@"WhiteCloud.png"];
        //self.soundImage.image = [UIImage imageNamed:@"WhiteSound.png"];
        self.badgeImage.image = [UIImage imageNamed:@"WhiteBadge.png"];
    }
    
    self.settingsLabel.textColor = [Colors oppositeBackdropColor];
    self.cloudLabel.textColor = [Colors oppositeBackdropColor];
    //self.soundLabel.textColor = [Colors oppositeBackdropColor];
    self.badgeLabel.textColor = [Colors oppositeBackdropColor];
    self.colorPaletteLabel.textColor = [Colors oppositeBackdropColor];
    self.currentPaletteLabel.textColor = [Colors oppositeBackdropColor];
    self.paletteButton.layer.borderColor = [[Colors oppositeBackdropColor] CGColor];
}

- (void)badgeSwitched:(UISwitch *)badgeSwitch
{
    if (badgeSwitch.on) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:SHOW_BADGE_KEY];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:SHOW_BADGE_KEY];
    }
}

- (IBAction)dismissPaletteChooser:(UIStoryboardSegue *)segue
{
    [self updatePaletteButton];
}

- (IBAction)contactTapped:(id)sender
{
    [self alert:nil];
}

#pragma mark - Alert Methods

- (void)alert:(NSString *)msg
{
    [[[UIAlertView alloc] initWithTitle:@"Contact Information"
                                message:msg
                               delegate:self
                      cancelButtonTitle:@"Cancel"
                      otherButtonTitles:@"Tweet at @DoForiOS", @"Email doforios@gmail.com", nil] show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:@"@DoForiOS "];
        [self presentViewController:tweetSheet animated:NO completion:nil];
    } else if (buttonIndex == 2) {
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
        mailController.mailComposeDelegate = self;
        [mailController setSubject:@"Feedback for Do."];
        [mailController setToRecipients:@[@"doforios@gmail.com"]];
        [self presentViewController:mailController animated:YES completion:nil];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
