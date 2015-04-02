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

@interface APRRestClient (){
    
    // App URLSession instance.
    NSURLSession *_session;
}

@end

@implementation APRRestClient


//singleton method which initialises a singleton NSURLSession instance with gzip encoding.
+ (instancetype) sharedInstance{
    
    static APRRestClient *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
        
        //setting session config with gzip encoding header
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionConfig.HTTPAdditionalHeaders = @{@"Accept-encoding" : @"gzip"};
        
        instance->_session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    });
    return instance;
}




- (void)fetchDataForKeyword:(NSString *)keyword position:(unsigned long) position
                  onSuccess:(void (^)(NSDictionary *responseJSON)) successHandler onError:(void (^)()) errorHandler{
    
    NSParameterAssert(keyword != nil);
    
    //setup URL and request
    NSURL *url = [NSURL URLWithString:[kBaseURL stringByAppendingFormat:kURLQueryFormat, [keyword stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], position]];
    
    //make connection
    [[_session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        
        //checking network response
        if (!error) {
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
    }] resume];
}

@end
