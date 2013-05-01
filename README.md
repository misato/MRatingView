MRatingView
===========

A simple RatingView for iOS
---------------------------

I made this implementation of a simple RatingView for work, and I hope this can help anybody.
The MRatingView is a dynamic RatingView, you have more info about it in the header files documentation. 


Features:
---------

- The RatingView can be used only to show a rating  (no user interaction enabled) or to allow the user to provide a rating
- It can be initialized with a maximum number of Rating, and it will show that number of icons. (It's not the default 5 star rating, can be 10 icons or whatever number you need).
- Supports X.5 ratings (for exaple 3.5)
- A base name for images can be provided, so you can have 2 RatingViews with different images (see header files documentation for the name format of those).
- An usage example is provided :)


How do I use it in my project?
------------------------------

Just drag and drop the MRatingView.h and .m files (inside the src folder) to your project and you're done!
Using the MRatingView class is pretty easy:

Instantiate the RatingView with an initial rating of 1 out of 5, let the user change it (editable) and an image BaseName of "myImageBaseName". Also, set the delegate so we can receive the rating changes in our viewController.

```objective-c
MRatingView *ratingView = [[MRatingView alloc] initWithRating:@1 maxRating:5 editable:YES imageBaseName:@"myImageBaseName"];
ratingView.delegate = self;
```

After that we need to implemet the delegate method (this is optional) 

```objective-c
- (void)ratingView:(MRatingView *)ratingView didChangeRating:(NSNumber *)newRating {
    NSLog(@"New rating: %1.1f",[newRating floatValue]);
}
```


About the icons
----------------

Icons are provided in the example project, as an usage example.

I found those icons in Google and I remember they were free to use but unfortunately I can't remember the author nor the website where I found them. If you're the author and you're reading this please **contact me** so I can give propper credit to your work (I think they're awesome icons!). 

Thanks in advance! 