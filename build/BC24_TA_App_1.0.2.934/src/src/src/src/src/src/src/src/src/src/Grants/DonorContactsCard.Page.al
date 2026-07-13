Page 50040 "Donor Contacts Card"
{
    DeleteAllowed = false;
    Editable = true;
    PageType = Card;
    SourceTable = "Donor Contacts";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(Group)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(DonorCode; Rec."Donor Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Donor Code field.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Address field.';
                }
                field(Address2; Rec."Address 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Address 2 field.';
                }
                field(Email; Rec.Email)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Email field.';
                }
                field(TelephoneNo; Rec."Telephone No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Telephone No field.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1000000002; Outlook) { }
            systempart(Control1000000001; Notes) { }
            systempart(Control1000000000; Links) { }
        }
    }

    actions { }
}

