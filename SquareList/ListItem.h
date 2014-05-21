//
//  ListItem.h
//  SquareList
//
//  Created by Skylar Peterson on 12/8/13.
//  Copyright (c) 2013 Class Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class List;

@interface ListItem : NSManagedObject

@property (nonatomic, retain) NSNumber * completed;
@property (nonatomic, retain) NSString * contents;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSData * photos;
@property (nonatomic, retain) NSNumber * numPhotos;
@property (nonatomic, retain) List *list;

@end
