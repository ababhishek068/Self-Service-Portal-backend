namespace ABH_UAT.ABH_UAT;

page 51518 "Probation lines"
{
    ApplicationArea = All;
    Caption = 'Probation lines';
    PageType = ListPart;
    DeleteAllowed=false;
    InsertAllowed=false;
    SourceTable = "Probation Lines";
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Rate Code"; Rec."Rate Code")
                {
                    ToolTip = 'Specifies the value of the Rate Code field.', Comment = '%';
                    Editable=false;
                }
                field("Rate Factor"; Rec."Rate Factor")
                {
                    ToolTip = 'Specifies the value of the Rate Factor field.', Comment = '%';
                    Editable=false;
                }
                field(Rate; Rec.Rate)
                {
                    ToolTip = 'Specifies the value of the Rate field.', Comment = '%';
                }
                field("Value"; Rec."Value")
                {
                    ToolTip = 'Specifies the value of the Value field.', Comment = '%';
                    Editable=false;
                }
            }
        }
    }
}
