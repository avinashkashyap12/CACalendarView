# CACalendarView 
CacalendarView allow to display calendar within the app with flat and and custom UI. A custom caledar can be display with ew lines of code.
Download CACalendarViewSample and add CACalendarView to project.
Add below code for display CACalendarView

    CGSize size = [UIScreen mainScreen].bounds.size;
    CACalendarView *calendarView = [[CACalendarView alloc] initWithFrame:CGRectMake(0, 70, size.width, size.height-200)];
    calendarView.backgroundColor  = [UIColor whiteColor];
    //set delegate
    calendarView.delegate = self;
    [self.view insertSubview:calendarView atIndex:0];
    
    Implement CACalendarDelegate for get selected date
    -(void) didSelectedDate:(NSDate *)date{
        //date format 2017-09-13
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
          [formatter setDateFormat:@"yyyy-MM-dd"];
      NSLog(@"selected date = %@  and string = %@", date, [formatter stringFromDate:date]);
    }
    
    run the application, you can see CACalendarView
    
    ![cacalendar](images/CACalendar.png)
    ![cacalendar](https://user-images.githubusercontent.com/9897883/39405178-11ca6a20-4bbe-11e8-9277-7aed47946066.png)
    
    if you want to disable selection of  previous dates just add a line of code
    calendarView.isDisablePreviousDate = true; 
    
    ![](images/CACalendar_dis.png)
    ![cacalendar_dis](https://user-images.githubusercontent.com/9897883/39405184-42596826-4bbe-11e8-95f1-baa3bea71e6c.png)
    
    you can also set date on calendar by using below code
    [calendarView setSetectedDate:[NSDate date]];
    
     

