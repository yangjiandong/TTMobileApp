
#import "NewsViewController.h"
#import "NewsCell.h"
#import "ExampleData.h"

static NSString *kNewsCellID = @"NewsCell";

@interface NewsViewController ()

@end

@implementation NewsViewController


- (instancetype)initWithNewsListType:(NewsListType)type
{
    self = [super init];

    if (self) {
        __weak NewsViewController *weakSelf = self;

        self.generateURL = ^NSString * (NSUInteger page) {
            //return [NSString stringWithFormat:@"%@%@?catalog=%d&pageIndex=%lu&%@", @"http://127.0.0.1:8003/exampledatas", @"", type, (unsigned long)page, @"pageSize=20"];
            return [NSString stringWithFormat:@"%@", @"http://127.0.0.1:8003/exampledatas"];
        };
        
        self.tableWillReload = ^(NSUInteger responseObjectsCount) {
            if (type >= 4) {weakSelf.lastCell.status = LastCellStatusFinished;}
            else {responseObjectsCount < 20? (weakSelf.lastCell.status = LastCellStatusFinished) :
                                             (weakSelf.lastCell.status = LastCellStatusMore);}
        };
        
        //self.objClass = [ExampleData class];
    }
    
    return self;
}


- (NSArray *)parseXML:(id)responseDocument
{
    return [responseDocument objectForKey:@"data"];
    //return [[xml.rootElement firstChildWithTag:@"newslist"] childrenWithTag:@"news"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:[NewsCell class] forCellReuseIdentifier:kNewsCellID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:kNewsCellID forIndexPath:indexPath];
    ExampleData *news = self.objects[indexPath.row];

    //NSLog(@"news - %@", news.attributedCommentCount);
    // 43{
    //NSFont = "<UICTFont: 0x78fc11e0> font-family: \"FontAwesome\"; font-weight: normal; font-style: normal; font-size: 12.00pt";
    //}
    cell.backgroundColor = [UIColor themeColor];
    
    [cell.titleLabel setText:news.name];
    [cell.bodyLabel setText:news.body];
    [cell.authorLabel setText:news.author];
    cell.titleLabel.textColor = [UIColor titleColor];
    //[cell.timeLabel setAttributedText:[Utils attributedTimeString:news.pubDate]];
    //[cell.commentCount setAttributedText:news.attributedCommentCount];
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor selectCellSColor];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //OSCNews *news = self.objects[indexPath.row];
    
    self.label.font = [UIFont boldSystemFontOfSize:15];
    //[self.label setAttributedText:news.attributedTittle];
    CGFloat height = [self.label sizeThatFits:CGSizeMake(tableView.frame.size.width - 16, MAXFLOAT)].height;
    
    //self.label.text = news.body;
    self.label.font = [UIFont systemFontOfSize:13];
    height += [self.label sizeThatFits:CGSizeMake(tableView.frame.size.width - 16, MAXFLOAT)].height;
    
    return height + 42;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    

}


- (void)addObjects:(NSArray *)array {
    for (NSUInteger i = 0; i < [array count]; i ++) {
        BOOL shouldBeAdded = YES;
        ExampleData * obj = [[ExampleData alloc] initWithAttributes:array[i]];
        //id obj = [_objClass allo]

//                  for (BaseObject *baseObj in _objects) {
//                      if ([obj isEqual:baseObj]) {
//                          shouldBeAdded = NO;
//                          break;
//                      }
//                  }
        if (shouldBeAdded) {
            [self.objects addObject:obj];
        }
    }
}





@end
