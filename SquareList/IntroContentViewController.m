//
//  IntroContentViewController.m
//  Do.
//
//  Created by Skylar Peterson on 2/18/14.
//  Copyright (c) 2014 Class Apps. All rights reserved.
//

#import "IntroContentViewController.h"
#import "Fonts.h"
#import "Colors.h"

@interface IntroContentViewController ()

@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UILabel *mainLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondaryLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation IntroContentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mainLabel.font = [Fonts mainTitleFont];
    self.secondaryLabel.font = [Fonts bodyTextFont];
    
    self.imageView.image = [UIImage imageNamed:self.imageFile];
    self.mainLabel.text = self.mainTitleText;
    self.secondaryLabel.text = self.secondaryText;
    
    [self.closeButton setBackgroundImage:[[UIImage imageNamed:@"CloseIcon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
