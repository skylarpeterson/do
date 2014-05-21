//
//  ListViewController.m
//  SquareList
//
//  Created by Skylar Peterson on 12/2/13.
//  Copyright (c) 2013 Class Apps. All rights reserved.
//

#import "ListViewController.h"
#import "ListCell.h"

@interface ListViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ListCellDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *listItems;
@property (nonatomic, strong) UICollectionViewCell *selectedCell;
@end

@implementation ListViewController

#define CELL_IDENTIFIER @"List Cell"

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.view.tintColor = [Colors interactiveColor];
    
    self.color = [Colors randomColor];
    self.view.backgroundColor = self.color;
    
    self.titleLabel.text = self.listTitle;
    self.titleLabel.textColor = [Colors backdropColor];
    self.titleLabel.font = [UIFont fontWithName:@"Quicksand-Regular" size:28];
    
    [self.addButton setBackgroundImage:[[UIImage imageNamed:@"AddIcon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [self.closeButton setBackgroundImage:[[UIImage imageNamed:@"CloseIcon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[ListCell class] forCellWithReuseIdentifier:CELL_IDENTIFIER];
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.layer.borderColor = [[Colors interactiveColor] CGColor];
    self.collectionView.layer.borderWidth = 1.0f;
    
    NSMutableArray *tempItems = [[NSMutableArray alloc] init];
    for (int i = 0; i < 10; i++) {
        [tempItems addObject:[NSString stringWithFormat:@"Item %i", i]];
    }
    self.listItems = [tempItems mutableCopy];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    if ([[Colors backdropColor] isEqual:[UIColor whiteColor]]) {
        return UIStatusBarStyleLightContent;
    } else {
        return UIStatusBarStyleDefault;
    }
}

#pragma mark - Collection View Data Source Methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.listItems count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ListCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    
    cell.text = [self.listItems objectAtIndex:indexPath.row];
    cell.color = self.color;
    cell.backdropColor = [Colors backdropColor];
    cell.delegate = self;
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize cellSize = [ListCell sizeForTextViewWithText:[self.listItems objectAtIndex:indexPath.row] inCellWidth:self.collectionView.frame.size.width];
    cellSize.height += 40;
    return cellSize;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

#pragma mark - Single List Cell delegate methods

- (void)textViewDidBeginEditingForCell:(UICollectionViewCell *)cell
{
    self.selectedCell = cell;
}

- (void)textViewDidEndEditingForCell:(UICollectionViewCell *)cell
{
    if ([self.selectedCell isEqual:cell]) {
        self.selectedCell = nil;
    }
}

- (void)textViewDidGrowVertically:(UICollectionViewCell *)cell toHeight:(CGFloat)height
{
    ListCell *listCell = (ListCell *)[self.collectionView cellForItemAtIndexPath:[self.collectionView indexPathForCell:cell]];
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGFloat newHeight = height + 40.0;
                         CGFloat heightChange = newHeight - listCell.frame.size.height;
                         NSLog(@"Old Height: %f, New Height: %f, Height Change: %f", listCell.frame.size.height, newHeight, heightChange);
                         for(UICollectionViewCell *currCell in [self.collectionView visibleCells]) {
                             currCell.frame = CGRectMake(currCell.frame.origin.x, currCell.frame.origin.y + heightChange, currCell.frame.size.width, currCell.frame.size.height);
                         }
                         listCell.frame = CGRectMake(listCell.frame.origin.x, listCell.frame.origin.y, listCell.frame.size.width, newHeight);
                     }completion:^(BOOL finished){
                         if (finished) {
                             NSLog(@"New Height: %f", listCell.frame.size.height);
                             NSLog(@"Animated!");
                         }
                     }];
}

// from Text Programming Guide for iOS on Apple Developer Website (slightly modified)
#define X_PADDING 3.0
- (void)keyboardWasShown:(NSNotification *)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInset = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
    self.collectionView.contentInset = contentInset;
    self.collectionView.scrollIndicatorInsets = contentInset;
    CGRect aRect = self.view.frame;
    aRect.size.height -= keyboardSize.height;
    CGPoint point = [self.collectionView convertPoint:self.selectedCell.frame.origin toView:self.view];
    point.x += X_PADDING; // necessary to add because collection view is slightly offscreen (to hide border on either side)
    point.y += self.selectedCell.frame.size.height;
    if (!CGRectContainsPoint(aRect, point) ) {
        CGPoint scrollPoint = CGPointMake(0.0, self.selectedCell.frame.origin.y - keyboardSize.height);
        [self.collectionView setContentOffset:scrollPoint animated:YES];
    }
}

- (void) keyboardWillHide:(NSNotification *)notification {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.collectionView.contentInset = contentInsets;
    self.collectionView.scrollIndicatorInsets = contentInsets;
}

- (IBAction)addItem:(id)sender
{
    [self.listItems insertObject:@"This is a new item that I've just added in, I hope this works" atIndex:0];
    NSIndexPath *newPath = [NSIndexPath indexPathForItem:0 inSection:0];
    [self.collectionView insertItemsAtIndexPaths:@[newPath]];
    [self.collectionView scrollToItemAtIndexPath:newPath atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
}

@end
