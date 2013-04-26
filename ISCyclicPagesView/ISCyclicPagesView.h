#import <UIKit/UIKit.h>

@class ISCyclicPagesView;

@protocol ISCyclicPagesViewDataSource <NSObject>
@required
- (NSInteger)numberOfPagesInPagesView:(ISCyclicPagesView *)pagesView;
- (UIView *)reusableViewForPagesView:(ISCyclicPagesView *)pagesView;

@end

@protocol ISCyclicPagesViewDelegate <NSObject, UIScrollViewDelegate>
@optional
- (void)pagesView:(ISCyclicPagesView *)pagesView willDisplayView:(UIView *)view forIndex:(NSInteger)index;
- (void)pagesView:(ISCyclicPagesView *)pagesView didChangeCurrentIndex:(NSInteger)index;

@end

@interface ISCyclicPagesView : UIScrollView

@property (nonatomic, readonly) NSInteger currentPage;
@property (nonatomic, readonly) NSInteger numberOfPages;
@property (nonatomic, assign) id <ISCyclicPagesViewDataSource> dataSource;
@property (nonatomic, assign) id <ISCyclicPagesViewDelegate> delegate;

- (void)reloadData;

// TODO: implement methods below
//- (NSInteger)indexForView:(UIView *)view;
//- (UIView *)viewForIndex:(NSInteger)index;

@end

