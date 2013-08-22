//
//  MYSFrame.m
//  MYSCoreText
//
//  Created by Adam Kirk on 7/19/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//

#import "MYSFramesetter.h"
#import "MYSFrame_Private.h"
#import "MYSParagraph_Private.h"
#import "MYSRun_Private.h"
#import "MYSLine_Private.h"
#import "MYSWord_Private.h"
#import "MYSGlyph_Private.h"
#import "MYSPrivate.h"


@interface MYSFrame ()
@property (nonatomic, assign           ) CTFrameRef         frameRef;
@property (nonatomic, strong, readwrite) NSArray            *lines;
@property (nonatomic, strong, readwrite) NSArray            *paragraphs;
@property (nonatomic, strong, readwrite) NSArray            *words;
@property (nonatomic, strong, readwrite) NSAttributedString *attributedString;
@end


@implementation MYSFrame




#pragma mark - Text

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




#pragma mark - Paragraphs

- (NSArray *)paragraphs
{
    @synchronized(self) {
        if (!_paragraphs) {
            _paragraphs = [NSMutableArray new];
            [[_attributedString string] enumerateSubstringsInRange:self.range
                                                           options:(NSStringEnumerationByParagraphs |
                                                                    NSStringEnumerationLocalized |
                                                                    NSStringEnumerationSubstringNotRequired)
                                                        usingBlock:^(NSString *substring,
                                                                     NSRange substringRange,
                                                                     NSRange enclosingRange,
                                                                     BOOL *stop)
             {
                 MYSParagraph *paragraph = [[MYSParagraph alloc] initWithAttributedString:_attributedString range:substringRange];
                 [(NSMutableArray *)_paragraphs addObject:paragraph];
             }];
        }
        return _paragraphs;
    }
}

- (MYSParagraph *)paragraphContainingIndex:(NSUInteger)index
{
    for (MYSParagraph *paragraph in self.paragraphs) {
        if (MYSNSRangeContainsIndex(paragraph.range, index)) {
            return paragraph;
        }
    }

    MYSParagraph *closest = [self.paragraphs lastObject];
    for (MYSParagraph *paragraph in self.paragraphs) {
        if (MYSIndexDistanceToRange(index, paragraph.range) < MYSIndexDistanceToRange(index, closest.range)) {
            closest = paragraph;
        }
    }

    return closest;
}

- (MYSParagraph *)paragraphBeforeIndex:(NSUInteger)index
{
    MYSParagraph *candidate = [self.paragraphs count] > 0 ? self.paragraphs[0] : nil;
    for (MYSParagraph *paragraph in self.paragraphs) {
        if (MYSNSRangeStartIndex(paragraph.range) < index &&
            MYSIndexDistanceToRange(index, paragraph.range) < MYSIndexDistanceToRange(index, candidate.range))
        {
            candidate = paragraph;
        }
    }
    return candidate;
}

- (MYSParagraph *)paragraphAfterIndex:(NSUInteger)index
{
    MYSParagraph *candidate = [self.paragraphs lastObject];
    for (MYSParagraph *paragraph in self.paragraphs) {
        if (MYSNSRangeEndIndex(paragraph.range) > index &&
            MYSIndexDistanceToRange(index, paragraph.range) < MYSIndexDistanceToRange(index, candidate.range))
        {
            candidate = paragraph;
        }
    }
    return candidate;
}





#pragma mark - Lines

- (NSArray *)lines
{
    @synchronized(self) {
        if (!_lines) {
            _lines                  = [NSMutableArray new];
            CFArrayRef lineRefs     = CTFrameGetLines(_frameRef);
            NSInteger lineCount     = CFArrayGetCount(lineRefs);
            CGPoint origins[lineCount];
            CTFrameGetLineOrigins(_frameRef, CFRangeMake(0, lineCount), origins);
            for (CFIndex i = 0; i < CFArrayGetCount(lineRefs); i++) {
                CTLineRef lineRef   = CFArrayGetValueAtIndex(lineRefs, i);
                MYSLine *line       = [[MYSLine alloc] initWithCTLine:lineRef
                                                     attributedString:_attributedString];
                CGPoint origin      = origins[i];
                line.origin         = origin;
                line.frame          = self;
                [(NSMutableArray *)_lines addObject:line];
            }
        }
        return _lines;
    }
}

- (NSArray *)linesInRange:(NSRange)range
{
    NSMutableArray *lines = [NSMutableArray new];
    for (MYSLine *line in self.lines) {
        // if this line's range intersects `range` at all.
        if (NSIntersectionRange(line.range, range).length != 0) {
            [lines addObject:line];
        }
    }
    return lines;
}


- (MYSLine *)lineContainingIndex:(NSUInteger)index
{
    for (MYSLine *line in self.lines) {
        if (MYSNSRangeContainsIndex(line.range, index)) {
            return line;
        }
    }
    if (index == [_attributedString length]) {
        return [self.lines lastObject];
    }
    return nil;
}




