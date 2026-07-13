Page 50478 "Vendor Contacts Card"
{
    CardPageID = "Donor Contacts Card";
    DeleteAllowed = false;
    Editable = true;
    PageType = Card;
    SourceTable = "Vendor Contacts";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(Group) { }
            field("Code"; Rec.Code)
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the Code field.';
            }
            field(VendorCode; Rec."Vendor Code")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the Vendor Code field.';
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
            field(City; Rec.City)
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the City field.';
            }
            field(Contact; Rec.Contact)
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the value of the Contact field.';
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

