namespace ABH_UAT.ABH_UAT;

page 51550 "Tender Cancellation list"
{
    ApplicationArea = All;
    Caption = 'Tender Cancellation list';
    PageType = List;
    CardPageId="Tender Cancellation Card";
    SourceTable = "Tender Cancellation";
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Req No"; Rec."Req No")
                {
                    ToolTip = 'Specifies the value of the Req No field.', Comment = '%';
                }
                field("Tender No"; Rec."Tender No")
                {
                    ToolTip = 'Specifies the value of the Tender No field.', Comment = '%';
                }
                field("Tender Name"; Rec."Tender Name")
                {
                    ToolTip = 'Specifies the value of the Tender Name field.', Comment = '%';
                }
                field("Tender Type"; Rec."Tender Type")
                {
                    ToolTip = 'Specifies the value of the Tender Type field.', Comment = '%';
                }
                field("Date Created"; Rec."Date Created")
                {
                    ToolTip = 'Specifies the value of the Date Created field.', Comment = '%';
                }
                field("Created By"; Rec."Created By")
                {
                    ToolTip = 'Specifies the value of the Created By field.', Comment = '%';
                }
            }
        }
    }
}
