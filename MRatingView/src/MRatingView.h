//
//  MRatingView.h
//  MRatingView
//
//  Created by Ester on 01/05/13.
//  Copyright (c) 2013 misato. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MRatingViewDelegate;

/**
 Base class for ratings.
 */
@interface MRatingView : UIView

/**
 The maximum rating of the view (created dinamically).
 This property is initialized with the init method.
 It also has a default value (@see kDefaultMaxRating) in case it's not provided in the init of the view.
 */
@property (nonatomic, assign, readonly) NSUInteger maxRating;
/**
 The current rating value
 */
@property (nonatomic, strong) NSNumber *rating;
/**
 This property indicates is the user can edit the rating or not.
 */
@property (nonatomic, assign, getter = isEditable) BOOL editable;
/**
 The base name for the images.
 */
@property (nonatomic, strong) NSString *imageBaseName;
/**
 The delegate for this class. 
 */
@property (nonatomic, assign) id<MRatingViewDelegate> delegate;


///------------------------------------------///
/// @name Initializing the view.
///------------------------------------------///


/**
 Initializes the StarRatingView.
 This is the default initializer for this class.
 
 If this class is initialized with the init method, it will have these default values:
 - rating: 0
 - editable: YES
 - imageBaseName: nil
 - maxRating: kDefaultMaxRating
 
 @param rating The rating to show.
 @param editable Specifies if the view is editable (user interaction enabled).
 @param imageBaseName The base name for the images to use.
 @return the initialized view.
 */
- (id)initWithRating:(NSNumber *)rating maxRating:(NSUInteger)maxRating editable:(BOOL)editable imageBaseName:(NSString *)imageBaseName;

@end

/**
 Protocol to inform about the changes in the rating value. 
 */
@protocol MRatingViewDelegate <NSObject>

- (void)ratingView:(MRatingView *)ratingView didChangeRating:(NSNumber *)newRating;

@end
