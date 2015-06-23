//
//  PhotoCollectionCell.m
//  PhotoAssets
//
//  Created by yanshu on 15/6/23.
//  Copyright (c) 2015年 yanshu. All rights reserved.
//

#import "PhotoCollectionCell.h"

NSString *const PhotoCollectionCellIdentifier = @"PhotoCollectionCell";


@interface PhotoCollectionCell ()
@end

@implementation PhotoCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.photoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _photoImageView.backgroundColor = [UIColor orangeColor];
        [self addSubview:_photoImageView];
    }
    return self;
}

@end
