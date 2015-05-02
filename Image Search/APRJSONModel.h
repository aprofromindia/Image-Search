//
//  APRJSONObject.h
//  Image Search
//
//  Created by Apratim Choudhury on 3/26/15.
//  Copyright (c) 2015 Apro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APRJSONModel : NSObject

/** Designated initialiser used to inflate Model objects from JSON responses.
 @param dict JSON Dictionary with keys and values to create model object.
 
 @return singleton instance.
*/
- (instancetype)initWithDictionary:(NSDictionary *) dict;

@end
