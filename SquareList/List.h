//
//  List.h
//  Do.
//
//  Created by Skylar Peterson on 2/18/14.
//  Copyright (c) 2014 Class Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ListItem;

@interface List : NSManagedObject

@property (nonatomic, retain) NSNumber * color;
@property (nonatomic, retain) NSDate * dateAdded;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * textColor;
@property (nonatomic, retain) NSSet *items;
@end

@interface List (CoreDataGeneratedAccessors)

- (void)addItemsObject:(ListItem *)value;
- (void)removeItemsObject:(ListItem *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

@end
