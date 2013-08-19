//
//  MYSTypesetter.m
//  MYSCoreText
//
//  Created by Adam Kirk on 8/1/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import "MYSTypesetter_Private.h"
#import "MYSLine_Private.h"
#import "MYSPrivate.h"


@interface MYSTypesetter ()
@property (nonatomic, assign) CTTypesetterRef typesetterRef;
@end


@implementation MYSTypesetter



#pragma mark - Creating Typesetters

- (id)initWithAttributedString:(NSAttributedString *)attributedString
{
    self = [super init];
    if (self) {
        _attributedString   = attributedString;
        _typesetterRef      = CTTypesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attributedString);
    }
    return self;
}





#pragma mark - Creating Lines

- (MYSLine *)lineWithRange:(NSRange)range
{
    CFRange rangeRef    = MYSCFRangeBridge(range);
    CTLineRef lineRef   = CTTypesetterCreateLine(_typesetterRef, rangeRef);
    MYSLine *line       = [[MYSLine alloc] initWithCTLine:lineRef
                                         attributedString:_attributedString];
    MYSCFSafeRelease(lineRef);
    return line;
}

- (MYSLine *)lineWithRange:(NSRange)range offset:(CGFloat)offset
{
    CFRange rangeRef    = MYSCFRangeBridge(range);
    CTLineRef lineRef   = CTTypesetterCreateLineWithOffset(_typesetterRef, rangeRef, offset);
    MYSLine *line       = [[MYSLine alloc] initWithCTLine:lineRef
                                         attributedString:_attributedString];
    MYSCFSafeRelease(lineRef);
    return line;
}




#pragma mark - Breaking Lines

- (NSInteger)suggestedLineBreakIndexWithStartIndex:(NSInteger)startIndex width:(CGFloat)width
{
    return CTTypesetterSuggestLineBreak(_typesetterRef, startIndex, width);
}

- (NSInteger)suggestedLineBreakIndexWithStartIndex:(NSInteger)startIndex width:(CGFloat)width offset:(CGFloat)offset
{
    return CTTypesetterSuggestLineBreakWithOffset(_typesetterRef, startIndex, width, offset);
}

- (NSInteger)suggestedClusterBreakIndexWithStartIndex:(NSInteger)startIndex width:(CGFloat)width
{
    return CTTypesetterSuggestClusterBreak(_typesetterRef, startIndex, width);
}

- (NSInteger)suggestedClusterBreakIndexWithStartIndex:(NSInteger)startIndex width:(CGFloat)width offset:(CGFloat)offset
{
    return CTTypesetterSuggestClusterBreakWithOffset(_typesetterRef, startIndex, width, offset);
}




#pragma mark - Private

- (id)initWithCTTypesetter:(CTTypesetterRef)typesetterRef attributedString:(NSAttributedString *)attributedString
{
    self = [super init];
    if (self) {
        _attributedString   = attributedString;
        _typesetterRef      = MYSCFSafeRetain(typesetterRef);
    }
    return self;
}

- (void)dealloc
{
    MYSCFSafeRelease(_typesetterRef);
}


@end
