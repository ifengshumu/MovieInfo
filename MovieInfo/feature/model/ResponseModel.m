//
//  MovieModel.m
//  MovieInfo
//
//  Created by zach on 2018/10/16.
//  Copyright © 2018年 zach. All rights reserved.
//

#import "ResponseModel.h"

@implementation Image
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end

@implementation Rating
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end

@implementation Person
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end

@implementation Movie
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end

@implementation MusicBook
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end

@implementation Location
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end

@implementation ResponseModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
@end
