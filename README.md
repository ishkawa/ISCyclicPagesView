ISCyclicPagesView is a subclass of UIScrollView for cyclic pages.

[Demo Video](https://vimeo.com/64948676)

## Requirements

- iOS 4.3 or later
- ARC

## Usage

```objectivec
#pragma mark - ISCyclicPagesViewDataSource

- (NSInteger)numberOfPagesInPagesView:(ISCyclicPagesView *)pagesView
{
    return 9;
}

- (UIView *)reusableViewForPagesView:(ISCyclicPagesView *)pagesView
{
    // this part will be executed only 3 times (not 9 times).
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:200.f];

    return label;
}

#pragma mark - ISCyclicPagesViewDelegate

- (void)pagesView:(ISCyclicPagesView *)pagesView willDisplayView:(UIView *)view forIndex:(NSInteger)index
{
    UILabel *label = (UILabel *)view;
    label.text = [@(index) stringValue];
    
    switch (index % 3) {
        case 0: label.backgroundColor = [UIColor redColor]; break;
        case 1: label.backgroundColor = [UIColor greenColor]; break;
        case 2: label.backgroundColor = [UIColor blueColor]; break;
    }
}
```

## Installing

Add files under `ISCyclicPagesView/` to your Xcode project.

### CocoaPods

If you use CocoaPods, you can install ISCyclicPagesView by inserting config below.
```
pod 'ISCyclicPagesView', :git => 'https://github.com/ishkawa/ISHTTPOperation.git'
```

## Known Issues

- currently, ISCyclicPagesView does not support auto-rotation.

## License

Copyright (c) 2013 Yosuke Ishikawa

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
