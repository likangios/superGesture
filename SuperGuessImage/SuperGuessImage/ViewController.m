//
//  ViewController.m
//  SuperGuessImage
//
//  Created by 李康 on 15/8/19.
//  Copyright (c) 2015年 Luck. All rights reserved.
//

#import "ViewController.h"
#import "QuestionInfo.h"

typedef enum : NSUInteger {
    TipTag = 1,
    NextTag,
    ShortCoinTag,
} AlerTag;

@interface ViewController ()<UIAlertViewDelegate>

{
    NSMutableString *answerString;

}
/**
 *  顶部索引
 */
@property (strong, nonatomic) IBOutlet UILabel *topIndexLabel;
/**
 *  图片类型描述
 */
@property (strong, nonatomic) IBOutlet UILabel *descLabel;
/**
 *  得分
 */
@property (strong, nonatomic) IBOutlet UIButton *coinBtn;
/**
 *  中间图片按钮
 */
@property (strong, nonatomic) IBOutlet UIButton *imgInsideBtn;
/**
 *  下一题按钮
 */
@property (strong, nonatomic) IBOutlet UIButton *nextBtn;
/**
 * 显示答案按钮视图
 */
@property (strong, nonatomic) IBOutlet UIView *answerView;
/**
 *  显示备选答案视图
 */
@property (strong, nonatomic) IBOutlet UIView *optionsView;

/**
 *  模型数组
 */
@property (nonatomic,strong) NSArray *questions;

/**
 *  记录索引
 */
@property (nonatomic,assign) int index;

/**
 * 覆盖按钮
 */
@property (nonatomic,strong) UIButton *cover;


@end

@implementation ViewController
- (NSArray *)questions{
    if (nil == _questions) {
        
        _questions  = [QuestionInfo questions];
    }
    return _questions;
}
/**
 *  覆盖view
 *
 *  @return
 */
- (UIButton *)cover{
    if (nil == _cover) {
        _cover = [UIButton buttonWithType:UIButtonTypeCustom];
        _cover.frame = self.view.bounds;
        _cover.backgroundColor = [UIColor blackColor];
        [_cover addTarget:self action:@selector(imgBtnChangeOnClick:) forControlEvents:UIControlEventTouchUpInside];
        _cover.alpha = 0.0;
        [self.view addSubview:_cover];
    }
    return _cover;
}
/**
 *  提示按钮事件
 *
 *  @param sender
 */
- (IBAction)TipBtnClick:(id)sender {
    
    UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"提示" message:@"是否花费500金币来提示第一个字" delegate:self cancelButtonTitle:@"不了" otherButtonTitles:@"提示", nil];
    alert.tag = TipTag;
    [alert show];
}
/**
 *  帮助按钮事件
 *
 *  @param sender
 */
- (IBAction)helpBtnClick:(id)sender {
    
}
/**
 *  看大图及显示按钮事件
 *
 *  @param sender
 */
- (IBAction)imgBtnChangeOnClick:(id)sender {
    
    
    if (self.cover.alpha) {
//      缩小
        
    [UIView animateKeyframesWithDuration:1 delay:0.0 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
        self.imgInsideBtn.transform = CGAffineTransformIdentity;
        self.cover.alpha = 0.0;
    } completion:^(BOOL finished) {
    }];
    }else{
//     放大
        CGFloat scaleSize = self.view.frame.size.width/self.imgInsideBtn.bounds.size.width;
        CGFloat slateSize = self.view.frame.size.height/2.0-CGRectGetMidY(self.imgInsideBtn.frame);
        
        [UIView animateKeyframesWithDuration:1 delay:0.0 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
            self.imgInsideBtn.transform = CGAffineTransformScale(self.imgInsideBtn.transform, scaleSize, scaleSize);
            self.imgInsideBtn.transform = CGAffineTransformTranslate(self.imgInsideBtn.transform, 0,slateSize/2.0);
            self.cover.alpha = 0.5;
            [self.view bringSubviewToFront:self.imgInsideBtn];
        } completion:^(BOOL finished) {
        
        }];
    }
}
/**
 *  下一题按钮事件
 *
 *  @param sender 
 */
