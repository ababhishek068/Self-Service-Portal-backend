namespace ABH_UAT.ABH_UAT;

page 51548 "Tender extension List"
{
    ApplicationArea = All;
    Caption = 'Tender extension List';
    PageType = List;
    CardPageId="Tender extension card";
    SourceTable = "Tender Extension";
    
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
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
            }
        }
    }
}
