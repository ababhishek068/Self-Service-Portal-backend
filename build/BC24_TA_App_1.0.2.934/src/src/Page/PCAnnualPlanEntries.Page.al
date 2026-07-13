page 51145 "PC Annual Plan Entries"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "PC Annual Plan Entries";
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Delivery Unit Type"; Rec."Delivery Unit Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Delivery Unit Type field.';

                }
                field("Delivery Unit"; Rec."Delivery Unit")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Delivery Unit field.';

                }
                field(Output; Rec.Output)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Output field.';
                }
                field(Activity; Rec.Activity)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Activity field.';
                }
                field("Performance Indicator"; Rec."Performance Indicator")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Performance Indicator field.';

                }
                field("Date From"; Rec."Date From")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date From field.';

                }
                field("Date To"; Rec."Date To")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date To field.';

                }
                field(Budget; Rec.Budget)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Budget field.';

                }
                field("Source of Funds"; Rec."Source of Funds")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Source of Funds field.';

                }
            }
        }
    }

    actions { }
}