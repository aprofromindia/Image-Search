//
//  APRThumbnailImageModel.h
//  Image Search
//
//  Created by Apratim Choudhury on 3/27/15.
//  Copyright (c) 2015 Apro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APRJSONModel.h"


@interface APRThumbnailImage : APRJSONModel

/// Thumbnail URL image string
@property (nonatomic, copy, setter = setTbUrl:) NSString *thumbnailURL;

@end
