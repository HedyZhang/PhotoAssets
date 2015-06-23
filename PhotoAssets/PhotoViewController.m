//
//  PhotoViewController.m
//  PhotoAssets
//
//  Created by yanshu on 15/6/23.
//  Copyright (c) 2015年 yanshu. All rights reserved.
//

#import "PhotoViewController.h"
#import "PhotoCollectionCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
@interface PhotoViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *photoArray;

@end
@implementation PhotoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"相机胶卷";
    self.photoArray = [NSMutableArray array];
    
    CGFloat space = (self.view.frame.size.width - 3 * 5) / 4.f;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(space, space);
    flowLayout.minimumLineSpacing = 5;
    flowLayout.minimumInteritemSpacing = 5;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[PhotoCollectionCell class] forCellWithReuseIdentifier:PhotoCollectionCellIdentifier];
    
    [self getAssetsLibraryPhotoData];
    
}
- (void)getAssetsLibraryPhotoData
{
    @weakify(self);
    NSMutableArray *groupArrays = [NSMutableArray arrayWithCapacity:0];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @strongify(self);
        ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop){
            if (group != nil)
            {
                [groupArrays addObject:group];
            }
            else
            {
                [groupArrays enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
                {
                    //相机胶卷
                    if ([[(ALAssetsGroup *)obj valueForProperty:ALAssetsGroupPropertyName] isEqualToString:@"Camera Roll"])
                    {
                        [obj enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop)
                         {
                             if ([result thumbnail] != nil)
                             {
                                 // 照片
                                 if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto])
                                 {
                                     UIImage *image = [UIImage imageWithCGImage:[result thumbnail]];
                                     [self.photoArray addObject:image];
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                         [self.collectionView reloadData];
                                     });
                                 }
                             }
                             
                         }];

                    }
                }];
            }
        };
        
        //用户访问相册失败block
        ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error)
        {
            NSString *errorMessage = nil;
            
            switch ([error code]) {
                case ALAssetsLibraryAccessUserDeniedError:
                case ALAssetsLibraryAccessGloballyDeniedError:
                    errorMessage = @"用户拒绝访问相册,请在<隐私>中开启";
                    break;
                    
                default:
                    errorMessage = @"Reason unknown.";
                    break;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"错误,无法访问!"
                                                                   message:errorMessage
                                                                  delegate:self
                                                         cancelButtonTitle:@"确定"
                                                         otherButtonTitles:nil, nil, nil];
                [alertView show];
            });
        };
        
        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc]  init];
        [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                     usingBlock:listGroupBlock failureBlock:failureBlock];
    });
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photoArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PhotoCollectionCellIdentifier forIndexPath:indexPath];
    cell.photoImageView.image = [self.photoArray objectAtIndex:indexPath.row];
    return cell;
}
@end
