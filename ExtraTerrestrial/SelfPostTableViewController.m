//
//  SelfPostTableViewController.m
//  ExtraTerrestrial
//
//  Created by Christian Poplawski on 13/02/15.
//  Copyright (c) 2015 chrispop. All rights reserved.
//

#import "SelfPostTableViewController.h"

static NSString * const kContentCellIdentifier = @"contentCell";
static NSString * const kCommentCellIdentifier = @"commentCell";

@interface SelfPostTableViewController (){
    NSArray *commentsData;
    CGFloat webViewHeight;
}

@end

@implementation SelfPostTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 144.0;
    self.postURLString = [self.postData objectForKey:@"permalink"];
    NSURL *singlePostURL = [self urlFromPermalink:self.postURLString];
    SinglePostDataModel *dataModel = [[SinglePostDataModel alloc] initWithURL:singlePostURL];
    commentsData = [NSArray arrayWithArray:[dataModel topLevelComments]];
    
    
    //SinglePostAPICall *apiCall = [[SinglePostAPICall alloc] initWithURL:singlePostURL];
    //NSLog(@"%@", apiCall.apiCallReturns);
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if (section == 1) {
        return 1;
    } else {
        // Quickfix for last element of array, which only contains the links to the "load more" comments
        // TODO: Do somethinge useful with the "more comments" links
        return [commentsData count] - 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        ContentTableViewCell *contentCell = [tableView dequeueReusableCellWithIdentifier:kContentCellIdentifier];
        [self configureContentCell:contentCell atIndexPath:indexPath];
        return contentCell;
    } else {
        CommentTableViewCell *commentCell = [tableView dequeueReusableCellWithIdentifier:kCommentCellIdentifier];
        [self configureCommentCell:commentCell atIndexPath:indexPath];
        return commentCell;
    }
    
    
}

//TODO: do I need the IndexPath here?
- (void)configureContentCell:(ContentTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    // Meta
    cell.titleLabel.text = [self.postData objectForKey:@"title"];
    cell.authorLabel.text = [self.postData objectForKey:@"author"];
    
    // Content
    if ([[self.postData objectForKey:@"selftext"] length]) {
        NSString *htmlSelftext = [self createStringForWebView:[self.postData objectForKey:@"selftext"]];
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[htmlSelftext dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        cell.contentTextView.attributedText = attributedString;
        [cell.contentTextView setFont:[UIFont systemFontOfSize:17]];
    } else {
        // No body content, remove UITextView.
        // TODO: Not working clean, extra cell?
        [cell.contentTextView removeFromSuperview];
    }
    
    // Update constraints after elements are filled with content.
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
}

-(void)configureCommentCell: (CommentTableViewCell *) cell atIndexPath: (NSIndexPath *) indexPath {
    cell.authorLabel.text = [[commentsData objectAtIndex:indexPath.row] objectForKey:@"author"];
    cell.scoreLabel.text = [[[commentsData objectAtIndex:indexPath.row] objectForKey:@"score"] stringValue];
    cell.timeLabel.text = @"4 hours ago"; //TODO: Placeholder, replace!
    cell.bodyTextView.text = [[commentsData objectAtIndex:indexPath.row] objectForKey:@"body"];
    
    /*
    // Content
    //create the string
    NSString *sysFontName = @"Helvetica Neue";
    NSString *sysFontSize = @"15pt";
    NSMutableString *html = [NSMutableString stringWithFormat: @"<html><head><title></title></head><body style=\"background:transparent;font-family:%@;font-size:%@; \">",sysFontName, sysFontSize];
    //continue building the string
    
    //NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[[[commentsData objectAtIndex:indexPath.row] objectForKey:@"body_html"] dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    NSString *markdownString = [[commentsData objectAtIndex:indexPath.row] objectForKey:@"body"];
    [html appendString:[MMMarkdown HTMLStringWithMarkdown:markdownString error:nil]];
    [html appendString:@"</body></html>"];
    
    
    //pass the string to the webview
    //sizingCell.bodyWebView.delegate = sizingCell;
    cell.bodyWebView.delegate = self;
    [cell.bodyWebView loadHTMLString:[html description] baseURL:nil];
    cell.bodyWebView.scrollView.scrollEnabled = NO;
    */
    
    [cell updateConstraints];
    [cell layoutSubviews];
}



-(void)webViewDidFinishLoad:(UIWebView *)webView {
    CGRect frame = webView.frame;
     frame.size.height = 1;
     webView.frame = frame;
     CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
     frame.size = fittingSize;
     webView.frame = frame;
     webViewHeight = webView.scrollView.contentSize.height;
     // TODO: Remove Debug
     NSLog(@"size: %f, %f", fittingSize.width, fittingSize.height);
    NSLog(@"content height: %f", webView.scrollView.contentSize.height);
    

    
    //self.webViewHeightConstraint.constant = webView.scrollView.contentSize.height;
    //  NSLog(@"THIS IS WHAT IM ACTUALLY INTERETED IN: %@", self.webViewHeightConstraint);

}



/*

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    static CommentTableViewCell *sizingCell = nil;
    //  GCD, see https://developer.apple.com/library/mac/documentation/Performance/Reference/GCD_libdispatch_Ref/index.html#//apple_ref/c/func/dispatch_once
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //  This part is only ran once
        sizingCell = [self.tableView dequeueReusableCellWithIdentifier:@"commentCell"];
    });
    sizingCell.authorLabel.text = [[commentsData objectAtIndex:indexPath.row] objectForKey:@"author"];
    sizingCell.scoreLabel.text = [[[commentsData objectAtIndex:indexPath.row] objectForKey:@"score"] stringValue];
    sizingCell.timeLabel.text = @"4 hours ago"; //TODO: Placeholder, replace!
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    CGFloat height = (size.height) + webViewHeight;
    NSLog(@"Cell height: %f", height);
    return height + 1.0f;
    
} */



// None of the Table Cells are selectable
// TODO: Disable later for replys of comments etc.
- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)path {
    return nil;
}


// TODO: Move to Model
-(NSURL *) urlFromPermalink: (NSString *) permalink {
    NSString *redditURL = @"http://reddit.com";
    NSString *json = @".json";
    NSString *construct = [[redditURL stringByAppendingString:permalink] stringByAppendingString:json];
    NSURL *validPermalinkURL = [NSURL URLWithString:construct];
    return validPermalinkURL;
}

// TODO: rename function
// TODO: Move to Model
-(NSString *) createStringForWebView: (NSString *) body {
    NSMutableString *html = [NSMutableString stringWithString: @"<html><head><title></title></head><body style=\"background:transparent;\">"];
    NSError *error;
    NSString *htmlString = [MMMarkdown HTMLStringWithMarkdown:body error:&error];
    [html appendString:htmlString];
    [html appendString:@"</body></html>"];
    //NSLog(@"%@", [html description]);
    return [html description];
}

-(NSString *) decodeMarkdownForString: (NSString *) string {
    NSError *error;
    NSString *htmlString = [MMMarkdown HTMLStringWithMarkdown:string error:&error];
    
    if (!error) {
        return htmlString;
    } else {
        return @"error";
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"test";
}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
