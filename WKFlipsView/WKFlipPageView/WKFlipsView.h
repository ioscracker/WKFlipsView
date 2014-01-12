//   
//  WKFlipsView.h
//  WKFlipsView
//
//  Created by 秦 道平 on 13-12-9.
//  Copyright (c) 2013年 秦 道平. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKFlipPageView.h"
#import "WKFlipsLayer.h"
@class WKFlipsView;
@protocol WKFlipsViewDataSource <NSObject>
///每一页内容
-(WKFlipPageView*)flipsView:(WKFlipsView*)flipsView pageAtPageIndex:(int)pageIndex;
///总页数
-(NSInteger)numberOfPagesForFlipsView:(WKFlipsView*)flipsView;
@end
@protocol WKFlipsViewDelegate <NSObject>


@end
@interface WKFlipsView : UIView{
    NSMutableDictionary* _reusedPageViewDictionary;
    UIView* _testCacheView;
    int _pageIndex;
}
-(id)initWithFrame:(CGRect)frame atPageIndex:(int)pageIndex;
///数据源
@property (nonatomic,assign) id<WKFlipsViewDataSource> dataSource;
///委托
@property (nonatomic,assign) id<WKFlipsViewDelegate> delegate;
@property (nonatomic,retain) _WKFlipsLayerView* flippingLayersView;
#pragma mark - page
///当前正在显示的页面内容
@property (nonatomic,retain) UIView* currentPageView;
///当前的页面,不能直接由外部设置这个页面，因为没有重新计算角度，这个方法只能有_flippingLayersView在flip结束后进行更新
@property (nonatomic,assign) int pageIndex;
///注册页面class
-(void)registerClass:(Class)class forPageWithReuseIdentifier:(NSString*)reuseIdentifier;
///获取一个已经使用的page
-(WKFlipPageView*)dequeueReusablePageWithReuseIdentifier:(NSString*)reuseIdentifier;
#pragma mark - action
///载入页面
-(void)reloadPages;
///无动画的翻页
-(void)flipToPageIndex:(int)pageIndex;
///动画翻页到一个指定的页面
-(void)flipToPageIndex:(int)pageIndex completion:(void(^)())completion;
@end
