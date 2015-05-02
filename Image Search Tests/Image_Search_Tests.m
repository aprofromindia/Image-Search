//
//  Image_Search_Tests.m
//  Image Search Tests
//
//  Created by Apro on 03/04/15.
//  Copyright (c) 2015 Apro. All rights reserved.
//

#import <Specta/Specta.h>
#import "APRRestClient.h"

SpecBegin(APRRestClientSpec)


describe(@"REST Client", ^{
    
    it(@"should fetch JSON data asynchronously for a given keyword & position", ^{
        waitUntil(^(DoneCallback done) {
        
            [[APRRestClient sharedInstance] fetchDataForKeyword:@"rafa" position:8 onSuccess:^(NSDictionary *responseDict) {
                done();
            } onError:^{
            }];
        });
    });
});

SpecEnd
