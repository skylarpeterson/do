//
//  IntroViewController.m
//  Do.
//
//  Created by Skylar Peterson on 2/18/14.
//  Copyright (c) 2014 Class Apps. All rights reserved.
//

#import "IntroViewController.h"
#import "IntroContentViewController.h"
#import "ColorSelectionView.h"

#import "Fonts.h"
#import "Colors.h"

@interface IntroViewController () <UIPageViewControllerDataSource>

@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (weak, nonatomic) IBOutlet UIButton *getStartedButton;

@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSArray *mainTitles;
@property (nonatomic, strong) NSArray *secondaryText;
@property (nonatomic, strong) NSArray *imageFiles;

@end

@implementation IntroViewController

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
    
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [Colors mainInteractiveColor];
    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    pageControl.backgroundColor = [UIColor whiteColor];
    
    self.mainTitles = @[@"All your lists.",
                        @"Main buttons.",
                        @"Edit a list.",
                        @"Enter a list.",
                        @"Manipulate tasks.",
                        @"Color Palettes."];
    
    self.secondaryText = @[@"The app's main page displays all your lists in a grid of colored squares.",
                           @"Tap the plus to add a new list. Tap the gear to bring up app settings.",
                           @"Hold your finger on a list to edit its settings, like text color or list title.",
                           @"Tap on a list to enter it and view its tasks. Tap the plus to add a task, or the 'X' to exit.",
                           @"Tap a task's box to 'complete' it, or the camera icon to add photos. Drag left to delete it.",
                           @"In settings, change the color palette for your lists to give them a new look and feel."];
    
    self.imageFiles = @[@"Page1",
                        @"Page2",
                        @"Page3",
                        @"Page4",
                        @"Page5",
                        @"Page6"];
    
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    
    IntroContentViewController *startingController = [self viewControllerAtIndex:0];
    [self.pageViewController setViewControllers:@[startingController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    
    self.welcomeLabel.font = [Fonts introTitleFont];
    self.welcomeLabel.textColor = [Colors mainInteractiveColor];
    self.getStartedButton.titleLabel.font = [Fonts subTitleFont];
    [self.getStartedButton setBackgroundImage:[ColorSelectionView imageWithColor:[Colors mainInteractiveColor]] forState:UIControlStateNormal];
    [self.closeButton setBackgroundImage:[[UIImage imageNamed:@"CloseIcon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[UIPageViewController class]]) {
        UIPageViewController *pageController = (UIPageViewController *)segue.destinationViewController;
        pageController.view.backgroundColor = [UIColor whiteColor];
        pageController.dataSource = self;
        IntroContentViewController *startingController = [self viewControllerAtIndex:0];
        [pageController setViewControllers:@[startingController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index = ((IntroContentViewController *) viewController).pageIndex;
    if (index == 0 || index == NSNotFound) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger index = ((IntroContentViewController *) viewController).pageIndex;
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index > [self.mainTitles count]) [self dismissViewControllerAnimated:YES completion:nil];
    if (index == [self.mainTitles count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (IntroContentViewController *)viewControllerAtIndex:(NSInteger)index
{
    if ([self.mainTitles count] == 0 || index >= [self.mainTitles count]) {
        return nil;
    }
    IntroContentViewController *contentController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentController"];
    contentController.mainTitleText = [self.mainTitles objectAtIndex:index];
    contentController.secondaryText = [self.secondaryText objectAtIndex:index];
    contentController.imageFile = [self.imageFiles objectAtIndex:index];
    contentController.pageIndex = index;
    
    return contentController;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.mainTitles count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

@end
