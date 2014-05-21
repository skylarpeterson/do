//
//  SquareListViewController.m
//  SquareList
//
//  Created by Skylar Peterson on 11/11/13.
//  Copyright (c) 2013 Class Apps. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "DatabaseAvailability.h"
#import "SquareListViewController.h"
#import "SquareListSquareCell.h"
#import "List.h"

#import "SingleListViewController.h"
#import "SettingsViewController.h"
#import "ModalListController.h"

#import "Colors.h"
#import "Fonts.h"

@interface SquareListViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SettingsDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIManagedDocument *document;
@property (nonatomic, strong) NSMutableArray *lists;
@property (nonatomic) BOOL presentingEditingView;

@end

#define SQUARE_CELL_IDENTIFIER @"SquareCell"
#define TUTORIAL_SHOWN_KEY @"TutorialShown"

@implementation SquareListViewController

- (void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserverForName:DatabaseAvailabilityNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note){
                                                      self.document = note.userInfo[DatabaseAvailabilityDocument];
                                                  }];
}

- (UIImageView *)backgroundImageView
{
    UIImage *image = [UIImage imageNamed:@"BackgroundImage.png"];
    if (!_backgroundImageView) _backgroundImageView = [[UIImageView alloc] initWithImage:image];
    return _backgroundImageView;
}

- (NSMutableArray *)newlyAddedLists
{
    if (!_lists) _lists = [[NSMutableArray alloc] init];
    return _lists;
}

- (void)setDocument:(UIManagedDocument *)document
{
    _document = document;
    [self makeRequest];
    [self.collectionView reloadData];
}

- (void)makeRequest
{
    NSManagedObjectContext *moc = [self.document managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"List" inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateAdded" ascending:NO];
    [request setSortDescriptors:@[sortDescriptor]];
    
    NSError *error;
    NSArray *array = [moc executeFetchRequest:request error:&error];
    self.lists = [array mutableCopy];
    if ([array count] > 0) [self.backgroundImageView removeFromSuperview];
}

#define BACKGROUND_IMAGE_SIZE 200.0f
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [Colors backdropColor];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.alwaysBounceVertical = YES;
	[self.collectionView registerClass:[SquareListSquareCell class] forCellWithReuseIdentifier:SQUARE_CELL_IDENTIFIER];
    
    self.titleLabel.textColor = [Colors oppositeBackdropColor];
    self.titleLabel.font = [Fonts mainTitleFont];
    
    [self.addButton setBackgroundImage:[[UIImage imageNamed:@"AddIcon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [self.addButton setTintColor:[Colors mainInteractiveColor]];
    [self.settingsButton setBackgroundImage:[[UIImage imageNamed:@"Settings.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [self.settingsButton setTintColor:[Colors mainInteractiveColor]];
    
    UILongPressGestureRecognizer *holdGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(initializeCellEditing:)];
    holdGesture.minimumPressDuration = 0.35;
    holdGesture.numberOfTouchesRequired = 1.0;
    [self.collectionView addGestureRecognizer:holdGesture];
    
    [self.view addSubview:self.backgroundImageView];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:TUTORIAL_SHOWN_KEY]) {
        [self performSegueWithIdentifier:@"ShowTutorial" sender:self];
    }
    self.backgroundImageView.frame = CGRectMake(self.view.bounds.size.width/2.0 - BACKGROUND_IMAGE_SIZE/2.0, self.view.bounds.size.height/2.0 - BACKGROUND_IMAGE_SIZE/2.0, BACKGROUND_IMAGE_SIZE, BACKGROUND_IMAGE_SIZE);
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    if ([[Colors backdropColor] isEqual:[UIColor blackColor]]) {
        return UIStatusBarStyleLightContent;
    } else {
        return UIStatusBarStyleDefault;
    }
}

#pragma mark - Data Source Methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.lists count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SquareListSquareCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SQUARE_CELL_IDENTIFIER
                                                                           forIndexPath:indexPath];
    List *list = [self.lists objectAtIndex:indexPath.row];
    
    cell.list = list;
    
    return cell;
}

#pragma mark - Flow Layout Delegate Methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"ShowList" sender:indexPath];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        return CGSizeMake(self.view.bounds.size.width/4.0 - 3.0, self.view.bounds.size.width/4.0 - 3.0f);
    } else {
        return CGSizeMake(self.view.bounds.size.width/2 - 3.0f, self.view.bounds.size.width/2 - 3.0f);
    }
    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 2.0f, 0, 2.0f);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 2.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 2.0f;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowList"]) {
        if ([segue.destinationViewController isKindOfClass:[SingleListViewController class]]) {
            SquareListSquareCell *cell = (SquareListSquareCell *)[self.collectionView cellForItemAtIndexPath:(NSIndexPath *)sender];
            SingleListViewController *viewController = segue.destinationViewController;
            viewController.document = self.document;
            viewController.list = cell.list;
        }
    } else if ([segue.identifier isEqualToString:@"ShowSettings"]) {
        if ([segue isKindOfClass:[UIStoryboardPopoverSegue class]]) {
            UIPopoverController *popOverController = ((UIStoryboardPopoverSegue *)segue).popoverController;
            if ([popOverController.contentViewController isKindOfClass:[UINavigationController class]]) {
                SettingsViewController *viewController = (SettingsViewController *)[[((UINavigationController *)popOverController.contentViewController) viewControllers] objectAtIndex:0];
                viewController.delegate = self;
            }
        } else {
            if ([segue.destinationViewController isKindOfClass:[SettingsViewController class]]) {
                SettingsViewController *viewController = segue.destinationViewController;
                viewController.delegate = self;
            }
        }
    } else if ([segue.identifier isEqualToString:@"CreateList"]) {
        if ([segue.destinationViewController isKindOfClass:[ModalListController class]]) {
            ModalListController *viewController = segue.destinationViewController;
            viewController.document = self.document;
            viewController.editing = NO;
        }
    } else if ([segue.identifier isEqualToString:@"EditList"]) {
        if ([segue.destinationViewController isKindOfClass:[ModalListController class]]) {
            ModalListController *viewController = segue.destinationViewController;
            viewController.document = self.document;
            viewController.editing = YES;
            
            SquareListSquareCell *cell = (SquareListSquareCell *)sender;
            viewController.list = cell.list;
            viewController.currentTitle = cell.list.title;
            viewController.currentColor = [cell.list.color integerValue];
        }
    }
}

