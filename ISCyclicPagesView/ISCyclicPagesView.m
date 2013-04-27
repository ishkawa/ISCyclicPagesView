#import "ISCyclicPagesView.h"

// this value must be odd number
static NSInteger const ISReusableViewsCount = 3;

@interface ISCyclicPagesView ()

@property (nonatomic) NSInteger currentPage;
@property (nonatomic, strong) NSArray *reusableViews;

@end

@implementation ISCyclicPagesView

- (id)init
{
    return [self initWithFrame:[UIScreen mainScreen].applicationFrame];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    self.scrollsToTop = NO;
    self.clipsToBounds = NO;
    self.pagingEnabled = YES;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
}

#pragma mark - accessors

- (NSInteger)numberOfPages
{
    return [self.dataSource numberOfPagesInPagesView:self];
}

#pragma mark - UIView events

- (void)willMoveToSuperview:(UIView *)superview
{
    if (self.superview) {
        [self removeObserver:self forKeyPath:@"contentOffset"];
    }
    if (superview) {
        [self reloadData];
        [self addObserver:self forKeyPath:@"contentOffset" options:0 context:NULL];
    }
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGSize size = self.frame.size;
        CGFloat upperThreshold = size.width + size.width / 2.f;
        CGFloat lowerThreshold = size.width - size.width / 2.f;
        
        if (self.contentOffset.x > upperThreshold) {
            NSInteger index = (self.currentPage + 1) % self.numberOfPages;
            [self scrollToPage:index
                     direction:-1
                      animated:NO];
        }
        
        if (self.contentOffset.x < lowerThreshold) {
            NSInteger index = self.currentPage - 1 >= 0 ? self.currentPage - 1 : self.numberOfPages - 1;
            [self scrollToPage:index
                     direction:+1
                      animated:NO];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)reloadData
{
    for (UIView *view in self.reusableViews) {
        [view removeFromSuperview];
    }
    
    if (!self.dataSource) {
        return;
    }
    
    CGSize size = self.frame.size;
    NSMutableArray *reusableViews = [NSMutableArray array];
    
    for (NSInteger index = 0; index < ISReusableViewsCount; index++) {
        UIView *view = [self.dataSource reusableViewForPagesView:self];
        view.frame = CGRectMake(index * size.width, 0.f, size.width, size.height);
        view.backgroundColor = [UIColor blueColor];
        
        [self addSubview:view];
        [reusableViews addObject:view];
        
        if ([self.delegate respondsToSelector:@selector(pagesView:willDisplayView:forIndex:)]) {
            NSInteger page = index - 1 >= 0 ? index - 1 : self.numberOfPages - 1;
            [self.delegate pagesView:self
                     willDisplayView:view
                            forIndex:page];
        }
    }
    self.reusableViews = [NSArray arrayWithArray:reusableViews];
    self.currentPage = 0;
    
    self.contentSize = CGSizeMake(size.width * 3, size.height);
    self.contentOffset = CGPointMake(size.width, 0.f);
}

- (void)scrollToPage:(NSInteger)page direction:(NSInteger)direction animated:(BOOL)animated
{
    if (self.currentPage == page) {
        return;
    }
    
    self.currentPage = page;
    
    for (UIView *view in self.reusableViews) {
        NSInteger viewIndex = [self.reusableViews indexOfObject:view];
        NSInteger index = (self.currentPage + (viewIndex - 1));
        if (index > self.numberOfPages - 1) {
            index %= self.numberOfPages;
        }
        if (index < 0) {
            index += self.numberOfPages;
        }
        
        if ([self.delegate respondsToSelector:@selector(pagesView:willDisplayView:forIndex:)]) {
            [self.delegate pagesView:self
                     willDisplayView:view
                            forIndex:index];
        }
    }
    
    CGFloat x = self.contentOffset.x + self.frame.size.width * direction;
    if (animated) {
        [self setContentOffset:CGPointMake(x, 0.f) animated:animated];
    } else {
        // prevents stopping scrolling
        self.contentOffset = CGPointMake(x, 0.f);
    }
}

- (NSInteger)pageForView:(UIView *)view
{
    NSInteger index = [self.reusableViews indexOfObject:view];
    if (index == NSNotFound) {
        return index;
    }

    return self.currentPage + index - (ISReusableViewsCount - 1)/2;
}

- (UIView *)viewForPage:(NSInteger)page
{
    NSRange range = NSMakeRange(self.currentPage - (ISReusableViewsCount - 1)/2, ISReusableViewsCount);
    if (page < range.location || page > range.location + range.length) {
        return nil;
    }
    
    NSInteger index = page - self.currentPage + (ISReusableViewsCount - 1)/2;
    return [self.reusableViews objectAtIndex:index];
}

@end
