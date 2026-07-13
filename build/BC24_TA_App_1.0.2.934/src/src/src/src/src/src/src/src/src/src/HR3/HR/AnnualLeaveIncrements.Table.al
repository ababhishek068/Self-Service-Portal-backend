table 51017 "Annual Leave Increments"
{
    Caption = 'Annual Leave Increments';
    DataClassification = ToBeClassified;
    
    fields
    {
        field(1; entryno; Integer)
        {
            Caption = 'entryno';
        }
        field(2; "HR Calendar Yr"; Code[20])
        {
            Caption = 'HR Calendar Yr';
            TableRelation = "HR Leave Calendar".Code where(Current = filter(true));      }
        field(3; "Leave Code"; Code[20])
        {
            Caption = 'Leave Code';
            TableRelation="Leave Types".Code where(Annual=filter(true));
        }
        field(4; "No of Years to consider for increment"; Integer)
        {
            Caption = 'No of Years to consider for increment';
        }
        field(5; "No of days to Increment"; Integer)
        {
            Caption = 'No of days to Increment';
        }
        field(6; "Limit of Years of Service to Consider"; Integer)
        {
            Caption = 'Limit of Years of Service to Consider';
        }
        field(7;"Created By";Code[40]){}
        field(8;"Date Created";Date){}
        field(9;"Time Created";Time){}
    }
    keys
    {
        key(PK; "HR Calendar Yr","Leave Code")
        {
            Clustered = true;
        }
        
    }
    trigger OnInsert()
    begin
        "Date Created":=today;
        "Time Created":=Time;
        "Created By":=UserId;
    end;
}