- (IBAction)nextBtnOnClick:(id)sender {
    
    NSInteger currentCoin = self.coinBtn.currentTitle.integerValue;
    if (currentCoin>=1000) {
        
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"提示" message:@"是否花费1000金币跳到下一题" delegate:self cancelButtonTitle:@"再想想" otherButtonTitles:@"跳过吧", nil];
        alert.tag = NextTag;
        [alert show];
    }else{
        
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"提示" message:@"金币不足不能跳到下一题" delegate:self cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
        alert.tag = ShortCoinTag;
        [alert show];
    }
    
}
- (void)next{
    self.index++;
    if (self.index == self.questions.count) {
        
        NSLog(@"恭喜通关");
        self.index--;
    }else{
        
        QuestionInfo *question = self.questions[self.index];
        
        [self setupBaseInfo:question];
        
        [self creatAnswerBtn:question];
        
        [self creatOptionBtns:question];
    }
    [self saveConfigWith:[NSNumber numberWithInteger:self.index] Key:@"SELFINDEX"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self readConfig];
    
    QuestionInfo *question = self.questions[self.index];
    
    [self setupBaseInfo:question];
    
    [self creatAnswerBtn:question];
    
    [self creatOptionBtns:question];
    
}
- (void)readConfig{
    id  coin = [self readConfigWithKey:@"MYCOIN"];
    if (coin) {
        NSNumber *mycoin = coin;
        [self.coinBtn setTitle:[NSString stringWithFormat:@"%d",mycoin.integerValue] forState:UIControlStateNormal];
    }
    id  index = [self readConfigWithKey:@"SELFINDEX"];
    if (index) {
        NSNumber *myindex = index;
        self.index = myindex.integerValue;
    }
}
- (void)setupBaseInfo:(QuestionInfo *)question{
    self.topIndexLabel.text = [NSString stringWithFormat:@"%d/%d",self.index+1,self.questions.count];
    self.descLabel.text = question.title;
    
    [self.imgInsideBtn setImage:question.image forState:UIControlStateNormal];
    
}
- (void)creatAnswerBtn:(QuestionInfo *)question{
    
    for (UIView *view in self.answerView.subviews) {
        if ([view isKindOfClass:[UIButton class]])
        [view removeFromSuperview];
    }
    
    NSString *answer = question.answer;
    CGFloat answerW = 30;
    CGFloat answerSpace = 10;
    
    CGFloat beginX = (self.view.frame.size.width-(answer.length*answerW+(answer.length-1)*answerSpace))/2.0;
    for (int i = 0; i<answer.length; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(beginX+i*(answerW+answerSpace),CGRectGetHeight(self.answerView.frame)/2.0-answerW/2.0, answerW, answerW);
        button.backgroundColor = [UIColor whiteColor];
        [button addTarget:self action:@selector(answerClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.answerView addSubview:button];
    }
}
- (void)creatOptionBtns:(QuestionInfo *)question{
    
    for (UIView *view in self.optionsView.subviews) {
        if ([view isKindOfClass:[UIButton class]])
            [view removeFromSuperview];
    }
    NSArray *optionanswer = question.options;
    
    CGFloat answerW = 30;
    
    CGFloat answerSpace = 10;
    
    CGFloat beginX = self.view.frame.size.width/2.0-(7*answerW+6*answerSpace)/2.0;
    
    for (int i = 0; i<optionanswer.count; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.frame = CGRectMake(beginX+i%7*(answerW+answerSpace),CGRectGetHeight(self.answerView.frame)/2.0-answerW/2.0+i/7*(answerW+answerSpace), answerW, answerW);
        button.backgroundColor = [UIColor whiteColor];
        
        [button addTarget:self action:@selector(optionAnswerClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [button setTitle:optionanswer[i] forState:UIControlStateNormal];
        
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [self.optionsView addSubview:button];
        
    }

}
/**
 *  备选答案点击
 *
 *  @param button
 */
#pragma mark 点击备选答案

- (void)optionAnswerClick:(UIButton *)optionBtn{
  
    for (UIView *view in self.answerView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)view;
            if ([[btn titleForState:UIControlStateNormal] isEqualToString:@""]||[btn titleForState:UIControlStateNormal] == nil) {
                [btn setTitle:[optionBtn titleForState:UIControlStateNormal] forState:UIControlStateNormal];
                optionBtn.hidden = YES;
                break;
            }
        }
    }
    
   BOOL  rect =  [self checkAnswer];
    
    if (rect) {
        [self coinChange:300];
        [self performSelector:@selector(next) withObject:nil afterDelay:1];
    }
}
/**
 *  答案点击
 *
 *  @param btn
 */
- (void)answerClick:(UIButton *)answerBtn{
    
    for (UIView *view in self.optionsView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)view;
            
            if ([btn.currentTitle isEqualToString:answerBtn.currentTitle]&& btn.isHidden) {
                [answerBtn setTitle:@"" forState:UIControlStateNormal];
                btn.hidden = NO;
                break;
            }
        }
        
    }
    [self checkAnswer];
}
/**
 *  检查答案是否正确
 */
