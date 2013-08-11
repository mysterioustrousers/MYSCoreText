//
//  MYSTypesetterTests.m
//  MYSCoreText
//
//  Created by Adam Kirk on 8/6/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MYSCoreText.h"


@interface MYSTypesetterTests : XCTestCase
@property (nonatomic, strong) NSAttributedString *attributedString;
@property (nonatomic, strong) MYSTypesetter      *typsetter;
@end


@implementation MYSTypesetterTests

- (void)setUp
{
    [super setUp];
    NSString *string = (@"A long string of text to test on this with some really long strings of text"
                        @"that wrap and also some hard \nline breaks that will generate lines for us "
                        @"in a frame");
    _attributedString   = [[NSAttributedString alloc] initWithString:string];
    _typsetter          = [[MYSTypesetter alloc] initWithAttributedString:_attributedString];
}

- (void)testCreateTypesetter
{
    XCTAssertNotNil(_typsetter);
    XCTAssertNotNil(_typsetter.attributedString);
}

- (void)testCreateTypesetterFromFramesetter
{
    MYSFramesetter *framesetter     = [[MYSFramesetter alloc] initWithAttributedString:_attributedString];
    MYSTypesetter *typesetter       = framesetter.typesetter;
    XCTAssertNotNil(typesetter);
}

- (void)testCreateLineWithRange
{
    NSRange range = NSMakeRange(0, [_attributedString length]);
    MYSLine *line = [_typsetter lineWithRange:range];
    XCTAssertNotNil(line);
}

- (void)testCreateLineWithRangeOffset
{
    NSRange range = NSMakeRange(0, [_attributedString length]);
    MYSLine *line = [_typsetter lineWithRange:range offset:20];
    XCTAssertNotNil(line);
}

- (void)testSuggestedLineBreakIndexWithStartIndexWidth
{
    NSInteger index = [_typsetter suggestedLineBreakIndexWithStartIndex:0 width:100];
    XCTAssertTrue(index == 17);
}

- (void)testSuggestedLineBreakIndexWithStartIndexWidthOffset
{
    NSInteger index = [_typsetter suggestedLineBreakIndexWithStartIndex:0 width:100 offset:45];
    XCTAssertTrue(index == 17);
}

- (void)testSuggestedClusterBreakIndexWithStartIndexWidth
{
    NSInteger index = [_typsetter suggestedClusterBreakIndexWithStartIndex:0 width:100];
    XCTAssertTrue(index == 20);
}

- (void)testSuggestedClusterBreakIndexWithStartIndexWidthOffset
{
    NSInteger index = [_typsetter suggestedClusterBreakIndexWithStartIndex:0 width:100 offset:45];
    XCTAssertTrue(index == 20);
}




@end
