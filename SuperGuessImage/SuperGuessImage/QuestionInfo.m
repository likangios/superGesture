//
//  QuestionInfo.m
//  SuperGuessImage
//
//  Created by 李康 on 15/8/19.
//  Copyright (c) 2015年 Luck. All rights reserved.
//

#import "QuestionInfo.h"

@implementation QuestionInfo
- (instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
    
}
+(instancetype)questionWithDic:(NSDictionary *)dic{

    return [[self alloc]initWithDic:dic];
}

+(NSArray *)questions{

    NSString *path = [[NSBundle mainBundle]pathForResource:@"questions" ofType:@"plist"];
    
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    
    NSMutableArray *arrm = [NSMutableArray array];
    
    for (NSDictionary *dic in array) {
        [arrm addObject:[self questionWithDic:dic]];
    }
    return arrm;
}
-(UIImage *)image{
    
    if (!_image) {
        _image = [UIImage imageNamed:self.icon];
    }
    return _image;
}
@end
