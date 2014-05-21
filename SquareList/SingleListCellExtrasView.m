//
//  SingleListCellExtrasView.m
//  SquareList
//
//  Created by Skylar Peterson on 12/7/13.
//  Copyright (c) 2013 Class Apps. All rights reserved.
//

#import "SingleListCellExtrasView.h"
#import "ExtrasPhotoCollectionViewCell.h"

#import "ColorSelectionView.h"

#import "Colors.h"
#import "Fonts.h"

@interface SingleListCellExtrasView() <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) UIButton *takePhotoButton;
@property (nonatomic, strong) UIButton *choosePhotoButton;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic) BOOL presentingActionSheet;
@property (nonatomic, strong) UIImage *photoToDelete;

@end

#define EXTRAS_PHOTO_CELL_IDENTIFIER @"PhotoCellIdentifier"

@implementation SingleListCellExtrasView

- (NSMutableArray *)photos
{
    if (!_photos) _photos = [[NSMutableArray alloc] init];
    return _photos;
}

- (UIButton *)takePhotoButton
{
    if (!_takePhotoButton) _takePhotoButton = [[UIButton alloc] init];
    return _takePhotoButton;
}

- (UIButton *)choosePhotoButton
{
    if (!_choosePhotoButton) _choosePhotoButton = [[UIButton alloc] init];
    return _choosePhotoButton;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.takePhotoButton.titleLabel.font = [Fonts bodyTextFont];
        [self.takePhotoButton setTitle:@"Take" forState:UIControlStateNormal];
        [self.takePhotoButton setTitleColor:[Colors interactiveColor] forState:UIControlStateNormal];
        [self.takePhotoButton addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.takePhotoButton];
        
        self.choosePhotoButton.titleLabel.font = [Fonts bodyTextFont];
        [self.choosePhotoButton setTitle:@"Choose" forState:UIControlStateNormal];
        [self.choosePhotoButton setTitleColor:[Colors interactiveColor] forState:UIControlStateNormal];
        [self.choosePhotoButton addTarget:self action:@selector(choosePhoto:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.choosePhotoButton];
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectNull
                                                 collectionViewLayout:flowLayout];
        self.collectionView.backgroundColor = [UIColor clearColor];
        [self.collectionView registerClass:[ExtrasPhotoCollectionViewCell class] forCellWithReuseIdentifier:EXTRAS_PHOTO_CELL_IDENTIFIER];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.alwaysBounceHorizontal = YES;
        [self addSubview:self.collectionView];
        
        UILongPressGestureRecognizer *holdGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(editPhoto:)];
        holdGesture.minimumPressDuration = 0.35;
        holdGesture.numberOfTouchesRequired = 1.0;
        [self.collectionView addGestureRecognizer:holdGesture];
    }
    return self;
}

- (void)takePhoto:(UIButton *)sender
{
    [self.dataSource takePhoto];
}

- (void)choosePhoto:(UIButton *)sender
{
    [self.dataSource choosePhoto];
}

#define INSET 10.0
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.takePhotoButton.frame = CGRectMake(INSET, 0.0, self.frame.size.height, self.frame.size.height/2.0);
    self.choosePhotoButton.frame = CGRectMake(INSET, self.frame.size.height/2.0, self.frame.size.height, self.frame.size.height/2.0);
    self.collectionView.frame = CGRectMake(self.frame.size.height + INSET, 0.0, self.frame.size.width - self.frame.size.height, self.frame.size.height);
}

#pragma mark - CollectionView Data Source Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.photos count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ExtrasPhotoCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:EXTRAS_PHOTO_CELL_IDENTIFIER forIndexPath:indexPath];
    
    cell.image = [self.photos objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - CollectionView Delegate Methods

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.frame.size.height - 4.0, self.frame.size.height - 4.0);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0.0, 2.0, 0.0, 2.0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 2.0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ExtrasPhotoCollectionViewCell *extrasCell = (ExtrasPhotoCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [self.dataSource photoSelected:extrasCell.image];
}

#pragma mark - Gesture Methods

- (void)editPhoto:(UILongPressGestureRecognizer *)recognizer
{
    if (self.presentingActionSheet) return;
    CGPoint cvPoint = [self.collectionView convertPoint:[recognizer locationInView:self] fromView:self];
    ExtrasPhotoCollectionViewCell *cell = (ExtrasPhotoCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[self.collectionView indexPathForItemAtPoint:cvPoint]];
    if (cell) {
        self.presentingActionSheet = YES;
        self.photoToDelete = cell.image;
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Delete Photo"
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:@"Delete"
                                                        otherButtonTitles:nil];
        [actionSheet showInView:[self superview]];
    }
}

#pragma mark - Action Sheet Delegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.destructiveButtonIndex) {
        NSInteger index = [self.photos indexOfObject:self.photoToDelete];
        [self.dataSource photoDeletedAtIndex:index];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self.photos removeObject:self.photoToDelete];
        [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    }
    self.presentingActionSheet = NO;
}

#pragma mark - Provided Methods

- (void)addPhoto:(UIImage *)photo
{
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.photos insertObject:photo atIndex:0];
    [self.collectionView insertItemsAtIndexPaths:@[newIndexPath]];
}

@end
