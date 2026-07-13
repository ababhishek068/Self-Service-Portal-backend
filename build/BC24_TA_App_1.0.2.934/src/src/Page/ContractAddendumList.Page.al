page 50238 "Contract Addendum List"
{
    PageType = ListPart;
    SourceTable = "Contract Addendum";
    Caption = 'Addendums';
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(pagg)
            {
                field("Contract Reference No"; Rec."Contract Reference No")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Contract Reference No field.';
                }
                field("Contract No."; Rec."Contract No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Contract No. field.';
                }
                field("Contract Type"; Rec."Contract Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Contract Type field.';
                }
                field("Contractor No."; Rec."Contractor No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Contractor No. field.';
                }
                field("Contractor Name"; Rec."Contractor Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Contractor Name field.';
                }
                field("Effective Date"; Rec."Effective Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Effective Date field.';
                }
                field(Duration; Rec.Duration)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Duration field.';
                }
                field("Expiry Date"; Rec."Expiry Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Expiry Date field.';
                }
                field("Contract Value"; Rec."Contract Value")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Contract Value field.';
                }

            }
        }
    }
}