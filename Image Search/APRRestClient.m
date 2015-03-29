//
//  APRRestClient.m
//  Image Search
//
//  Created by Apratim Choudhury on 3/26/15.
//  Copyright (c) 2015 Apro. All rights reserved.
//

#import "APRRestClient.h"
#import "APRThumbnailImage.h"

const int APR_REQUEST_SIZE = 8;

static NSString *const kBaseURL = @"https://ajax.googleapis.com/ajax/services/search/images";
static NSString *const kURLQueryFormat = @"?v=1.0&rsz=8&q=%@&start=%ld";
static NSString *const kResponseMimeType = @"text/javascript";
static const int kHttpOk = 200;
static NSString *const kResponseDataKey = @"responseData";


@implementation APRRestClient

+ (instancetype) sharedInstance{

    static APRRestClient *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    
    return instance;
}


- (void)fetchDataForKeyword:(NSString *)keyword position:(unsigned long) position
                  onSuccess:(void (^)(NSDictionary *responseJSON)) successHandler onError:(void (^)()) errorHandler{
    
    NSParameterAssert(keyword != nil);
    
    //setup URL and request
    NSURL *url = [NSURL URLWithString:[kBaseURL stringByAppendingFormat:kURLQueryFormat, [keyword stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], position]];
    NSDictionary *headers = @{@"Accept-Encoding": @"gzip"};
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setAllHTTPHeaderFields:headers];
    
    //make connection
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        
        //checking network response
        if (!connectionError) {
            if ((httpResponse.statusCode == kHttpOk) && [httpResponse.MIMEType isEqualToString:kResponseMimeType]) {
                
                NSError *__autoreleasing *error = nil;
                NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:error];
                
                if (!error) {
                    //successful JSON parse clause
                    successHandler(responseDict);
                }
            }
        }else{
            
            //network error clause
            errorHandler();
        }
    }];
}

@end
