Page 50333 "Leave Types"
{
    PageType = List;
    SourceTable = "Leave Types";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(Days; Rec.Days)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Days field.';
                }
                field(UnlimitedDays; Rec."Unlimited Days")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Unlimited Days field.';
                }
                field(Gender; Rec.Gender)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Gender field.';
                }
                field(Balance; Rec.Balance)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Balance field.';
                }
                field(MaxCarryForwardDays; Rec."Max Carry Forward Days")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Max Carry Forward Days field.';
                }
                field(InclusiveofHolidays; Rec."Inclusive of Holidays")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Inclusive of Holidays field.';
                }
                field(InclusiveofSaturday; Rec."Inclusive of Saturday")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Inclusive of Saturday field.';
                }
                field(InclusiveofSunday; Rec."Inclusive of Sunday")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Inclusive of Sunday field.';
                }
                field(OffHolidaysDaysLeave; Rec."Off/Holidays Days Leave")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Off/Holidays Days Leave field.';
                }
                field(Annual;Annual){}
                field("Years to Consider for Increment";"Years to Consider for Increment"){}
                field("No of Days to Increment with";"No of Days to Increment with"){
                    
                }
                field("Mourning leave?";"Mourning leave?"){}
                field("Maternity?";"Maternity?"){}
                field("Days before Delivery";"Days before Delivery"){}
                field("leave without pay";"leave without pay"){}
            }
        }
    }

    actions { }

    trigger OnInit()
    begin
        CurrPage.LookupMode := true;
    end;
}

