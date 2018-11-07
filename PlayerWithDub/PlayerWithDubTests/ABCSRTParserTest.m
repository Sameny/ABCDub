//
//  ABCSRTParserTest.m
//  PlayerWithDubTests
//
//  Created by 泽泰 舒 on 2018/11/2.
//  Copyright © 2018年 泽泰 舒. All rights reserved.
//

#import "ABCSRTParser.h"
#import <XCTest/XCTest.h>

@interface ABCSRTParserTest : XCTestCase

@end

@implementation ABCSRTParserTest

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;

    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];

    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    [self testParser];
}

- (void)testsssss{
    int i = rand()/4;
    XCTAssert(i > 0, @"my test equal 0");
}

- (void)testParser {
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

@end
