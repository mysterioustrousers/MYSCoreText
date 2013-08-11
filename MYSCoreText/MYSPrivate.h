//
//  MYSPrivate.h
//  MYSCoreText
//
//  Created by Adam Kirk on 8/9/13.
//  Copyright (c) 2013 Mysterious Trousers. All rights reserved.
//


extern NSString *const MYSTypographicalBoundsAscentKey;
extern NSString *const MYSTypographicalBoundsDescentKey;
extern NSString *const MYSTypographicalBoundsLeadingKey;


/**
 *  Converts a CFRange to an NSRange
 *
 *  @param      range
 *                  A CFRange
 *
 *  @discussion loc and len are both NSUIntegers, so they must be converted to CFIndex which are `signed long`.
 *
 *  @return     An NSRange
 */
CF_INLINE NSRange MYSNSRangeBridge(CFRange range)
{
    return NSMakeRange(range.location, range.length);
}


/**
 *  Converts a NSRange to an CFRange
 *
 *  @param      range
 *                  A NSRange
 *
 *  @discussion CFInex is a `signed long`, so loc and len should be converted to an `unsigned long`
 *
 *  @return     An CFRange
 */
CF_INLINE CFRange MYSCFRangeBridge(NSRange range)
{
    return CFRangeMake(range.location, range.length);
}


/**
 *  Releases a Core Foundation object safely. If you pass NULL to CFRelease, it will crash.
 *
 *  @param  cf
 *              Any Core Foundation object. Can be NULL.
 */
CF_INLINE void MYSCFSafeRelease(CFTypeRef cf)
{
    if (cf) CFRelease(cf);
}


/**
 *  Retains a Core Foundation object safely. If you pass NULL to CFRetain, it will crash.
 *
 *  @param  cf
 *              Any Core Foundation objecct. Can be NULL.
 *
 *  @return A retained Core Foundation object.
 */
CF_INLINE CFTypeRef MYSCFSafeRetain(CFTypeRef cf)
{
    return cf ? CFRetain(cf) : NULL;
}


/**
 *  Assumes the point is in the coordinate space of the rectangle and converts it to the rectangles coordinate space.
 *
 *  @param  point    
 *              The point inside the rectangle.
 *  @param  rect
 *              The rectangle whos coordinate space the point will move to.
 *
 *  @return     The point translated to the rectangles coordinate space.
 */

CF_INLINE CGPoint MYSConvertPointFromRect(CGPoint point, CGRect rect)
{
    point.x += rect.origin.x;
    point.y += rect.origin.y;
    return point;
}
