//
//  BunnerCustomView.m
//  CMmovies
//
//  Created by caimiao on 15/7/8.
//  Copyright (c) 2015年 caimiao. All rights reserved.
//

#import "BunnerCustomView.h"
#import "BannerListModel.h"
#import "WebViewController.h"

@interface BunnerCustomView()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *pointBackView;

@end

@implementation BunnerCustomView

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initWithImageUIShow];
    }
    return self;
}

-(void)initWithImageUIShow
{
    [self setUserInteractionEnabled:YES];
    self.scrollView= [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height)];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.scrollView];
    
    _pageControll = [[UIPageControl alloc] init];
    [_pageControll setCenter: CGPointMake(self.center.x, self.bounds.size.height-10.0f)] ;
    [_pageControll addTarget: self action: @selector(pageControlPageChanged:) forControlEvents: UIControlEventValueChanged] ;
    [_pageControll setDefersCurrentPageDisplay: YES];
    _pageControll.pageIndicatorTintColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.3f];
    [self addSubview: _pageControll];
    _pageControll.hidden = YES;
    self.pointBackView = [[UIView alloc]initWithFrame:CGRectMake(15, 12 + 175 + 10, DEF_DEVICE_WIDTH - 30, 5)];
    self.pointBackView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.pointBackView];
}

#pragma mark -
#pragma mark Required Methods

