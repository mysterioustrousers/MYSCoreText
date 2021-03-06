//
//  MYSLine.h
//  MYSCoreText
//
//  Created by Adam Kirk on 7/19/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//


@class MYSFrame;
@class MYSRun;
@class MYSWord;
@class MYSGlyph;


@interface MYSLine : NSObject


/**
 *	The frame that created this line if it was created by a frame, otherwise nil.
 */
@property (nonatomic, assign, readonly) MYSFrame *frame;



///----------------------------------
/// Creating Lines
///----------------------------------

/**
*   Creates a stand along line that is not part of a frame.
*
*	@param	attributedString
*               An attributed string to create this line with.
*
*	@return An initiated line with `attributedString` as it's contents.
*/
- (id)initWithAttributedString:(NSAttributedString *)attributedString;

/**
 *	Returns a new copy of the line truncated.
 *
 *	@param  width
 *              The width to truncate the line to.
 *  @param  truncationType
 *              The method to use when truncating the line.
 *
 *
 *	@return A new line that is truncated to `width` using `truncationType` method.
 */
- (MYSLine *)newTruncatedLineToWidth:(CGFloat)width truncationType:(CTLineTruncationType)truncationType;

/**
 *	Returns a new copy of the line that is justified.
 *
 *	@param	width	
 *              The width to justify the line to.
 *
 *	@return	A new line that is justified to `width`.
 */
- (MYSLine *)newJustifiedLineToWidth:(CGFloat)width;




///----------------------------------
/// Text
///----------------------------------

/**
 *  The attributed string used to generate the line.
 */
@property (nonatomic, copy, readonly) NSAttributedString *attributedString;

/**
 *	The number of glyphs in this line.
 */
@property (nonatomic, assign, readonly) NSUInteger glyphCount;

/**
 *	The range of the original attributed string used to create the MYSFramesetter that generated this line. Also
 *  could be the range of the string used to create this line directly.
 */
@property (nonatomic, assign, readonly) NSRange range;

/**
 *	The index in the original that string spawned this line of the first character in the line.
 *
 *	@return	The index in the original string that spawned this line of the first character in the line.
 */
- (NSUInteger)indexOfFirstCharacter;

/**
 *	The index in the original string that spawned this line of the last character in the line.
 *
 *	@return	The index in the original string that spawned this line of the last character in the line.
 */
- (NSUInteger)indexOfLastCharacter;




///-----------------------------------
/// Runs
///-----------------------------------

/**
 *  An array of the MYSRun objects of this line.
 */
@property (nonatomic, strong, readonly) NSArray *runs;




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




///-----------------------------------
/// Glyphs
///-----------------------------------

/**
 *  An array of the MYSGlyph objects of this line.
 */
@property (nonatomic, strong, readonly) NSArray *glyphs;

/**
 *	Two glyphs could share teh same index, so this looks for the first glyph with the `index`
 *
 *	@param	index	The character index to use to map and find the glyph.
 *
 *	@return	The glyph that maps to the character at `index`.
 */
- (MYSGlyph *)glyphAtCharacterIndex:(NSUInteger)index;




///-----------------------------------
/// Geometry
///-----------------------------------

/**
 *	The origin of this line in the MYSFrame's path's coordinate space.
 */
// TODO: use CTLineGetPenOffsetForFlush?
@property (nonatomic, assign, readonly) CGPoint origin;

/**
 *	TODO: Needs sane docs. WTF CT authors?
 */
@property (nonatomic, assign, readonly) CGFloat trailingWhitespaceWidth;

/**
 *	The largest glyph ascent on the line.
 *  The ascent is the distance from the baseline to the top of the glyph.
 */
@property (nonatomic, assign, readonly) CGFloat ascent;

/**
 *	The largest glyph descent on the line.
 *  The descent of a glyph is the distance from the baseline to the lowest point on the glyph.
 */
@property (nonatomic, assign, readonly) CGFloat descent;

/**
 *	The leading of this line.
 *  The leading of a line is the space between the tops line's glyph's bounding box and the bottom line's glyph's bb.
 */
@property (nonatomic, assign, readonly) CGFloat leading;

/**
 *  The lineheight of this line.
 *  The lineheight is calculated by adding up the ascent, descent and leading of a line.
 */
@property (nonatomic, assign, readonly) CGFloat lineHeight;

/**
 *	The bounding box of this line with 0 for options.
 */
@property (nonatomic, assign, readonly) CGRect boundingBox;

/**
 *	Calculates the bounds of a lines modified by the options.
 *
 *	@param	options	
                An mask of options to determine how the bounds should be calculates. See CTLineBoundsOptions.
 *
 *	@return	The bounds of the line given `options`.
 */
- (CGRect)boundsWithOptions:(CTLineBoundsOptions)options;

/**
 *	The graphical offset (from the left or right depending on writing direction) of the character at `index`.
 *
 *	@param	index	
 *              The index of the character you want the offset of.
 *
 *	@return	The number of points from the left or right (depending on writing direction) of the character at `index`.
 */
- (CGFloat)offsetOfCharacterAtIndex:(NSInteger)index;

/**
 *	The index of the character at `point`.
 *
 *	@param	point	
                A point in the lines coordinate space. (the y coord doesn't seem to matter).
 *
 *	@return	The index of the character located at `point`.
 */
- (NSUInteger)characterIndexAtPoint:(CGPoint)point;








///---------------------------
/// Drawing
///---------------------------

/**
 *	Draws the line in `context`
 *
 *	@param	context	
 *              A graphical context to draw the line into.
 */
- (void)drawInContext:(CGContextRef)context;


@end
