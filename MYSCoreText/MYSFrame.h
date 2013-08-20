//
//  MYSFrame.h
//  MYSCoreText
//
//  Created by Adam Kirk on 7/19/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//


@class MYSFramesetter;
@class MYSParagraph;
@class MYSWord;
@class MYSLine;
@class MYSGlyph;


@interface MYSFrame : NSObject




/**
 *	The framesetter that created this frame.
 */
@property (nonatomic, assign, readonly) MYSFramesetter *framesetter;




///------------------------------
/// Text
///------------------------------

/**
 *  The attributed string originally used to set the frame.
 */
@property (nonatomic, strong, readonly) NSAttributedString *attributedString;

/**
 *  The range of characters originally requested to fill this frame.
 */
@property (nonatomic, assign, readonly) NSRange range;

/**
 *  The range of characters that actually filled the frame.
 */
@property (nonatomic, assign, readonly) NSRange visibleRange;





///----------------------------
/// Paragraphs
///----------------------------

/**
 *	The attributed string seperated into paragraphs based on locale and other factors.
 */
@property (nonatomic, strong, readonly) NSArray *paragraphs;


/**
 *	The paragraph that contains `index`.
 *
 *	@param	index	The index that is within the paragraph you want returned.
 *
 *	@return	The paragraph that contains `index`. If `index` is not contained in any paragraph, the closest paragraph
 *          is chosen by comparing the distance of `index` to the edges of all paragraph ranges.
 */
- (MYSParagraph *)paragraphContainingIndex:(NSUInteger)index;

/**
 *	The paragraph that either contains `index` or is right before `index` if `index` is at the beginning of the paragraph.
 */
- (MYSParagraph *)paragraphBeforeIndex:(NSUInteger)index;

/**
 *	The paragraph that either contains `index` or is right before `index` if `index` is at the beginning of the word.
 */
- (MYSParagraph *)paragraphAfterIndex:(NSUInteger)index;







///----------------------------
/// Lines
///----------------------------

/**
 *  The lines generated to fill this frame. (array of MYSLine objects).
 */
@property (nonatomic, strong, readonly) NSArray *lines;

/**
 *	All the lines whose range intersects with `range`.
 *
 *	@param	range of lines.
 *
 *	@return	Returns an array of lines that intersect `range`.
 */
- (NSArray *)linesInRange:(NSRange)range;

/**
 *	Returns the line that contains `index`.
 *
 *	@param	index	The string index in the line you want.
 *
 *	@return	The line that contains `index`. Returns nil if no line contains the index.
 */
- (MYSLine *)lineContainingIndex:(NSUInteger)index;






///-----------------------------------
/// Words
///-----------------------------------

/**
 *	An array of the MYSWord objects that represent the words (according to locale) in this line.
 */
@property (nonatomic, strong, readonly) NSArray *words;

/**
 *	The word that contains `index`.
 *
 *	@param	index	The index that is within the word you want returned.
 *
 *	@return	The word that contains `index`.
 */
- (MYSWord *)wordContainingIndex:(NSUInteger)index;

/**
 *	The word that either contains `index` or is right before `index` if `index` is at the beginning of the word.
 */
- (MYSWord *)wordBeforeIndex:(NSUInteger)index;

/**
 *	The word that either contains `index` or is right after `index` if `index` is at the very end of the word.
 */
- (MYSWord *)wordAfterIndex:(NSUInteger)index;






///----------------------------
/// Glyphs
///----------------------------

/**
 *	Two glyphs could share teh same index, so this looks for the first glyph with the `index`
 *
 *	@param	index	The character index to use to map and find the glyph.
 *
 *	@return	The glyph that maps to the character at `index`.
 */
- (MYSGlyph *)glyphAtCharacterIndex:(NSUInteger)index;





///----------------------------
/// Geometry
///----------------------------

/**
 *  The path that was filled with lines during framesetting.
 */
@property (nonatomic, assign, readonly) CGPathRef path;

