//
//  ListCell.h
//  SquareList
//
//  Created by Skylar Peterson on 12/2/13.
//  Copyright (c) 2013 Class Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ListCellDelegate <NSObject>

@optional

- (void)textViewDidBeginEditingForCell:(UICollectionViewCell *)cell;
- (void)textViewDidEndEditingForCell:(UICollectionViewCell *)cell;
- (void)textViewDidGrowVertically:(UICollectionViewCell *)cell toHeight:(CGFloat)height;

@end

@interface ListCell : UICollectionViewCell

#define LIST_COMPLETION_VIEW_SIZE 55.0
#define IMAGE_BUTTON_SIZE 55.0

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) UIColor *backdropColor;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) id<ListCellDelegate> delegate;

+ (CGSize)sizeForTextViewWithText:(NSString *)text inCellWidth:(CGFloat)width;

@end
