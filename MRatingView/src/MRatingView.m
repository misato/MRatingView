//
//  MRatingView.m
//  MRatingView
//
//  Created by Ester on 01/05/13.
//  Copyright (c) 2013 misato. All rights reserved.
//

#import "MRatingView.h"

// Constant to define the default maxRating value.
#define kDefaultMaxRating 5

/**
 Enum specifying the 3 image types we need based on the state of the rating: empty, full and half image.
 */
typedef NS_ENUM(NSInteger, MRatingImageState) {
    MRatingImageStateFull,
    MRatingImageStateEmpty,
    MRatingImageStateHalf
};

// The private interface
@interface MRatingView ()

///------------------------------------------///
/// @name Handling internal UIImageViews 
///------------------------------------------///

// Array to store all the UIImageViews needed for the rating.
@property (nonatomic, strong) NSMutableArray *ratingViews;

/**
 Helper method to initialize and set up the ratingViews stored in ratingViews array.
 */
- (void)setUpViews;

///------------------------------------------///
/// @name Handling user interaction
///------------------------------------------///

/**
 Handles the gesture done by the user
 
 @param recognizer The gesture recognizer. By default it's a UITapGestureRecognizer.
 */
- (void)handleGesture:(UIGestureRecognizer *)recognizer;


/**
 Handles the touch point received from the gesture recognizer and updates the rating.
 
 @param location The point where the user touched.
 */
- (void)updateRatingForTouchAtLocation:(CGPoint)location;


///------------------------------------------///
/// @name Getting Image Names
///------------------------------------------///

/**
 Gets the image corresponding to the state provided.
 
 The image name format should be: <imageBaseName>_<full/empty/half>.png
 Feel free to change it to fit your needs.
 
 @param state The state.
 @return The image for that state or nil if it doesn't have imageBaseName setted.
 */
- (UIImage *)imageForState:(MRatingImageState)state;

@end

@implementation MRatingView

#pragma mark - Initialize

- (id)init {
    return [self initWithRating:@0 maxRating:kDefaultMaxRating editable:YES imageBaseName:nil];
}

- (id)initWithRating:(NSNumber *)rating maxRating:(NSUInteger)maxRating editable:(BOOL)editable imageBaseName:(NSString *)imageBaseName {
    
    if (self = [super init]){
        self.rating = rating;
        self.editable = editable;
        self.imageBaseName = imageBaseName;
        
        _maxRating = maxRating;
        self.ratingViews = [[NSMutableArray alloc] initWithCapacity:_maxRating];
        
        // Adding Gesture recognizers.
        // We need both to support user tapping and swiping.
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
        [self addGestureRecognizer:tapGestureRecognizer];
        
        UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
        [self addGestureRecognizer:gestureRecognizer];
        
        [self setUpViews];
    }
    return self;
}

- (void)setUpViews {
    UIImage *rateImage = [self imageForState:MRatingImageStateEmpty];
    
    CGFloat x = 0;
    CGFloat imageWidth = rateImage.size.width;
    
    for (int i = 0; i < self.maxRating; i++){
        // Add to the view
        UIImageView *ratingImageView = [[UIImageView alloc] initWithImage:rateImage];
        ratingImageView.frame = CGRectMake(x, 0, rateImage.size.width, rateImage.size.height);
        [self addSubview:ratingImageView];
        
        // Add to the array
        [self.ratingViews addObject:ratingImageView];
        
        x += imageWidth;
    }
}

#pragma mark - Setters

- (void)setEditable:(BOOL)editable {
    _editable = editable;
    self.userInteractionEnabled = editable;
}


#pragma mark - LayoutSubviews

- (void)layoutSubviews {
    
    //set images based in rating
    for (int i = 0; i < self.maxRating; i++){
        UIImageView *ratingImageView = [self.ratingViews objectAtIndex:i];
        
        float half = i + 0.5;
        if ([self.rating floatValue] > i) {
            if ([self.rating floatValue] > half) {
                ratingImageView.image = [self imageForState:MRatingImageStateFull];
            }
            else {
                ratingImageView.image = [self imageForState:MRatingImageStateHalf];
            }
        }
        else {
            ratingImageView.image = [self imageForState:MRatingImageStateEmpty];
        }
        
    }
}

///------------------------------------------///
/// Private Interface Implementation
///------------------------------------------///


#pragma mark - Image Names

- (UIImage *)imageForState:(MRatingImageState)state {
    if(!_imageBaseName) {
        return nil;
    }
    
    NSString *imageSuffix = nil;
    
    switch (state) {
        case MRatingImageStateEmpty:
            imageSuffix = @"empty";
            break;
        case MRatingImageStateFull:
            imageSuffix = @"full";
            break;
        case MRatingImageStateHalf:
            imageSuffix = @"half";
            break;
    }
    
    NSString *imageName = [NSString stringWithFormat:@"%@_%@.png", _imageBaseName, imageSuffix];
    UIImage *image = [UIImage imageNamed:imageName];
    
    return image;
}

#pragma mark - Handling touches

- (void)handleGesture:(UIGestureRecognizer *)recognizer {
    
    // Get the location of the gesture
    CGPoint touchLocation = [recognizer locationInView:self];
    [self updateRatingForTouchAtLocation:touchLocation];
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if ([_delegate respondsToSelector:@selector(ratingView:didChangeRating:)])
            [_delegate ratingView:self didChangeRating:_rating];
    }
    
}


- (void)updateRatingForTouchAtLocation:(CGPoint)location {
    if (!_editable) {
        return;
    }
    
    CGFloat xPoint = location.x;
    CGFloat viewWidth = self.bounds.size.width;
    
    // Check if we're out of bounds, and set 0 or maxRating values.
    if (xPoint < 0.0f) {
        self.rating = @0.0f;
    }
    else if (xPoint > viewWidth) {
        self.rating = [NSNumber numberWithInteger:_maxRating];
    }
    else {
        float newRating = (xPoint * _maxRating)/viewWidth;
        
        // get the decimal part to see how we have to round it (we only accept X.5)
        float decimal = fmodf(newRating, 1);
        
        if (decimal > 0.0f && decimal <= 0.5f) {
            newRating = newRating + (0.5f - decimal);
        }
        else {
            newRating = ceilf(newRating);
        }
        
        self.rating = [NSNumber numberWithFloat:newRating];
    }
    
    [self setNeedsLayout];
}

#pragma mark - Size To Fit

/**
 This method is implemented so we get the minimum size needed for the imageViews.
 It's necessary because we generate the imageViews dinamically.
 - WARNING:
    We don't really use the size provided to check if it fits, it just return the minimum size needed for the view.
 */
- (CGSize)sizeThatFits:(CGSize)size {
    
    UIImage *image = [self imageForState:MRatingImageStateFull];
    CGSize sizeThatFits = CGSizeMake(image.size.width * _maxRating, image.size.height);
    return sizeThatFits;
}

@end
