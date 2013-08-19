//
//  MYSRun.h
//  MYSCoreText
//
//  Created by Adam Kirk on 7/19/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//


@class MYSLine;


@interface MYSRun : NSObject


/**
 *	The line that created this line if it was created by a line, otherwise is nil.
 */
@property (nonatomic, assign, readonly) MYSLine *line;


///-----------------------------
/// Text
///-----------------------------

/**
 *	The attributed string that is the contents of the run.
 */
@property (nonatomic, copy,   readonly) NSAttributedString *attributedString;

/**
 *	The attributes of run that were either the attributes past to the original attributed string or manufactured
 *  by the layout engine in the case of missing critical attributes.
 */
@property (nonatomic, copy, readonly) NSDictionary *attributes;

/**
 *	A bitfield that is used to indicate the disposition of the run.
 */
@property (nonatomic, assign, readonly) CTRunStatus status;

/**
 *	The range of the original attributed string used to spawn this run.
 */
@property (nonatomic, assign, readonly) NSRange range;




///----------------------------
/// Glyphs
///---------------------------

/**
 *	The number of glyphs in this run.
 */
@property (nonatomic, assign, readonly) NSUInteger glyphCount;

/**
 *	An array of MYSGlyph objects that represent all the glyphs in this run.
 */
@property (nonatomic, copy, readonly) NSArray *glyphs;




///----------------------------
/// Geometry
///----------------------------

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
 *	Returns the text matrix needed to draw this run. To properly draw the glyphs in a run, the fields tx and ty
 *  of the CGAffineTransform returned by this function should be set to the current text position.
 */
@property (nonatomic, assign, readonly) CGAffineTransform textMatrix;

/**
 *  The graphical frame of the run. Returns a rectangle that tightly encloses the paths of the glyphs in the run.
 *
 *	@param	context	
 *              The graphical context that this run is intended to be drawn into. The settings of the context
 *              can affect how the bounds are calculated.
 *
 *	@return	The smallest rect that encompses the glyphs in the run.
 */
- (CGRect)boundsInContext:(CGContextRef)context;




///-------------------------------------
/// Drawing
///-------------------------------------

/**
 *	Draws the run into the graphics context.
 *
 *	@param	context
 *              The context to draw the run into.
 */
- (void)drawInContext:(CGContextRef)context;


@end
