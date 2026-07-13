page 51474 "Hardship Rates"
{
    ApplicationArea = All;
    Caption = 'Hardship Rates';
    PageType = List;
    SourceTable = "Hardhsip Rates";
    UsageCategory = Administration;
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Region Code";"Region Code")
                {
                    ToolTip = 'Specifies the value of the Region Code field.', Comment = '%';
                }
                field("Region Name";"Region Name")
                {
                    ToolTip = 'Specifies the value of the Region Name field.', Comment = '%';
                }
                field("Rate(%)"; Rec."Rate(%)")
                {
                    ToolTip = 'Specifies the value of the Rate(%) field.', Comment = '%';
                }
                field(Taxed;Taxed){}
                field("Created By"; Rec."Created By")
                {
                    ToolTip = 'Specifies the value of the Created By field.', Comment = '%';
                }
                field("Date Created"; Rec."Date Created")
                {
                    ToolTip = 'Specifies the value of the Date Created field.', Comment = '%';
                }
            }
        }
    }
}
