//
//  BunnerCustomView.h
//  CMmovies
//
//  Created by caimiao on 15/7/8.
//  Copyright (c) 2015年 caimiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BunnerCustomView : UIView

@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) UIPageControl *pageControll;
@property (nonatomic,strong) NSArray * imageArrayList;

- (void)reloadUzaiPageScrollView:(NSArray *)imageArray;

@end
