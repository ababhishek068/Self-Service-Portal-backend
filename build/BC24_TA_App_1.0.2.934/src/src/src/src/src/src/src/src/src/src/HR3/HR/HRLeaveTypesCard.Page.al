Page 50725 "HR Leave Types Card"
{
    PageType = Card;
    SourceTable = "HR Leave Types";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
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
                field(InclusiveofNonWorkingDays; Rec."Inclusive of Non Working Days")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Inclusive of Non Working Days field.';
                }
                field(UnlimitedDays; Rec."Unlimited Days")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Unlimited Days field.';
                }
            }
        }
    }

    actions { }
}