#pragma mark - Settings Delegate Methods

- (void)backdropColorChanged
{
    [self setNeedsStatusBarAppearanceUpdate];
    self.titleLabel.textColor = [Colors oppositeBackdropColor];
    self.view.backgroundColor = [Colors backdropColor];
    [self.collectionView reloadData];
}

- (void)paletteChanged
{
    [self.collectionView reloadData];
}

#pragma mark - Gesture Recognizer Methods

- (void)initializeCellEditing:(UILongPressGestureRecognizer *)recognizer
{
    if (self.presentingEditingView) return;
    CGPoint cvPoint = [recognizer locationInView:self.collectionView];
    SquareListSquareCell *cell = (SquareListSquareCell *)[self.collectionView cellForItemAtIndexPath:[self.collectionView indexPathForItemAtPoint:cvPoint]];
    if (cell) {
        self.presentingEditingView = YES;
        [self performSegueWithIdentifier:@"EditList" sender:cell];
    }
}

#pragma mark - Rotation Handling

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.collectionView reloadData];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    self.backgroundImageView.frame = CGRectMake(self.view.bounds.size.width/2.0 - BACKGROUND_IMAGE_SIZE/2.0, self.view.bounds.size.height/2.0 - BACKGROUND_IMAGE_SIZE/2.0, BACKGROUND_IMAGE_SIZE, BACKGROUND_IMAGE_SIZE);
}

#pragma mark - Button Actions

- (IBAction)dismissTutorial:(UIStoryboardSegue *)segue
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:TUTORIAL_SHOWN_KEY];
}

- (IBAction)done:(UIStoryboardSegue *)segue {
    [self.collectionView reloadData];
}

- (IBAction)addNewList:(UIStoryboardSegue *)segue
{
    [self.backgroundImageView removeFromSuperview];
    if ([segue.sourceViewController isKindOfClass:[ModalListController class]]) {
        ModalListController *viewController = segue.sourceViewController;
        List *addedList = viewController.list;
        if (addedList) {
            [self.lists insertObject:addedList atIndex:0];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.collectionView insertItemsAtIndexPaths:@[indexPath]];
        }
    }
}

- (IBAction)saveList:(UIStoryboardSegue *)segue
{
    self.presentingEditingView = NO;
    [self.collectionView reloadData];
}

- (IBAction)deleteList:(UIStoryboardSegue *)segue
{
    self.presentingEditingView = NO;
    if ([segue.sourceViewController isKindOfClass:[ModalListController class]]) {
        ModalListController *viewController = segue.sourceViewController;
        List *resultingList = viewController.list;
        if (resultingList) {
            NSInteger index = [self.lists indexOfObject:resultingList];
            [self.lists removeObject:resultingList];
            if ([self.lists count] == 0) [self.view addSubview:self.backgroundImageView];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
            [self.document.managedObjectContext deleteObject:resultingList];
        }
    }
}

- (IBAction)cancelListModal:(UIStoryboardSegue *)segue
{
    self.presentingEditingView = NO;
}

- (IBAction)dismissSettings:(UIStoryboardSegue *)segue
{
    self.view.backgroundColor = [Colors backdropColor];
    self.titleLabel.textColor = [Colors oppositeBackdropColor];
    [self.collectionView reloadData];
}

@end
