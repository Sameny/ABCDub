//
//  PlayerWithDubTests.m
//  PlayerWithDubTests
//
//  Created by 泽泰 舒 on 2018/10/30.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "ABCSRTParser.h"
#import <XCTest/XCTest.h>

@interface PlayerWithDubTests : XCTestCase

@end

@implementation PlayerWithDubTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    XCTAssert(YES, @"test");
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"幻想中的无敌神鹰" ofType:@"srt"];
    NSLog(@"开始解析srt文件");
    [ABCSRTParser parserWithFilePath:filePath completion:^(NSArray<ABCCaptionSegment *> * _Nonnull captions, NSError * _Nullable error) {
        if (error) {
            XCTFail(@"解析srt文件出错");
        }
        else {
            NSLog(@"完成解析srt文件");
        }
    }];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
