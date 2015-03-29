//
//  APRJSONObject.m
//  Image Search
//
//  Created by Apratim Choudhury on 3/26/15.
//  Copyright (c) 2015 Apro. All rights reserved.
//

#import "APRJSONModel.h"

@implementation APRJSONModel


- (instancetype)initWithDictionary:(NSDictionary *)dict {
    
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

// ignoring the default behaviour in trying to set value for undefined key
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}

@end
