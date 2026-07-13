Page 51040 "Destination Rate List"
{
    CardPageID = "Destination Rates Card";
    PageType = List;
    SourceTable = "Destination Rate Entry";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(EmployeeJobGroup; Rec."Employee Job Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Employee Job Group field.';
                }
                field(AdvanceCode; Rec."Advance Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Advance Code field.';
                }
                field(DestinationCode; Rec."Destination Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Destination Code field.';
                }
                field(Currency; Rec.Currency)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Currency field.';
                }
                field(DestinationType; Rec."Destination Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Destination Type field.';
                }
                field(DailyRateAmount; Rec."Daily Rate (Amount)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Daily Rate (Amount) field.';
                }
                field(DestinationName; Rec."Destination Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Destination Name field.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control11; Outlook) { }
            systempart(Control12; Notes) { }
            systempart(Control13; MyNotes) { }
            systempart(Control14; Links) { }
        }
    }

    actions { }
}

