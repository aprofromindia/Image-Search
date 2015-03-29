//
//  NSMutableArray+APRStreamArray.h
//  Image Search
//
//  Created by Apro on 29/03/15.
//  Copyright (c) 2015 Apro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (APRMutableArrayStream)

/** Function used to find the object at the index of a mutable array,
* or fill up the array till the index with NSNull objects and then return the NSNull instance
*
* @param object index
* @return The object at index or NSNULL
*/
- (id)apr_objectAtIndexOrNullExpanded:(NSUInteger)index;

@end