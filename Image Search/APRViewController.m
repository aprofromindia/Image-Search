//
//  APRViewController.m
//  Image Search
//
//  Created by Apratim Choudhury on 3/24/15.
//  Copyright (c) 2015 Apro. All rights reserved.
//

#import "APRViewController.h"
#import "APRCollectionViewCell.h"
#import "../SDWebImage/UIImageView+WebCache.h"
#import "APRRestClient.h"
#import "APRThumbnailImage.h"
#import "APRResponseModel.h"
#import "NSMutableArray+APRStreamArray.h"

@interface APRViewController (){
    
    // rest client
    APRRestClient *_restClient;
    
    // response model used to render images
    APRResponseModel *_responseModel;
    
    // maintains display state of the network error related Alert View
    BOOL _isAlertViewDisplayed;
    
    //CollectionView reference
    IBOutlet UICollectionView * __weak _collectionView;
    
    //Search bar reference
    IBOutlet UISearchBar * __weak _searchBar;
    
    //Activity indicator
    IBOutlet UIActivityIndicatorView * __weak _activityView;
    
    // Search keyword string
    NSString *_keyword;
}

@end


@implementation APRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _restClient = [APRRestClient sharedInstance];
    _responseModel = [APRResponseModel new];
    
    _searchBar.text = @"rafa";[self searchBarSearchButtonClicked:_searchBar];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UISearchBar methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    _keyword = _searchBar.text;
    [_collectionView setContentOffset:CGPointZero animated:YES];
    [self p_fetchDataForKeyword:searchBar.text position:0];
}

#pragma mark - UICollectionView methods

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *const kCellIdentifier = @"APRCollectionViewCell";
    
    APRCollectionViewCell *viewCell = (APRCollectionViewCell *) [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    viewCell.imageView.image = nil;
    
    id object = [_responseModel.images apr_objectAtIndexOrNullExpanded:indexPath.item];
    
    if ([object isKindOfClass:[APRThumbnailImage class]]) {
        
        APRThumbnailImage *thumbnailImg = (APRThumbnailImage *) object;
        
        NSURL *url = [NSURL URLWithString:thumbnailImg.thumbnailURL];
        [viewCell.imageView sd_setImageWithURL:url];
        
    }else if (indexPath.item % APR_REQUEST_SIZE == 0 && _keyword != nil) {  //TODO
        
        [self p_fetchDataForKeyword:_keyword position:indexPath.item];
    }
    
    return viewCell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _responseModel.imageCount;
}

#pragma mark - UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    _isAlertViewDisplayed = NO; //reset alertView displayed predicate
}

#pragma mark - private methods


/** private method used to fetch groups of images for Google Image Search
* @param long indexPath.item position of the cell in groups of 8.
*/
- (void) p_fetchDataForKeyword:(NSString *) keyword position:(unsigned long) position{
    
    NSParameterAssert(keyword != nil);
    
    [_activityView startAnimating];
    
    typeof(self) __weak weakSelf = self;
    
    [_restClient fetchDataForKeyword:keyword position:position onSuccess:^(NSDictionary *responseDict) {
        
        //success block
        typeof(self) strSelf = weakSelf;
        
        if (strSelf) {
            
            if (position == 0) {
                strSelf->_responseModel.imageCount = (unsigned int) ([responseDict[@"responseData"][@"cursor"][@"pages"] count] * APR_REQUEST_SIZE);
                //recreate the image list for a new keyword.
                strSelf->_responseModel.images = [NSMutableArray arrayWithCapacity:strSelf->_responseModel.imageCount];
            }
            
            NSArray *results = responseDict[@"responseData"][@"results"];
            
            for (int i = 0; i < results.count; i++) {
                
                APRThumbnailImage * thumbnailImg = [[APRThumbnailImage alloc] initWithDictionary:results[i]];
                strSelf->_responseModel.images[position+i] = thumbnailImg;
            }
            
            [strSelf->_collectionView reloadData];
        }
        
        [strSelf->_activityView stopAnimating];
        
    } onError:^{ // error block
        typeof(self) strSelf = weakSelf;
        
        if (strSelf && !(strSelf->_isAlertViewDisplayed)) {
            
            [[[UIAlertView alloc] initWithTitle:@"Network Error" message:@"Please check your network connection" delegate:strSelf cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            strSelf->_isAlertViewDisplayed = YES;
        }
        
        [strSelf->_activityView stopAnimating];
    }];
}

@end
