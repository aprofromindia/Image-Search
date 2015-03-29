//
//  APRRestClient.h
//  Image Search
//
//  Created by Apratim Choudhury on 3/26/15.
//  Copyright (c) 2015 Apro. All rights reserved.
//

#import <Foundation/Foundation.h>

extern const int APR_REQUEST_SIZE;

@interface APRRestClient : NSObject

// Singleton accessor
+ (instancetype) sharedInstance;

/**
* @param keyword Keyword string to search for
* @param position Start request param position
* @param successHandler
* @param errorHandler
*/
- (void)fetchDataForKeyword:(NSString *)keyword position:(unsigned long) position
                  onSuccess:(void (^)(NSDictionary *responseDict)) successHandler onError:(void (^)()) errorHandler;
@end
