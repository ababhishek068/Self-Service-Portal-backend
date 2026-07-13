Page 50822 "HMS Treatment Form Referral"
{
    PageType = ListPart;
    SourceTable = "HMS Treatment Referral";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field(DateReferred; Rec."Date Referred")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Referred field.';
                }
                field(HospitalNo; Rec."Hospital No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Hospital No. field.';
                }
                field(HospitalName; Rec."Hospital Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Hospital Name field.';
                }
                field(Contactperson; Rec."Contact person")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Contact person field.';
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
                    Editable = false;
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(RegisterReferral)
            {
                ApplicationArea = Basic;
                Caption = '&Register Referral';
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the &Register Referral action.';

                trigger OnAction()
                begin
                    if Confirm('Register Referral?', false) = false then begin exit end;

                    TreatmentHeader.Reset;
                    if TreatmentHeader.Get(Rec."Treatment No.") then begin
                        Referral.Init;
                        Referral."Treatment no." := Rec."Treatment No.";
                        Referral."Hospital No." := Rec."Hospital No.";
                        Referral."Patient No." := TreatmentHeader."Patient No.";
                        Referral."Date Referred" := Rec."Date Referred";
                        Referral."Referral Reason" := Rec."Referral Reason";
                        Referral."Referral Remarks" := Rec."Referral Remarks";
                        Referral.Insert();
                    end;
                end;
            }
        }
    }

    var
        Referral: Record "HMS Referral Header";
        TreatmentHeader: Record "HMS Treatment Form Header";
}

