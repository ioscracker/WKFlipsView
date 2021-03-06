//

//  ViewController.m
//  WKFlipsView
//
//  Created by 秦 道平 on 13-12-9.
//  Copyright (c) 2013年 秦 道平. All rights reserved.
//

#import "ViewController.h"
#import "WKFlipsView.h"
#import "TestFlipPageView.h"
#import "TestImagePageView.h"
@interface ViewController ()<WKFlipsViewDataSource,WKFlipsViewDelegate>{
    WKFlipsView* _flipsView;
    NSMutableArray* _images;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //[self testSortPages];
    [self testPrepareImages];
    
    if (!_flipsView){
        _flipsView=[[WKFlipsView alloc]initWithFrame:self.view.bounds atPageIndex:1 withCacheIdentity:@"test"];
        _flipsView.backgroundColor=[UIColor darkGrayColor];
        _flipsView.dataSource=self;
        _flipsView.delegate=self;
        [_flipsView registerClass:[TestImagePageView class] forPageWithReuseIdentifier:@"page"];
        [self.view addSubview:_flipsView];

    }
    [_flipsView reloadPages];

    UIButton* buttonNext=[UIButton buttonWithType:UIButtonTypeCustom];
    buttonNext.frame=CGRectMake(10.0f, 300.0f, 300.0f, 50.0f);
    [buttonNext setTitle:@"Next" forState:UIControlStateNormal];
    [buttonNext setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buttonNext.backgroundColor=[UIColor lightGrayColor];
    [buttonNext addTarget:self action:@selector(onButtonNext:) forControlEvents:UIControlEventTouchUpInside];
    //[self.view addSubview:buttonNext];
    
    UIButton* buttonInsert=[UIButton buttonWithType:UIButtonTypeCustom];
    buttonInsert.frame=CGRectMake(10.0f, 360.0f, 300.0f, 50.0f);
    [buttonInsert setTitle:@"Insert" forState:UIControlStateNormal];
    [buttonInsert setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buttonInsert.backgroundColor=[UIColor lightGrayColor];
    [buttonInsert addTarget:self action:@selector(onButtonInsert:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonInsert];
    
    UIButton* buttonUpdate=[UIButton buttonWithType:UIButtonTypeCustom];
    buttonUpdate.frame=CGRectMake(10.0f, 420.0f, 300.0f, 50.0f);
    [buttonUpdate setTitle:@"Update" forState:UIControlStateNormal];
    [buttonUpdate setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buttonUpdate.backgroundColor=[UIColor lightGrayColor];
    [buttonUpdate addTarget:self action:@selector(onButtonUpdate:) forControlEvents:UIControlEventTouchUpInside];
    //[self.view addSubview:buttonUpdate];

    [_flipsView flipToPageIndex:9 delay:1.0f completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    [_images release];
    [super dealloc];
}
-(IBAction)onButtonNext:(id)sender{
    [_flipsView flipToPageIndex:_flipsView.pageIndex+1];
}
-(IBAction)onButtonDelete:(id)sender{
    [_flipsView deleteCurrentPage];
}
-(IBAction)onButtonInsert:(id)sender{
    [_flipsView insertPage];
    //[_flipsView appendPage];
}
-(IBAction)onButtonUpdate:(id)sender{
    [_flipsView updateCurrentPage];
}
#pragma mark - WKFlipsViewDataSource & WKFlipsViewDelegate
#pragma mark WKFlipsViewDataSource
-(NSInteger)numberOfPagesForFlipsView:(WKFlipsView *)flipsView{
    return _images.count;
}
-(WKFlipPageView*)flipsView:(WKFlipsView *)flipsView pageAtPageIndex:(int)pageIndex isThumbCopy:(bool)isThumbCopy{
    static NSString* identity=@"page";
    TestImagePageView* pageView=(TestImagePageView*)[flipsView dequeueReusablePageWithReuseIdentifier:identity isThumbCopy:isThumbCopy];
    UIImage* image=[UIImage imageNamed:_images[pageIndex]];
    pageView.testImageView.image=image;
    UIButton* button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(10.0f, 30.0f+20*pageIndex, 300.0f, 50.0f);
    [button setTitle:@"delete" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    button.backgroundColor=[UIColor whiteColor];
    [button addTarget:self action:@selector(onButtonDelete:) forControlEvents:UIControlEventTouchUpInside];
    [pageView addSubview:button];
    return pageView;

}
#pragma mark WKFlipsViewDelegate
-(void)flipsView:(WKFlipsView *)flipsView willDeletePageAtPageIndex:(int)pageIndex{
    [_images removeObjectAtIndex:pageIndex];
    [self testWriteImages];
}
-(void)flipsView:(WKFlipsView *)flipsView willInsertPageAtPageIndex:(int)pageIndex{
    [_images insertObject:@"a.png" atIndex:pageIndex];
    [self testWriteImages];
}
-(void)willAppendPageIntoFlipsView:(WKFlipsView *)flipsView{
    [_images addObject:@"c.png"];
    [self testWriteImages];
}
-(void)flipsView:(WKFlipsView *)flipsView willUpdatePageAtPageIndex:(int)pageIndex{
    _images[pageIndex]=@"b.png";
    [self testWriteImages];
}
-(void)flipsView:(WKFlipsView *)flipsView didDeletePageAtPageIndex:(int)pageIndex{
    NSLog(@"didDeletePageAtPageIndex:%d",pageIndex);
}
-(void)flipsView:(WKFlipsView *)flipsView didInsertPageAtPageIndex:(int)pageIndex{
    NSLog(@"didInsertPageAtPageIndex:%d",pageIndex);
}
-(void)didAppendPageIntoFlipsView:(WKFlipsView *)flipsView{
    NSLog(@"didAppendPageIntoFlipsView");
}
-(void)flipsView:(WKFlipsView *)flipsView didUpdatePageAtPageIndex:(int)pageIndex{
    NSLog(@"didUpdatePageAtPageIndex:%d",pageIndex);
}
#pragma mark - Test
-(void)testPrepareImages{
    if (!_images){
        _images=[[NSMutableArray alloc]init];
    }
    [_images removeAllObjects];
    NSString* filename=[NSString stringWithFormat:@"%@/test.images",WKFLIPS_PATH_DOCUMENT];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filename]){
        NSLog(@"load test images");
        NSString* string=[NSString stringWithContentsOfFile:filename encoding:NSUTF8StringEncoding error:NULL];
        NSArray* array=[string componentsSeparatedByString:@"\n"];
        [_images addObjectsFromArray:array];
        NSMutableArray* delete_array=[NSMutableArray array];
        for (NSString* one_image in _images) {
            if (!one_image || [one_image isEqualToString:@""]){
                [delete_array addObject:one_image];
            }
        }
        [_images removeObjectsInArray:delete_array];
    }
    else{
        NSLog(@"new images");
        for (int a=0; a<23; a++) {
            [_images addObject:[NSString stringWithFormat:@"%d.png",a]];
        }
        [self testWriteImages];
    }
}
-(void)testWriteImages{
    NSString* filename=[NSString stringWithFormat:@"%@/test.images",WKFLIPS_PATH_DOCUMENT];
    NSMutableString* string=[NSMutableString string];
    for (NSString* one_image in _images) {
        if ([one_image isEqualToString:@""]){
            continue;
        }
        [string appendFormat:@"%@\n",one_image];
    }
    NSData* data=[string dataUsingEncoding:NSUTF8StringEncoding];
    [data writeToFile:filename atomically:YES];
    //NSLog(@"writeImages:%@",filename);
}
-(void)testSortPages{
    NSMutableArray* pagesArray=[NSMutableArray array];
    for (int a=0; a<23; a++) {
        [pagesArray addObject:[NSNumber numberWithInt:a]];
    }
    int currentPageIndex=9;
    NSLog(@"pagesArray:%@",pagesArray);
    NSArray* sortedPagesArray=[pagesArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        int page_1=[(NSNumber*)obj1 intValue];
        int distance_1=abs(page_1-currentPageIndex);
        int page_2=[(NSNumber*)obj2 intValue];
        int distance_2=abs(page_2-currentPageIndex);
        if (distance_1<distance_2){
            return NSOrderedAscending;
        }
        else if (distance_1>distance_2){
            return NSOrderedDescending;
        }
        else
            return NSOrderedSame;
    }];
    NSLog(@"sortedPagesArray:%@",sortedPagesArray);
}
@end
