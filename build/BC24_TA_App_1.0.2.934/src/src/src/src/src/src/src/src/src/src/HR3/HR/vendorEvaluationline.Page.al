namespace ABH_UAT.ABH_UAT;

page 51546 "Vendor Evaluation line"
{
    ApplicationArea = All;
    Caption = 'Vendor Evaluation line';
    PageType = ListPart;
    SourceTable =  "Vendor Evaluation Lines";
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Rate Code"; Rec."Rate Code")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Rate Code field.', Comment = '%';
                }
                field("Rate Factor"; Rec."Rate Factor")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Rate Factor field.', Comment = '%';
                }
                field(Rate; Rec.Rate)
                {
                    ToolTip = 'Specifies the value of the Rate field.', Comment = '%';
                }
                field("Value"; Rec."Value")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Value field.', Comment = '%';
                }
            }
        }
    }
}
