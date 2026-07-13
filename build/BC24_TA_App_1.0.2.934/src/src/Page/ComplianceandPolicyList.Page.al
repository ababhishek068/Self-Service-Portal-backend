page 51455 "Compliance and Policy List"
{
    ApplicationArea = All;
    Caption = 'Compliance and Policy List';
    PageType = List;
    SourceTable = "Compliance and Policy";
    CardPageId = "Compliance and Policy Card";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Emp Id"; Rec."Emp Id")
                {
                    ToolTip = 'Specifies the value of the Emp Id field.', Comment = '%';
                }
                field("Hr Policy No"; Rec."Hr Policy No")
                {
                    ToolTip = 'Specifies the value of the Hr Policy No field.', Comment = '%';
                }
                field("Hr policy description"; Rec."Hr policy description")
                {
                    ToolTip = 'Specifies the value of the Hr policy description field.', Comment = '%';
                }
                field("Acknowledgement Date"; Rec."Acknowledgement Date")
                {
                    ToolTip = 'Specifies the value of the Acknowledgement Date field.', Comment = '%';
                }
                field("Acknowledgement Status"; Rec."Acknowledgement Status")
                {
                    ToolTip = 'Specifies the value of the Acknowledgement Status field.', Comment = '%';
                }
                field("Delivery Method"; Rec."Delivery Method")
                {
                    ToolTip = 'Specifies the value of the Delivery Method field.', Comment = '%';
                }
                field("Expiry Date"; Rec."Expiry Date")
                {
                    ToolTip = 'Specifies the value of the Expiry Date field.', Comment = '%';
                }
            }
        }
    }
}
