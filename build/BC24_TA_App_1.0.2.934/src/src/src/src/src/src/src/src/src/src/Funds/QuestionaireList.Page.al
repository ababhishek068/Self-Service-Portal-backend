Page 50708 "Questionaire List"
{
    CardPageID = "Questionaire Card";
    Editable = false;
    PageType = List;
    SourceTable = "CompanyInfo Questionaire";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("TIN No"; Rec."TIN No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the PIN No. field.';
                }
                field(LegalNameofFirm; Rec."Legal Name of Firm")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Legal Name of Firm field.';
                }
                field(Country; Rec.Country)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Country field.';
                }
                field(BuildingName; Rec."Building Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Building Name field.';
                }
                field(TelephoneNo; Rec."Telephone No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Telephone No field.';
                }
                field(MobileNumber; Rec."Mobile Number")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Mobile Number field.';
                }
            }
        }
    }

    actions { }
}

