# iOS Simulator Raindrop

I did this a long time ago as my first Mac development project. Be gentle.

## How does it work?

The code goes through all running processes and seeks for a process named "iOS Simulator". Sometimes, somehow, there are multiple of those running simulatenously. But only one has the exact window dimensions we're looking for (depending on the device and scale the simulator is running). Once it has found the right process, it takes a screenshot of a portion of that window and uploads it to Cloud.app.

    #define kWindowSizePhone CGSizeMake(396,744)
    #define kViewRectPhone CGRectMake(38,126,320,480)

The first variable defines the window size we're looking for (this would include the drop shadow OS X applied around the window). The second variable defines the viewport rect inside that window that will get cropped and uploaded to Cloud.app.

## What needs to be done

* Support for iPhone 5 (all scales missing)
* Support for iPhone 4 (only 75% scale is missing)
* Support for iPad Retina (all scales missing)
* Support for iPad (50% and 75% scales missing)

## To install in Cloud.app

Change the build product's extension from `.bundle` to `.raindrop`