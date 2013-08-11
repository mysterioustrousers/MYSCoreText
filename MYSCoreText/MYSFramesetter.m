//
//  MYSFrameSetter.m
//  MYSCoreText
//
//  Created by Adam Kirk on 7/19/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import "MYSFrame.h"
#import "MYSFramesetter.h"
#import "MYSTypesetter.h"
#import "MYSTypesetter_Private.h"
#import "MYSFrame_Private.h"
#import "MYSPrivate.h"


@interface MYSFramesetter ()
@property (nonatomic, assign           ) CTFramesetterRef framesetterRef;
@property (nonatomic, strong, readwrite) MYSTypesetter    *typesetter;
@end


@implementation MYSFramesetter

- (id)initWithAttributedString:(NSAttributedString *)attributedString
{
    self = [super init];
    if (self) {
        _attributedString   = attributedString;
        _framesetterRef     = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)(_attributedString));
    }
    return self;
}




#pragma mark - Public

- (void)setAttributedString:(NSMutableAttributedString *)attributedString
{
    MYSCFSafeRelease(_framesetterRef);
    _attributedString   = [attributedString copy];
    _framesetterRef     = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)(_attributedString));
}

- (MYSTypesetter *)typesetter
{
    @synchronized(self) {
        if (!_typesetter) {
            _typesetter = [[MYSTypesetter alloc] initWithCTTypesetter:CTFramesetterGetTypesetter(_framesetterRef)
                                                     attributedString:_attributedString];
        }
        return _typesetter;
    }
}

- (MYSFrame *)frameWithRange:(NSRange)range path:(CGPathRef)path
{
    CFRange rangeRef        = MYSCFRangeBridge(range);
    CTFrameRef frameRef     = CTFramesetterCreateFrame(_framesetterRef, rangeRef, path, NULL);
    MYSFrame *frame         = [[MYSFrame alloc] initWithCTFrame:frameRef
                                               attributedString:_attributedString];
    MYSCFSafeRelease(frameRef);
    return frame;
}

- (MYSFrame *)frameWithRect:(CGRect)rect
{
    NSRange range       = NSMakeRange(0, [_attributedString length]);
    CGPathRef pathRef   = CGPathCreateWithRect(rect, NULL);
    MYSFrame *frame     = [self frameWithRange:range path:pathRef];
    MYSCFSafeRelease(pathRef);
    return frame;
}

- (CGSize)suggestedSizeConstrainedToWidth:(CGFloat)width
{
    CGSize size = CGSizeMake(width, NSIntegerMax);
    return [self suggestedSizeConstrainedToSize:size];
}

- (CGSize)suggestedSizeConstrainedToSize:(CGSize)size
{
    NSRange range = NSMakeRange(0, [_attributedString length]);
    return [self suggestedSizeOfRange:range constrainedToSize:size];
}

- (CGSize)suggestedSizeOfRange:(NSRange)range constrainedToSize:(CGSize)size
{
    CFRange rangeRef = MYSCFRangeBridge(range);
    CFRange fitRange;
    return CTFramesetterSuggestFrameSizeWithConstraints(_framesetterRef, rangeRef, NULL, size, &fitRange);
}

- (NSRange)rangeThatFitsInFrameOfSize:(CGSize)size
{
    CFRange rangeRef    = CFRangeMake(0, [_attributedString length]);
    CFRange fitRange    = CFRangeMake(0, 0);
    CTFramesetterSuggestFrameSizeWithConstraints(_framesetterRef, rangeRef, NULL, size, &fitRange);
    return MYSNSRangeBridge(fitRange);
}

- (void)dealloc
{
    MYSCFSafeRelease(_framesetterRef);
}


@end