/**
 *  The box that tightly encloses the path.
 */
@property (nonatomic, assign, readonly) CGRect boundingBox;

/**
 *	Returns the line that contains `point` in it's bounding box.
 *
 *	@param	point	The point on the line you want returned.
 *
 *	@return	The line who's bounding box contains `point`. Returns nil if no line contains the point.
 */
- (MYSLine *)lineContainingPoint:(CGPoint)point;

/**
 *	The glyph at `point`
 *
 *	@param	point	The point, relative to frame coordinates.
 *
 *	@return	The glyph that is at `point`, relative to the frames coordinates.
 */
- (MYSGlyph *)glyphContainingPoint:(CGPoint)point;

/**
 *	The character at `point` in the frames coordinates.
 *
 *	@param	point	The point, relative to frame coordinates.
 *
 *	@return	The character index that is at `point`, relative to the frames coordinates.
 */
- (NSUInteger)characterIndexAtPoint:(CGPoint)point;

/**
 *	The point of a character at `index` in frame coordinates.
 *
 *	@param	index	The index of the character.
 *
 *	@return	The graphical point of the character at `index` in frame coordinates.
 */
- (CGPoint)pointOfCharacterAtIndex:(NSUInteger)index;

/**
 *	An array of rectangles that can be used to draw the selection of text in `range`
 *
 *	@param	range	The range of `attributedString` to calculate the rects for.
 *
 *	@return	The rectangles that enclose `range` of `attributedString`.
 */
- (NSArray *)rectsContainingRange:(NSRange)range;






///----------------------------
/// Navigating
///----------------------------

/**
 *	Returns the line above this line.
 *
 *	@param	line	The line that is directly below the line you want.
 *
 *	@return	Returns the line above. If there is no line above, it returns this line.
 */
- (MYSLine *)lineAbove:(MYSLine *)line;

/**
 *	Returns the line below this line.
 *
 *	@param	line	The line that is directly above the line you want.
 *
 *	@return	Returns the line below. If there is no line below, it returns this line.
 */
- (MYSLine *)lineBelow:(MYSLine *)line;

/**
 *	Returns the word to the left of `word`. Returns nil if there is not word to the left.
 *
 *	@param	word	The word to use as the reference to find the word to the left of it.
 *
 *	@return Returns the word to the left of `word`. Returns nil if there is no word to the left.
 */
- (MYSWord *)wordToLeft:(MYSWord *)word;

/**
 *	Returns the word to the right of `word`. Returns nil if there is not word to the right.
 *
 *	@param	word	The word to use as the reference to find the word to the right of it.
 *
 *	@return Returns the word to the right of `word`. Returns nil if there is no word to the right.
 */
- (MYSWord *)wordToRight:(MYSWord *)word;

/**
 *	Returns the character index on the line above the line that contains `index`.
 *
 *	@param	index	The index into the string.
 *
 *	@return	Returns the index graphically directly above `index`.
 */
- (NSUInteger)characterIndexAbove:(NSUInteger)index;

/**
 *	Returns the character index on the line below the line that contains `index`.
 *
 *	@param	index	The index into the string.
 *
 *	@return	Returns the index graphically directly below `index`.
 */
- (NSUInteger)characterIndexBelow:(NSUInteger)index;

/**
 *	The character index of the beginning of the line containing `index`.
 */
- (NSUInteger)indexOfBeginningOfLineContainingIndex:(NSUInteger)index;

/**
 *	The character index of the end of the line containing `index`.
 */
- (NSUInteger)indexOfEndOfLineContainingIndex:(NSUInteger)index;

/**
 *	Returns the index of `index` as a distance from the beginning of the line containing `index`
 */
- (NSUInteger)indexFromBeginningOfLineContainingIndex:(NSUInteger)index;






///----------------------------
/// Drawing
///----------------------------

/**
 *	Draws the frame into the graphics context.
 *
 *	@param	context
 *              The graphics context to draw the frame into.
 */
- (void)drawInContext:(CGContextRef)context;


@end
