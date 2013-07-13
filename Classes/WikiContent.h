/*
 * Protocol defines any wiki content
 */
@protocol WikiContent <NSObject>

/*
 * The URL used to access children of the current node
 */
-(NSString *)pageChildrenURL;

/* Allows adding a child */
- (void)addPage: (id<WikiContent>)page;

@end