#pragma mark - Words

- (NSArray *)words
{
    @synchronized(self) {
        if (!_words) {
            _words = [NSMutableArray new];
            [[_attributedString string] enumerateSubstringsInRange:self.range
                                                               options:(NSStringEnumerationByWords |
                                                                        NSStringEnumerationLocalized |
                                                                        NSStringEnumerationSubstringNotRequired)
                                                            usingBlock:^(NSString *substring,
                                                                         NSRange substringRange,
                                                                         NSRange enclosingRange,
                                                                         BOOL *stop)
             {
                 MYSWord *word = [[MYSWord alloc] initWithAttributedString:_attributedString range:substringRange];
                 [(NSMutableArray *)_words addObject:word];
             }];
        }
        return _words;
    }
}

- (MYSWord *)wordContainingIndex:(NSUInteger)index
{
    for (MYSWord *word in self.words) {
        if (MYSNSRangeContainsIndex(word.range, index)) {
            return word;
        }
    }

    MYSWord *closest = [self.words lastObject];
    for (MYSWord *word in self.words) {
        if (MYSIndexDistanceToRange(index, word.range) < MYSIndexDistanceToRange(index, closest.range)) {
            closest = word;
        }
    }

    return closest;
}


- (MYSWord *)wordBeforeIndex:(NSUInteger)index
{
    MYSWord *candidate = [self.words count] > 0 ? self.words[0] : nil;
    for (MYSWord *word in self.words) {
        if (MYSNSRangeStartIndex(word.range) < index &&
            MYSIndexDistanceToRange(index, word.range) < MYSIndexDistanceToRange(index, candidate.range))
        {
            candidate = word;
        }
    }
    return candidate;
}

- (MYSWord *)wordAfterIndex:(NSUInteger)index
{
    MYSWord *candidate = [self.words lastObject];
    for (MYSWord *word in self.words) {
        if (MYSNSRangeEndIndex(word.range) > index &&
            MYSIndexDistanceToRange(index, word.range) < MYSIndexDistanceToRange(index, candidate.range))
        {
            candidate = word;
        }
    }
    return candidate;
}





#pragma mark - Glyphs

- (MYSGlyph *)glyphAtCharacterIndex:(NSUInteger)index
{
    for (MYSLine *line in self.lines) {
        if (MYSNSRangeContainsIndex(line.range, index)) {
            return [line glyphAtCharacterIndex:index];
        }
    }
    return nil;
}




#pragma mark - Geometry

- (CGPathRef)path
{
    return CTFrameGetPath(_frameRef);
}

- (CGRect)boundingBox
{
    CGRect boundingBox = CGRectZero;
    for (MYSLine *line in self.lines) {
        boundingBox = CGRectUnion(boundingBox, line.boundingBox);
    }
    return boundingBox;
}

- (MYSLine *)lineContainingPoint:(CGPoint)point
{
    point = MYSPointDefinitelyInsideRect(point, self.boundingBox);
    for (MYSLine *line in self.lines) {
        CGRect r = CGRectInset(line.boundingBox, -1, -1);
        r.size.width = self.boundingBox.size.width + 2;
        if (CGRectContainsPoint(r, point)) {
            return line;
        }
    }
    return nil;
}

- (MYSGlyph *)glyphContainingPoint:(CGPoint)point
{
    point = MYSPointDefinitelyInsideRect(point, self.boundingBox);
    MYSLine *line = [self lineContainingPoint:point];
    for (MYSGlyph *glyph in line.glyphs) {
        if (CGRectContainsPoint(glyph.boundingBox, point)) {
            return glyph;
        }
    }
    return nil;
}

- (NSUInteger)characterIndexAtPoint:(CGPoint)point
{
    point = MYSPointDefinitelyInsideRect(point, self.boundingBox);
    MYSLine *line = [self lineContainingPoint:point];
    NSUInteger index = [line characterIndexAtPoint:point];
    // to make sure the point is within a line, there is a buffer, which causes indexes to
    // be off by one when a period at the end of the whole string is involved.
    if (index == [_attributedString length] - 1 &&
        [[_attributedString string] characterAtIndex:index] == '.') {
        index++;
    }
    return index;
}

- (CGPoint)pointOfCharacterAtIndex:(NSUInteger)index
{
    MYSLine *line = [self lineContainingIndex:index];
    CGFloat offset = [line offsetOfCharacterAtIndex:index];
    return CGPointMake(offset, line.origin.y);
}

