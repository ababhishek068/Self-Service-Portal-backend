Page 50066 "Grant Task Dimensions"
{
    Caption = 'Grant Activity Dimensions';
    DelayedInsert = true;
    PageType = Card;
    SourceTable = "Job-Task Dimension";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(DimensionCode; Rec."Dimension Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Dimension Code field.';
                }
                field(DimensionValueCode; Rec."Dimension Value Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Dimension Value Code field.';
                }
            }
        }
    }

    actions { }
}

