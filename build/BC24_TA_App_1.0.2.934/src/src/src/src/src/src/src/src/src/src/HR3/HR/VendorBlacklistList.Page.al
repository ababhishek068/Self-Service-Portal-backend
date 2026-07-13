namespace ABH_UAT.ABH_UAT;

page 51562 "Vendor Blacklist List"
{
    ApplicationArea = All;
    Caption = 'Vendor Blacklist List';
    PageType = List;
    SourceTable = BlacklistVendor;
    UsageCategory = Lists;
    CardPageId="Vendor Blacklist Card";
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Blacklist Code"; Rec."Blacklist Code")
                {
                    ToolTip = 'Specifies the value of the Blacklist Code field.', Comment = '%';
                }
                field("Vendor Code"; Rec."Vendor Code")
                {
                    ToolTip = 'Specifies the value of the Vendor Code field.', Comment = '%';
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ToolTip = 'Specifies the value of the Vendor Name field.', Comment = '%';
                }
                field("Contract No"; Rec."Contract No")
                {
                    ToolTip = 'Specifies the value of the Contract No field.', Comment = '%';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    ToolTip = 'Specifies the value of the Reason Code field.', Comment = '%';
                }
                field("Blacklisting Start Date"; Rec."Blacklisting Start Date")
                {
                    ToolTip = 'Specifies the value of the Blacklisting Start Date field.', Comment = '%';
                }
                field("Blacklist Period"; Rec."Blacklist Period")
                {
                    ToolTip = 'Specifies the value of the Blacklist Period field.', Comment = '%';
                }
                field("Blacklisting End Date"; Rec."Blacklisting End Date")
                {
                    ToolTip = 'Specifies the value of the Blacklisting End Date field.', Comment = '%';
                }
            }
        }
    }
}
