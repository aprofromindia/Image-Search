//
//  NSMutableArray+APRStreamArray.m
//  Image Search
//
//  Created by Apro on 29/03/15.
//  Copyright (c) 2015 Apro. All rights reserved.
//

#import "NSMutableArray+APRStreamArray.h"

@implementation NSMutableArray (APRMutableArrayStream)

- (id)apr_objectAtIndexOrNullExpanded:(NSUInteger)index{
    
    if (index >= self.count) {
        for (int i = (int) self.count; i <= index; i++) {
            self[i] = [NSNull null];
        }
    }
    return [self objectAtIndex:index];
}

@end