- (NSArray *)rectsContainingRange:(NSRange)range
{
    if (range.location == NSNotFound) return nil;

    NSMutableArray *rects = [NSMutableArray new];
    for (MYSLine *line in self.lines) {

        // starts and ends on this line
        if (NSEqualRanges(NSUnionRange(line.range, range), line.range))
        {
            CGRect r        = line.boundingBox;
            r.origin.x      = [line offsetOfCharacterAtIndex:MYSNSRangeStartIndex(range)];
            r.size.width    = [line offsetOfCharacterAtIndex:MYSNSRangeEndIndex(range) + 1] - r.origin.x;
            [rects addObject:[NSValue valueWithRect:r]];
            return rects;
        }

        // starts on this line
        if (MYSNSRangeContainsIndex(line.range, MYSNSRangeStartIndex(range))) {
            CGRect r        = line.boundingBox;
            r.origin.x      = [line offsetOfCharacterAtIndex:MYSNSRangeStartIndex(range)];
            r.size.width    = self.boundingBox.size.width - r.origin.x;
            [rects addObject:[NSValue valueWithRect:r]];
            continue;
        }

        // if entirely contains this line
        if (NSEqualRanges(NSUnionRange(line.range, range), range))
        {
            CGRect r    = line.boundingBox;
            r.origin.x  = 0;

            // if the string ends on this line, only span to the end of the string
            if (NSMaxRange(line.range) == [_attributedString length]) {
                r.size.width = [line offsetOfCharacterAtIndex:NSMaxRange(range)];
            }
            // otherwise, the string starts and ends on a line other than this one.
            else {
                r.size.width = self.boundingBox.size.width;
            }

            [rects addObject:[NSValue valueWithRect:r]];
            continue;
        }

        // if ends on this line
        if (MYSNSRangeContainsIndex(line.range, MYSNSRangeEndIndex(range))) {
            CGRect r        = line.boundingBox;
            r.origin.x      = 0;
            r.size.width    = [line offsetOfCharacterAtIndex:MYSNSRangeEndIndex(range) + 1];
            [rects addObject:[NSValue valueWithRect:r]];
            return rects;
        }
    }
    return rects;
}






#pragma mark - Navigating

- (MYSLine *)lineAbove:(MYSLine *)line
{
    NSInteger index = [self.lines indexOfObject:line];
    if (index > 0 && index != NSNotFound) {
        return [self.lines objectAtIndex:index - 1];
    }
    return nil;
}

- (MYSLine *)lineBelow:(MYSLine *)line
{
    NSInteger index = [self.lines indexOfObject:line];
    if (index < ([self.lines count] - 1) && index != NSNotFound) {
        return [self.lines objectAtIndex:index + 1];
    }
    return nil;
}

- (MYSWord *)wordToLeft:(MYSWord *)word
{
    NSUInteger index = [self.words indexOfObject:word];
    if (index > 0 && index != NSNotFound) {
        return [self.words objectAtIndex:index + 1];
    }
    return nil;
}

- (MYSWord *)wordToRight:(MYSWord *)word
{
    NSUInteger index = [self.words indexOfObject:word];
    if (index < ([self.words count] - 1) && index != NSNotFound) {
        return [self.words objectAtIndex:index + 1];
    }
    return nil;
}

- (NSUInteger)characterIndexAbove:(NSUInteger)index
{
    MYSLine *line       = [self lineContainingIndex:index];
    CGFloat offset      = [line offsetOfCharacterAtIndex:index];
    MYSLine *above      = [self lineAbove:line];
    if (above) {
        return [above characterIndexAtPoint:CGPointMake(offset, 0)];
    }
    else {
        return index;
    }
}

- (NSUInteger)characterIndexBelow:(NSUInteger)index
{
    MYSLine *line       = [self lineContainingIndex:index];
    CGFloat offset      = [line offsetOfCharacterAtIndex:index];
    MYSLine *below      = [self lineBelow:line];
    if (below) {
        return [below characterIndexAtPoint:CGPointMake(offset, 0)];
    }
    else {
        return index;
    }
}

- (NSUInteger)indexOfBeginningOfLineContainingIndex:(NSUInteger)index
{
    MYSLine *line = [self lineContainingIndex:index];
    return line.range.location;
}

- (NSUInteger)indexOfEndOfLineContainingIndex:(NSUInteger)index
{
    MYSLine *line = [self lineContainingIndex:index];
    NSRange range = line.range;
    if (NSMaxRange(range) == [_attributedString length]) {
        return NSMaxRange(range);
    }
    else {
        return NSMaxRange(range) - 1;
    }
}


- (NSUInteger)indexFromBeginningOfLineContainingIndex:(NSUInteger)index;
{
    MYSLine *line = [self lineContainingIndex:index];
    return index - [line indexOfFirstCharacter];
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

- (NSString *)description
{
    NSMutableString *desc = [NSMutableString new];
    [desc appendString:[super description]];
    [desc appendString:@"\n"];
    [desc appendFormat:@"contents: %@", [[_attributedString string] substringWithRange:self.range]];
    [desc appendString:@"\n"];
    [desc appendFormat:@"range: %@", NSStringFromRange(self.range)];
    [desc appendString:@"\n"];
    [desc appendFormat:@"boundingBox: %@", NSStringFromRect(self.boundingBox)];
    return desc;
}



@end
