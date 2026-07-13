Page 51375 "HMS Referral SubForm"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = "HMS Referral Header";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field(Treatmentno; Rec."Treatment no.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Treatment no. field.';
                }
                field(HospitalNo; Rec."Hospital No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Hospital No. field.';
                }
                field(DateReferred; Rec."Date Referred")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Referred field.';
                }
                field(PatientNo; Rec."Patient No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Patient No. field.';
                }
                field(ReferralReason; Rec."Referral Reason")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Referral Reason field.';
                }
                field(ReferralRemarks; Rec."Referral Remarks")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Referral Remarks field.';
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

