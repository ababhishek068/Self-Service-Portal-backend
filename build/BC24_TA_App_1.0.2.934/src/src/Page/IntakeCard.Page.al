Page 50136 "Intake Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = Intake;

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Code field.';

                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';

                }
                field(Current; Rec.Current)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Current field.';

                }
                field("Current Semester"; Rec."Current Semester")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Current Semester field.';
                }
                field("Reporting Date"; Rec."Reporting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Reporting Date field.';

                }
                field("Reporting End Date"; Rec."Reporting End Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Reporting End Date field.';

                }

            }
        }
    }


}