//
//  MYSFrame.m
//  MYSCoreText
//
//  Created by Adam Kirk on 7/19/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//


#import "MYSFrame.h"
#import "MYSLine.h"
#import "MYSLine_Private.h"
#import "MYSPrivate.h"


@interface MYSFrame ()
@property (nonatomic, assign           ) CTFrameRef         frameRef;
@property (nonatomic, strong, readwrite) NSArray            *lines;
@property (nonatomic, strong, readwrite) NSAttributedString *attributedString;
@end


@implementation MYSFrame



#pragma mark - Working With Strings

- (NSAttributedString *)attributedString
{
    NSRange range = MYSNSRangeBridge(CTFrameGetStringRange(_frameRef));
    return [_attributedString attributedSubstringFromRange:range];
}

- (NSRange)range
{
    CFRange range = CTFrameGetStringRange(_frameRef);
    return MYSNSRangeBridge(range);
}

- (NSRange)visibleRange
{
    CFRange range = CTFrameGetVisibleStringRange(_frameRef);
    return MYSNSRangeBridge(range);
}




#pragma mark - Lines

- (NSArray *)lines
{
    @synchronized(self) {
        if (!_lines) {
            NSMutableArray *lines   = [NSMutableArray new];
            CFArrayRef lineRefs     = CTFrameGetLines(_frameRef);
            NSInteger lineCount     = CFArrayGetCount(lineRefs);
            CGPoint *origins        = malloc(sizeof(CGPoint) * lineCount);
            CTFrameGetLineOrigins(_frameRef, CFRangeMake(0, lineCount - 1), origins);
            for (CFIndex i = 0; i < CFArrayGetCount(lineRefs); i++) {
                CTLineRef lineRef   = CFArrayGetValueAtIndex(lineRefs, i);
                MYSLine *line       = [[MYSLine alloc] initWithCTLine:lineRef
                                                     attributedString:_attributedString];
                CGPoint origin      = origins[i];
                line.origin         = MYSConvertPointFromRect(origin, self.boundingBox);
                [lines addObject:line];
            }
            _lines = lines;
        }
        return _lines;
    }
}




#pragma mark - Geometry

- (CGPathRef)path
{
    return CTFrameGetPath(_frameRef);
}

- (CGRect)boundingBox
{
    return CGPathGetBoundingBox(self.path);
}




#pragma mark - Drawing

- (void)drawInContext:(CGContextRef)context
{
    CTFrameDraw(_frameRef, context);
}




#pragma mark - Private

- (id)initWithCTFrame:(CTFrameRef)frameRef attributedString:(NSAttributedString *)attributedString
{
    self = [super init];
    if (self) {
        _frameRef           = MYSCFSafeRetain(frameRef);
        _attributedString   = attributedString;
    }
    return self;
}

- (void)dealloc
{
    MYSCFSafeRelease(_frameRef);
}


@end
