Page 51034 "Project Donors"
{
    PageType = Card;
    SourceTable = "Project Donors";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                field(ShortcutDimension1Code; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.';
                }
                field(DonorName; Rec."Donor Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Donor Name field.';
                }
                field(Percentage; Rec.Percentage)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Percentage field.';
                }
                field(AllowedIndirectCost; Rec."Allowed Indirect Cost")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Allowed Indirect Cost field.';
                }
                field(AllowIndirectCost; Rec."Indirect Cost")
                {
                    ApplicationArea = Basic;
                    Caption = 'Allow Indirect Cost';
                    ToolTip = 'Specifies the value of the Allow Indirect Cost field.';
                }
                field(ExpectedDonation; Rec."Expected Donation")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Expected Donation field.';
                }
                field(DonatedAmount; Rec."Donated Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Donated Amount field.';
                }
                field(Balance; Rec.Balance)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Balance field.';
                }
            }
        }
    }

    actions { }

    trigger OnAfterGetRecord()
    begin
        Rec.Balance := Rec."Expected Donation" - Rec."Donated Amount";
    end;
}

