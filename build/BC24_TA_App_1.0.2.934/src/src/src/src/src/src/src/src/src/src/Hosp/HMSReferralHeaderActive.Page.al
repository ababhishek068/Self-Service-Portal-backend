Page 51203 "HMS Referral Header Active"
{
    PageType = Document;
    SourceTable = "HMS Referral Header";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(Control1)
            {
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
                field(DateReferred; Rec."Date Referred")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Referred field.';
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
                field(CorrespondenceAddress1; Rec."Correspondence Address 1")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Correspondence Address 1 field.';
                }
                field(TelephoneNo1; Rec."Telephone No. 1")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Telephone No. 1 field.';
                }
                field(Email; Rec.Email)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Email field.';
                }
                field(Diagnosis; Rec.Diagnosis)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Diagnosis field.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Functions)
            {
                Caption = '&Functions';
                action(ReferralCompleted)
                {
                    ApplicationArea = Basic;
                    Caption = 'Referral Completed';
                    Image = Refresh;
                    Promoted = true;
                    ToolTip = 'Executes the Referral Completed action.';

                    trigger OnAction()
                    begin
                        if Confirm('Referrral Confirmed?', true) = false then begin exit end;

                        Rec.Status := Rec.Status::Released;
                        Rec.Modify;
                        Message('The Referral has been confirmed');
                    end;
                }
                action(ProgressNotes)
                {
                    ApplicationArea = Basic;
                    Caption = 'Progress Notes';
                    Image = PutawayLines;
                    Promoted = true;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name" = const(15),
                                  "No." = field("Treatment no.");
                    ToolTip = 'Executes the Progress Notes action.';
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        OnAfterGetCurrRecord;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        OnAfterGetCurrRecord;
    end;

    var
        PatientName: Text[100];
        HospitalName: Text[100];
        Patient: Record "HMS Patient";
        Hospital: Record Vendor;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        PatientName := '';
        HospitalName := '';

        Patient.Reset;
        if Patient.Get(Rec."Patient No.") then begin
            PatientName := Patient.Surname + ' ' + Patient."Middle Name" + ' ' + Patient."Last Name";
        end;

        Hospital.Reset;
        if Hospital.Get(Rec."Hospital No.") then begin
            HospitalName := Hospital.Name;
        end;
    end;
}

