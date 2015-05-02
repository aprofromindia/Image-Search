//
//  APRDisplayModel.h
//  Image Search
//
//  Created by Apro on 28/03/15.
//  Copyright (c) 2015 Apro. All rights reserved.
//

#import "APRJSONModel.h"

@interface APRResponseModel : APRJSONModel

/// Array holding Cell item number mapped to APRThumbnail objects.
@property (nonatomic) NSMutableArray *images;

/// Number of images that can be displayed
@property(nonatomic, assign) unsigned int imageCount;

@end