- (void)reloadUzaiPageScrollView:(NSArray *)imageArray
{
    
    for (UIView *subview in _scrollView.subviews) {
        if (subview.tag == 404) {
            [subview removeFromSuperview];
        }
    }
    if ([imageArray count] == 0) {
        if (_timer != nil) {
            [_timer invalidate];
            _timer = nil;
        }
        _scrollView.scrollEnabled = NO;
        _scrollView.pagingEnabled = NO;
        
        _pageControll.numberOfPages = 0;
        _pageControll.currentPage = 0;
        
        self.pointBackView.hidden = YES;
    }
    else {
        
        _scrollView.scrollEnabled = YES;
        _scrollView.pagingEnabled = YES;
        
        CGFloat width = _scrollView.frame.size.width;
        CGFloat height = _scrollView.frame.size.height;
        
        BannerListModel * firstModel = (BannerListModel *)[imageArray lastObject];

        //SDWebImageAllowInvalidSSLCertificates
        NSString *previousImageUrl = [[NSString stringWithFormat:@"%@",firstModel.imageUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        UIImageView *firstImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 12, width - 30, 175)];
        firstImageView.clipsToBounds = YES;
        [firstImageView sd_setImageWithURL:[NSURL URLWithString:previousImageUrl] placeholderImage:DEF_IMAGE(@"ic_loading") options:SDWebImageAllowInvalidSSLCertificates];
        firstImageView.contentMode =UIViewContentModeScaleAspectFill;
        [firstImageView setBackgroundColor:DEF_UICOLORFROMRGB(0xf5f5f5)];
        firstImageView.tag = 404;
        firstImageView.layer.cornerRadius = 4;
        [_scrollView addSubview:firstImageView];
        
        for (int i = 0; i < imageArray.count; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(width * (i + 1) + 15, 12, width - 30, 175)];
            
            BannerListModel * imageIndex =(BannerListModel *)[imageArray objectAtIndex:i];
            NSString *previousImageUrl = [[NSString stringWithFormat:@"%@",imageIndex.imageUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [imageView sd_setImageWithURL:[NSURL URLWithString:previousImageUrl] placeholderImage:DEF_IMAGE(@"ic_loading") options:SDWebImageAllowInvalidSSLCertificates];
            imageView.contentMode =UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            [imageView setBackgroundColor:DEF_UICOLORFROMRGB(0xf5f5f5)];
            imageView.tag = 404;
            imageView.layer.cornerRadius = 4;
            [_scrollView addSubview:imageView];
            
        }
        
        BannerListModel * lastModel= (BannerListModel *)[imageArray objectAtIndex:0];
        NSString *previousImageUrl1 = [[NSString stringWithFormat:@"%@",lastModel.imageUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        UIImageView *lastImageView = [[UIImageView alloc] initWithFrame:CGRectMake(width * (imageArray.count + 1) + 15, 12, width - 30, 175)];
        [lastImageView sd_setImageWithURL:[NSURL URLWithString:previousImageUrl1] placeholderImage:DEF_IMAGE(@"ic_loading") options:SDWebImageAllowInvalidSSLCertificates];
        lastImageView.contentMode =UIViewContentModeScaleAspectFill;
        [lastImageView setBackgroundColor:DEF_UICOLORFROMRGB(0xf5f5f5)];
        lastImageView.tag = 404;
        lastImageView.clipsToBounds = YES;
        lastImageView.layer.cornerRadius = 4;
        [_scrollView addSubview:lastImageView];
        [_scrollView setContentSize:CGSizeMake(width * (imageArray.count + 2), height)];
        [_scrollView scrollRectToVisible:CGRectMake(width, 0.0, width, height) animated:NO];
        
        _pageControll.numberOfPages = imageArray.count;
        _pageControll.currentPage = 0;
        
        self.pointBackView.hidden = NO;
        
        [self setPointFrameWithIndex:0];
        
        if (_timer != nil) {
            [_timer invalidate];
            _timer = nil;
        }
        _timer = [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(scrollViewScrollToNextPage:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];

    }
    
    UITapGestureRecognizer *aTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImage:)];
    aTap.numberOfTapsRequired=1;
    [_scrollView addGestureRecognizer:aTap];
    
    _imageArrayList = imageArray;
}

-(void)setPointFrameWithIndex:(NSUInteger)currentPage
{
    for (UIView * view in self.pointBackView.subviews) {
        [view removeFromSuperview];
    }
    int x = 0;
    for (int i = 0; i < _pageControll.numberOfPages; i++) {
        if (i == currentPage) {
            UIImageView * imgav = [[UIImageView alloc]initWithFrame:CGRectMake(x, 0, 8, 3)];
            imgav.image = DEF_IMAGE(@"ic_point_sel");
            [self.pointBackView addSubview:imgav];
            x += 10;
        }else{
            UIImageView * imgav = [[UIImageView alloc]initWithFrame:CGRectMake(x, 0, 3, 3)];
            imgav.image = DEF_IMAGE(@"ic_point");
            [self.pointBackView addSubview:imgav];
            x += 5;
        }
    }
}

- (void)pageControlPageChanged:(id)sender
{
    UIPageControl *thePageControl = (UIPageControl *)sender ;
    // we need to scroll to the new index
    [_scrollView setContentOffset: CGPointMake(_scrollView.bounds.size.width * thePageControl.currentPage, _scrollView.contentOffset.y) animated: YES] ;
}

- (void)scrollViewScrollToNextPage:(NSTimer *)timer
{
    [_pageControll updateCurrentPageDisplay];
    NSUInteger currentPage = _pageControll.currentPage;
    CGSize size = _scrollView.frame.size;
    CGRect rect = CGRectMake((currentPage + 2) * size.width, 0, size.width, size.height);
    [_scrollView scrollRectToVisible:rect animated:YES];
    
    currentPage ++;
    if (currentPage == [_imageArrayList count]) {
        CGRect lastRect = CGRectMake(size.width * ([_imageArrayList count] + 1), 0.0, size.width, size.height);
        _pageControll.currentPage = 0;
        [self setPointFrameWithIndex:_pageControll.currentPage];

        dispatch_async(dispatch_get_main_queue(), ^{
            [_scrollView scrollRectToVisible:lastRect animated:YES];
        });
        return;
    }
    _pageControll.currentPage = currentPage;
    [self setPointFrameWithIndex:_pageControll.currentPage];

}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_pageControll updateCurrentPageDisplay];
    
    if (_timer != nil) {
        [_timer invalidate];
        _timer = nil;
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_pageControll updateCurrentPageDisplay];
    
    if (_timer != nil) {
        [_timer invalidate];
        _timer = nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(scrollViewScrollToNextPage:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_pageControll updateCurrentPageDisplay];
    
    CGFloat width = scrollView.frame.size.width;
    NSUInteger currentPage = floor((scrollView.contentOffset.x - width / 2) / width) + 1;
    if (currentPage == 0) {
        _pageControll.currentPage = 0;
        [self setPointFrameWithIndex:_pageControll.currentPage];

    }
    else if (currentPage == [_imageArrayList count] + 1) {
        if (scrollView.contentOffset.x >= ([_imageArrayList count] + 1) * width - 1) {
            [scrollView scrollRectToVisible:CGRectMake(width, 0.0, width, scrollView.frame.size.height) animated:NO];
        }
        
        return;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [_pageControll updateCurrentPageDisplay];
    
    CGFloat width = scrollView.frame.size.width;
    CGFloat heigth = scrollView.frame.size.height;
    
    NSUInteger currentPage = floor((scrollView.contentOffset.x - width / 2) / width) + 1;
    
    if (currentPage == 0) {
        [scrollView scrollRectToVisible:CGRectMake(width * [_imageArrayList count], 0.0, width, heigth) animated:NO];
        _pageControll.currentPage = [_imageArrayList count] - 1;
        [self setPointFrameWithIndex:_pageControll.currentPage];

        
        return;
    }
    else if (currentPage == [_imageArrayList count] + 1) {
        [scrollView scrollRectToVisible:CGRectMake(width, 0.0, width, heigth) animated:NO];
        _pageControll.currentPage = 0;
        [self setPointFrameWithIndex:_pageControll.currentPage];

        return;
    }
    
    _pageControll.currentPage = currentPage - 1;
    [self setPointFrameWithIndex:_pageControll.currentPage];

}

-(void)tapImage:(UITapGestureRecognizer *)aTap
{
    //得到被单击的视图
    if ([_imageArrayList count] > 0) {
        BannerListModel *model = _imageArrayList[_pageControll.currentPage];
        WebViewController *vc = [[WebViewController alloc]init];
        vc.webUrl = model.activityUrl;
        [DEF_MyAppDelegate.mainNav pushViewController:vc animated:YES];
    }
}

@end
