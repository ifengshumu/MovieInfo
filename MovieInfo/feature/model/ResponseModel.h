//
//  MovieModel.h
//  MovieInfo
//
//  Created by zach on 2018/10/16.
//  Copyright © 2018年 zach. All rights reserved.
//

#import <JSONModel/JSONModel.h>


@interface Image : JSONModel
@property (nonatomic, copy) NSString *small;
@property (nonatomic, copy) NSString *large;
@property (nonatomic, copy) NSString *medium;
@end

@interface Rating : JSONModel
@property (nonatomic, strong) NSNumber *average;
@end

@protocol Person
@end
@interface Person : JSONModel
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) Image *avatars;
@end

@protocol Movie
@end
@interface Movie : JSONModel
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *year;
@property (nonatomic, copy) NSArray *countries;
@property (nonatomic, copy) NSArray *genres;
@property (nonatomic, copy) NSString *pubdate;
@property (nonatomic, copy) NSArray *durations;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, copy) NSArray *photos;
@property (nonatomic, strong) Image *images;
@property (nonatomic, strong) Rating *rating;
@property (nonatomic, strong) NSMutableArray<Person> *directors;
@property (nonatomic, strong) NSMutableArray<Person> *casts;
@property (nonatomic, copy) NSString *collect_count;
@end

@protocol MusicBook
@end
@interface MusicBook : Movie
@property (nonatomic, strong) NSMutableArray<Person> *author;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, strong) NSMutableArray<Person> *tags;
@property (nonatomic, copy) NSDictionary *attrs;

@property (nonatomic, copy) NSString *origin_title;
@property (nonatomic, copy) NSArray *translator;
@property (nonatomic, copy) NSString *publisher;
@property (nonatomic, copy) NSString *pages;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *author_intro;
@end

@protocol Location
@end
@interface Location : JSONModel
@property (nonatomic, copy) NSString *parent;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *uid;
@end

@interface ResponseModel : JSONModel
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger start;
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, strong) NSMutableArray<Movie> *subjects;
@property (nonatomic, strong) NSMutableArray<MusicBook> *books;
@property (nonatomic, strong) NSMutableArray<MusicBook> *musics;
@property (nonatomic, strong) NSMutableArray<Location> *locs;
@end

