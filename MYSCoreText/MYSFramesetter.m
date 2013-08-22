//
//  MYSFrameSetter.m
//  MYSCoreText
//
//  Created by Adam Kirk on 7/19/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import "MYSFramesetter.h"
#import "MYSFrame_Private.h"
#import "MYSTypesetter_Private.h"
#import "MYSFrame_Private.h"
#import "MYSPrivate.h"


@interface MYSFramesetter ()
@property (nonatomic, assign           ) CTFramesetterRef framesetterRef;
@property (nonatomic, strong, readwrite) MYSTypesetter    *typesetter;
@end


@implementation MYSFramesetter



#pragma mark - Creating A Framesetter

- (id)initWithAttributedString:(NSAttributedString *)attributedString
{
    self = [super init];
    if (self) {
        self.attributedString = attributedString;
    }
    return self;
}




#pragma mark - Public

- (void)setAttributedString:(NSMutableAttributedString *)attributedString
{
    MYSCFSafeRelease(_framesetterRef);

    _attributedString   = attributedString;
    _framesetterRef     = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)(_attributedString));
}

- (MYSTypesetter *)typesetter
{
    @synchronized(self) {
        if (!_typesetter) {
            _typesetter = [[MYSTypesetter alloc] initWithCTTypesetter:CTFramesetterGetTypesetter(_framesetterRef)
                                                     attributedString:_attributedString];
            _typesetter.framesetter = self;
        }
        return _typesetter;
    }
}




#pragma mark - Creating Frames

- (MYSFrame *)frameWithRange:(NSRange)range path:(CGPathRef)path
{
    CFRange rangeRef        = MYSCFRangeBridge(range);
    CTFrameRef frameRef     = CTFramesetterCreateFrame(_framesetterRef, rangeRef, path, NULL);
    MYSFrame *frame         = [[MYSFrame alloc] initWithCTFrame:frameRef
                                               attributedString:_attributedString];
    frame.framesetter       = self;
    MYSCFSafeRelease(frameRef);
    return frame;
}

- (MYSFrame *)frameWithRect:(CGRect)rect
{
    NSRange range       = NSMakeRange(0, [_attributedString length]);
    CGPathRef pathRef   = CGPathCreateWithRect(rect, NULL);
    MYSFrame *frame     = [self frameWithRange:range path:pathRef];
    frame.framesetter   = self;
    MYSCFSafeRelease(pathRef);
    return frame;
}




#pragma mark - Geometry

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




#pragma mark - Private

- (void)dealloc
{
    MYSCFSafeRelease(_framesetterRef);
}

- (NSString *)description
{
    return [_attributedString string];
}


@end
