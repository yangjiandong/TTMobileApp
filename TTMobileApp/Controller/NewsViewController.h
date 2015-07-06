
#import "OSCObjsViewController.h"

typedef NS_ENUM(int, NewsListType)
{
    NewsListTypeAllType = 0,
    NewsListTypeNews,
    NewsListTypeSynthesis,
    NewsListTypeSoftwareRenew,
    NewsListTypeAllTypeWeekHottest,
    NewsListTypeAllTypeMonthHottest,
};

@interface NewsViewController : OSCObjsViewController

- (instancetype)initWithNewsListType:(NewsListType)type;

@end
