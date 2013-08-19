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
 *  Auto releases a Core Foundation object safely. If you pass NULL to CFAutorelease, it will crash.
 *
 *  @param  cf
 *              Any Core Foundation objecct. Can be NULL.
 *
 *  @return An autoreleased Core Foundation object.
 */
CF_INLINE CFTypeRef MYSCFSafeAutorelease(CFTypeRef cf)
{
    return cf ? CFAutorelease(cf) : NULL;
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


/**
 *  Determines if an index is found in range.
 *
 *  @param  range
 *              The range to check if `index` is included.
 *  @param  index
 *              The index to cehck if is included in `range`.
 *
 *  @return     YES if `index` is in `range`, otherwise, NO.
 */
CF_INLINE BOOL MYSNSRangeContainsIndex(NSRange range, NSUInteger index)
{
    return NSLocationInRange(index, range);
}


/**
 *  Start index of a range
 *
 *	@param	range	The range you want the start index of.
 *
 *	@return	The index of the start of the range.
 */
CF_INLINE NSUInteger MYSNSRangeStartIndex(NSRange range)
{
    return range.location;
}


/**
 *  Returns the end index of the given range.
 *
 *	@param	range	The range you want the end index of.
 *
 *	@return	The index of the end of the range.
 */
CF_INLINE NSUInteger MYSNSRangeEndIndex(NSRange range)
{
    return (range.location + range.length) - 1;
}


/**
 *  Returns the distance from index to the index of the closest edge of range. If `index` is contained
 *  within `range`, 0 is returned.
 *
 *	@param	index   The index to compare range edges against.
 *  @param  range   The range to find the distance to `index` of.
 *
 *  @return Returns the distance from index to the index of the closest edge of range. If `index` is contained
 *          within `range`, 0 is returned.
 */
CF_INLINE NSUInteger MYSIndexDistanceToRange(NSUInteger index, NSRange range)
{
    if (MYSNSRangeContainsIndex(range, index)) return 0;
    NSUInteger rangeStart       = MYSNSRangeStartIndex(range);
    NSUInteger rangeEnd         = MYSNSRangeEndIndex(range);
    NSUInteger distanceToLeft   = MAX(index, rangeStart) - MIN(index, rangeStart);
    NSUInteger distanceToRight  = MAX(index, rangeEnd)   - MIN(index, rangeEnd);
    return MIN(distanceToLeft, distanceToRight);
}

/**
 *	Returns an index that is assured to be within `range`. If `index` is outside `range` it is adjusted to equal
 *  the closest edge of `range`.
 *
 *	@param	index	The index that will be assured to be withing `range`.
 *	@param	range	The range index must be contained in.
 *
 *	@return The index adjusted to be within `range`.
 */
CF_INLINE NSUInteger MYSIndexDefinitelyInsideRange(NSUInteger index, NSRange range)
{
    if (index < MYSNSRangeStartIndex(range)) {
        index = MYSNSRangeStartIndex(range);
    }
    if (index > MYSNSRangeEndIndex(range)) {
        index = MYSNSRangeEndIndex(range);
    }
    return index;
}





///----------------------------
/// Geometry
///----------------------------

/**
 *	Returns a point that is assured to be inside rect. If it is outside `rect` its x and/or y values are adjusted.
 *
 *	@param	point	The point to assure is inside `rect`.
 *	@param	rect	The rect to assure `point` is within.
 *
 *	@return	Returns a point that is assured to be inside rect. If it is outside `rect` its x and/or y values are adjusted.
 */
CF_INLINE CGPoint MYSPointDefinitelyInsideRect(CGPoint point, CGRect rect)
{
    if (!CGRectContainsPoint(rect, point)) {
        point.x = MAX(point.x, CGRectGetMinX(rect));
        point.x = MIN(point.x, CGRectGetMaxX(rect));
        point.y = MAX(point.y, CGRectGetMinY(rect));
        point.y = MIN(point.y, CGRectGetMaxY(rect));
    }
    return point;
}
