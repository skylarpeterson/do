//
//  SingleListCellExtrasView.h
//  SquareList
//
//  Created by Skylar Peterson on 12/7/13.
//  Copyright (c) 2013 Class Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ListExtrasViewDataSource <NSObject>

@optional
- (void)takePhoto;
- (void)choosePhoto;
- (void)photoSelected:(UIImage *)photo;
- (void)photoDeletedAtIndex:(NSInteger)index;

@end

@interface SingleListCellExtrasView : UIView

@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) id<ListExtrasViewDataSource> dataSource;

- (void)addPhoto:(UIImage *)photo;

@end
