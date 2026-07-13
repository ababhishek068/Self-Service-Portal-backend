page 51456 "Compliance and Policy Card"
{
    ApplicationArea = All;
    Caption = 'Compliance and Policy Card';
    PageType = Card;
    SourceTable = "Compliance and Policy";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

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
                field("Version"; Rec."Version")
                {
                    ToolTip = 'Specifies the value of the Version field.', Comment = '%';
                }
                field("Acknowledgement Date"; Rec."Acknowledgement Date")
                {
                    ToolTip = 'Specifies the value of the Acknowledgement Date field.', Comment = '%';
                }
                field("Expiry Date"; Rec."Expiry Date")
                {
                    ToolTip = 'Specifies the value of the Expiry Date field.', Comment = '%';
                }
                field("Delivery Method"; Rec."Delivery Method")
                {
                    ToolTip = 'Specifies the value of the Delivery Method field.', Comment = '%';
                }
                field("Acknowledgement Status"; Rec."Acknowledgement Status")
                {
                    ToolTip = 'Specifies the value of the Acknowledgement Status field.', Comment = '%';
                }

                field("Date Created"; Rec."Date Created")
                {
                    ToolTip = 'Specifies the value of the Date Created field.', Comment = '%';
                }
                field("Time Created"; Rec."Time Created")
                {
                    ToolTip = 'Specifies the value of the Time created field.', Comment = '%';
                }
                field("Created By"; Rec."Created By")
                {
                    ToolTip = 'Specifies the value of the Created By field.', Comment = '%';
                }

            }
        }
    }
}
