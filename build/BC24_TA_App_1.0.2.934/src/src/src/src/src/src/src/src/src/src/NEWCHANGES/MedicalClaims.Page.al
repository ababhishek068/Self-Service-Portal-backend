namespace ABH_UAT.ABH_UAT;

page 51570 "Medical Claims"
{
    ApplicationArea = All;
    Caption = 'Medical Claims';
    PageType = ListPart;
    SourceTable = "Medical Claim Lines";
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(EntryNo; Rec.EntryNo)
                {
                    ToolTip = 'Specifies the value of the EntryNo field.', Comment = '%';
                    Visible=false;
                }
                field("Staff No"; Rec."Staff No")
                {
                    ToolTip = 'Specifies the value of the Staff No field.', Comment = '%';
                }
                field("Staff Name"; Rec."Staff Name")
                {
                    ToolTip = 'Specifies the value of the Staff Name field.', Comment = '%';
                }
                
                field("Treatment Start Date"; Rec."Treatment Start Date")
                {
                    ToolTip = 'Specifies the value of the Treatment Start Date field.', Comment = '%';
                }
                field("Treatement End Date"; Rec."Treatement End Date")
                {
                    ToolTip = 'Specifies the value of the Treatement End Date field.', Comment = '%';
                }
                field(Amount; Rec."Bill Amount")
                {
                    ToolTip = 'Specifies the value of the Amount field.', Comment = '%';
                }
                field("Glass-Frame Amount";"Glass-Frame Amount"){}
                field("General Health amount";"General Health amount"){}
                field("Amount to recover from Staff";Rec."Amount to recover from Staff"){}
                
            }
        }
    }
}
