//
//  QuestionInfo.h
//  SuperGuessImage
//
//  Created by 李康 on 15/8/19.
//  Copyright (c) 2015年 Luck. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QuestionInfo : NSObject
@property (nonatomic,copy) NSString *answer;
@property (nonatomic,copy) NSString *icon;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,strong) NSArray *options;

@property (nonatomic,strong) UIImage *image;



- (instancetype)initWithDic:(NSDictionary *)dic;

+ (instancetype)questionWithDic:(NSDictionary *)dic;

+ (NSArray *)questions;

@end
