#import "ISViewController.h"

@implementation ISViewController

- (void)loadView
{
    ISCyclicPagesView *pagesView = [[ISCyclicPagesView alloc] init];
    pagesView.dataSource = self;
    pagesView.delegate = self;
    
    self.view = pagesView;
}

#pragma mark - ISCyclicPagesViewDataSource

- (NSInteger)numberOfPagesInPagesView:(ISCyclicPagesView *)pagesView
{
    return 9;
}

- (UIView *)reusableViewForPagesView:(ISCyclicPagesView *)pagesView
{
    // this part will be executed only 3 times (not 9 times).
    return [[UILabel alloc] init];
}

#pragma mark - ISCyclicPagesViewDelegate

- (void)pagesView:(ISCyclicPagesView *)pagesView willDisplayView:(UIView *)view forIndex:(NSInteger)index
{
    UILabel *label = (UILabel *)view;
    label.text = [@(index) stringValue];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:100.f];
    
    switch (index % 3) {
        case 0: label.backgroundColor = [UIColor redColor]; break;
        case 1: label.backgroundColor = [UIColor greenColor]; break;
        case 2: label.backgroundColor = [UIColor blueColor]; break;
    }
}

@end
