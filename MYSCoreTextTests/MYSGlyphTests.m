//
//  MYSGlyphTests.m
//  MYSCoreText
//
//  Created by Adam Kirk on 8/10/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MYSCoreText.h"


@interface MYSGlyphTests : XCTestCase
@property (nonatomic, strong) MYSFramesetter *framesetter;
@property (nonatomic, strong) MYSFrame       *frame;
@property (nonatomic, strong) MYSLine        *line;
@property (nonatomic, strong) MYSRun         *glyphRun;
@property (nonatomic, strong) MYSGlyph       *glyph;
@end


@implementation MYSGlyphTests

- (void)setUp
{
    [super setUp];
    NSString *string = (@"A long string of text to test on this with some really long strings of text"
                        @"that wrap and also some hard \nline breaks that will generate lines for us "
                        @"in a frame");
    NSAttributedString *attributedString    = [[NSAttributedString alloc] initWithString:string];
    _framesetter    = [[MYSFramesetter alloc] initWithAttributedString:attributedString];
    _frame          = [_framesetter frameWithRect:CGRectMake(10, 0, 100, 100)];
    _line           = _frame.lines[0];
    _glyphRun       = _line.runs[0];
    _glyph          = _glyphRun.glyphs[2];
}




#pragma mark - Working With Strings

- (void)testGlyphCreation
{
    XCTAssertNotNil(_glyph);
}

- (void)testAttributedString
{
    XCTAssertNotNil(_glyph.attributedString);
    XCTAssertTrue([_glyph.attributedString length] == 1);
    NSAttributedString *as = [[NSAttributedString alloc] initWithString:@"l"];
    XCTAssertEqualObjects(_glyph.attributedString, as);
}

- (void)testAttributes
{
    XCTAssertNotNil(_glyph.attributes);
}

- (void)testIndex
{
    XCTAssertTrue(_glyph.index == 2);
}




#pragma mark - Getting Geometry

- (void)testPosition
{
    CGPoint p = _glyph.position;
    XCTAssertEqualWithAccuracy(p.x, 10.681, 0.01);
    XCTAssertEqualWithAccuracy(p.y, 0, 0.01);
}

- (void)testBoundingBox
{
    CGRect bb = _glyph.boundingBox;
    XCTAssertEqualWithAccuracy(bb.origin.x, 10.68, 0.01);
    XCTAssertEqualWithAccuracy(bb.origin.y, 85.24, 0.01);
    XCTAssertEqualWithAccuracy(bb.size.width, 2.666, 0.01);
    XCTAssertEqualWithAccuracy(bb.size.height, 14.759, 0.01);
}

- (void)testPath
{
    CGPathRef path = [_glyph createPathOfGlyph];
    CGRect bb = CGPathGetPathBoundingBox(path);
    XCTAssertEqualWithAccuracy(bb.origin.x, 1.058, 0.01);
    XCTAssertEqualWithAccuracy(bb.origin.y, 0, 0.01);
    XCTAssertEqualWithAccuracy(bb.size.width, 1.058, 0.01);
    XCTAssertEqualWithAccuracy(bb.size.height, 8.480, 0.01);
}

- (void)testAdvance
{
    CGSize s = _glyph.advance;
    XCTAssertEqualWithAccuracy(s.width, 2.666, 0.01);
    XCTAssertEqualWithAccuracy(s.height, 0, 0.01);
}




#pragma mark - Getting Glyph Information

- (void)testCharacterCollection
{
    NSCharacterCollection characterCollection = _glyph.characterCollection;
    XCTAssertTrue(characterCollection == NSIdentityMappingCharacterCollection);
}

- (void)testCTGlyphInfoRef
{
    CTGlyphInfoRef glyphInfo = _glyph.CTGlyphInfo;
    XCTAssertTrue(glyphInfo != NULL);
}

- (void)testCGGlyph
{
    CGGlyph glyph = _glyph.CGGlyph;
    XCTAssertTrue(glyph == 79);
}



@end
