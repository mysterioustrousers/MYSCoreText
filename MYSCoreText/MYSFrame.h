//
//  MYSFrame.h
//  MYSCoreText
//
//  Created by Adam Kirk on 7/19/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//


@interface MYSFrame : NSObject




///------------------------------
/// Working with Strings
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
/// Lines
///----------------------------

/**
 *  The lines generated to fill this frame.
 */
@property (nonatomic, strong, readonly) NSArray *lines;




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
