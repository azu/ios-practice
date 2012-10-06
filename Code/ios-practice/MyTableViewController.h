@interface MyTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource> {

}
@property(nonatomic, retain, readonly) NSArray *dataSource;
@end
