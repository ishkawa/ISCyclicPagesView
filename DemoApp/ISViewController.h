#import <UIKit/UIKit.h>
#import <ISCyclicPagesView/ISCyclicPagesView.h>

@interface ISViewController : UIViewController <ISCyclicPagesViewDataSource, ISCyclicPagesViewDelegate>

@property (nonatomic, readonly) ISCyclicPagesView *pagesView;

@end
