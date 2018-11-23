//
//  ViewController.m
//  ScroPageDemo
//
//  Created by 王辉平 on 2018/11/23.
//  Copyright © 2018年 王辉平. All rights reserved.
//

#import "ViewController.h"
#import "ShowScroView.h"
#import "BaseView.h"
#define baseTag 1100
@interface ViewController ()<UIScrollViewDelegate>
{
    NSInteger _oldPage;
    UIScrollView* scroView;
}
@property(nonatomic,strong)NSArray* classArr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.classArr = @[@"XiangMuJieSaoPage48",
                      @"XiangMuJieSaoPage49",
                      @"XiangMuJieSaoPage50",
                      @"XiangMuJieSaoPage51_1",
                      @"XiangMuJieSaoPage51_2",
                      @"XiangMuJieSaoPage51_3",
                      @"XiangMuJieSaoPage52",
                      @"XiangMuJieSaoPage53_1",
                      @"XiangMuJieSaoPage53_2",
                      @"XiangMuJieSaoPage54",
                      @"XiangMuJieSaoPage55",
                      @"XiangMuJieSaoPage56",
                      @"XiangMuJieSaoPage57",
                      @"XiangMuJieSaoPage58",
                      @"XiangMuJieSaoPage59",
                      @"XiangMuJieSaoPage60_1",
                      @"XiangMuJieSaoPage60_2",
                      @"XiangMuJieSaoPage60_3",
                      @"XiangMuJieSaoPage60_4"];
    
    _oldPage = 0;
    scroView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:scroView];
    scroView.delegate = self;
    scroView.contentSize = CGSizeMake(self.view.frame.size.width*self.classArr.count, self.view.frame.size.height);
    scroView.bounces = NO;
    scroView.pagingEnabled = YES;
    scroView.showsHorizontalScrollIndicator = NO;
    
    //最初状态
    [self addInitialSubView];
}

#pragma mark ------delegate
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//
//}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int curPage = scrollView.contentOffset.x/scrollView.frame.size.width;
    if (curPage >_oldPage) {
        //右滑
        if (curPage>=1 && curPage<=self.classArr.count-2) {
            [self addLastPage:curPage];
        }
        if (curPage>=2 && curPage<=self.classArr.count-1) {
            [self removePrePage:curPage];
        }
        
        [self schedulePage:curPage];
        
    }else if(curPage <_oldPage) {
        //左滑
        if (curPage<=self.classArr.count-3) {
            [self removeLastPage:curPage];
        }
        if (curPage>=1&&curPage<=self.classArr.count-2) {
            [self addPrePage:curPage];
        }
        
        [self schedulePage:curPage];
        
    }else{
        //没有滑动翻页 or 滑动不彻底 没翻页
        
    }
    
    _oldPage = curPage;
    
}

//scro 一进来最初的subView
- (void)addInitialSubView
{
    [self scroViewAddSubViewWithPage:0];
    [self scroViewAddSubViewWithPage:1];
}
//当前页面出动画等操作 and 非当前页面恢复最初设置
- (void)schedulePage:(NSInteger)curPage
{
    //前 当前 后 三个View 或 在最左边最右边时只有两个View
    BaseView* preView = (BaseView*) [self getScroViewSubView:curPage-1];//前
    BaseView* curView = (BaseView*) [self getScroViewSubView:curPage];//中
    BaseView* lastView = (BaseView*) [self getScroViewSubView:curPage+1];//后
    
    NSLog(@"===============\npreView=%@\ncurView=%@\nlastView=%@\n",[preView class],[curView class],[lastView class]);
//    [preView resetAnimation];
//    [curView showAnimation];
//    [lastView resetAnimation];
}

//随机色
- (UIColor*)randomColor
{
    UIColor * randomColor= [UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0];
    return randomColor;
}
//加载前一张
- (void)addPrePage:(NSInteger)curPage
{
    NSInteger index = curPage-1;
    if (index<0) return;
    
    [self scroViewAddSubViewWithPage:index];
    
}
//加载后一张
- (void)addLastPage:(NSInteger)curPage
{
    NSInteger index = curPage+1;
    if (index>=self.classArr.count) return;
    
    [self scroViewAddSubViewWithPage:index];
}
//remove前一张
- (void)removePrePage:(NSInteger)curPage
{
    NSInteger index = curPage-2;
    if (index<0) return;
    UIView* subView = [self getScroViewSubView:index];
    [subView removeFromSuperview];
}
//remove后一张
- (void)removeLastPage:(NSInteger)curPage
{
    NSInteger index = curPage+2;
    if (index>=self.classArr.count) return;
    UIView* subView = [self getScroViewSubView:index];
    [subView removeFromSuperview];
}

//得到某一页subView
- (UIView*)getScroViewSubView:(NSInteger)page
{
    if (page<0||page>=self.classArr.count) return nil;
    
    UIView* subView = [scroView viewWithTag:page+baseTag];
    return subView;
    
}

//加载view 到 scro
- (void)scroViewAddSubViewWithPage:(NSInteger)page
{
    Class someClass = NSClassFromString(self.classArr[page]);
    BaseView* subView = [[someClass alloc] init];
    subView.tag = baseTag + page;//这个很重要  用tag来做remove
    subView.frame = CGRectMake(page*scroView.frame.size.width, 0, scroView.frame.size.width, scroView.frame.size.height);
    subView.backgroundColor = [self randomColor];
    [scroView addSubview:subView];
}
@end