- (BOOL)checkAnswer{
    
    answerString = [[NSMutableString alloc]init];
    for (UIView *view in self.answerView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)view;
            if (![[btn titleForState:UIControlStateNormal] isEqualToString:@""]&&[btn titleForState:UIControlStateNormal] != nil) {
                [answerString appendString:[btn titleForState:UIControlStateNormal]];
            }
            
        }
    }
    NSLog(@"mustr---%@",answerString);
    QuestionInfo *quest = self.questions[self.index];
    if ([answerString isEqualToString:quest.answer]) {
        [self setAnswerTitleColor:[UIColor greenColor]];
        return YES;
    }else if(answerString.length == quest.answer.length){
        [self setAnswerTitleColor:[UIColor redColor]];
        return NO;
    }else{
        [self setAnswerTitleColor:[UIColor blackColor]];
        return NO;
    }
    return NO;
}
#pragma mark -- 数量变化
- (void)coinChange:(NSInteger)delCoin{
    
    NSInteger current = [self.coinBtn.currentTitle integerValue];
    current += delCoin;
    NSString *coinStr = [NSString stringWithFormat:@"%d",current];
    [self.coinBtn setTitle:coinStr forState:UIControlStateDisabled];
    
    [self saveConfigWith:[NSNumber numberWithInteger:current] Key:@"MYCOIN"];
}
- (void)setAnswerTitleColor:(UIColor *)color{
    for (UIView *view in self.answerView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)view;
            [btn setTitleColor:color forState:UIControlStateNormal];
        }
    }

}
- (void)tipFirstChar{
    
    [self coinChange:-500];
    
    QuestionInfo *quest = self.questions[self.index];
    NSString *firstAnswer = [quest.answer substringToIndex:1];
    BOOL  rect = NO;
    for (UIView *view in self.answerView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)view;
            [btn setTitle:@"" forState:UIControlStateNormal];
            if (!rect) {
                [btn setTitle:firstAnswer forState:UIControlStateNormal];
                rect = YES;
            }
        }
    }
}
#pragma mark UIAlertDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"buttonIndex %d",buttonIndex);
    
    switch (alertView.tag) {
        case TipTag:
            if (buttonIndex == 1) {
                [self tipFirstChar];
                
            }
            break;
        case NextTag:
        {
            if (buttonIndex == 1) {
                [self coinChange:-1000];
                [self next];
                
            }
        }
            break;
        case ShortCoinTag:
            
            break;
        default:
            break;
    }
}
- (void)saveConfigWith:(id)content Key:(NSString *)key{
    NSUserDefaults *defautl = [NSUserDefaults standardUserDefaults];
    [defautl setValue:content forKey:key];
    [defautl synchronize];
}
- (id)readConfigWithKey:(NSString *)key{
    NSUserDefaults *defautl = [NSUserDefaults standardUserDefaults];
    return [defautl objectForKey:key];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
