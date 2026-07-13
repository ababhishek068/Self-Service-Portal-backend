Page 51425 "HMS Pharmacy SubForm"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = "HMS Pharmacy Header";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field(PharmacyNo; Rec."Pharmacy No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Pharmacy No. field.';
                }
                field(PharmacyDate; Rec."Pharmacy Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Pharmacy Date field.';
                }
                field(PharmacyTime; Rec."Pharmacy Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Pharmacy Time field.';
                }
                field(IssuedBy; Rec."Issued By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Issued By field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }
        }
    }

    actions { }
}

