Page 50846 "HMS Treatment Form Admission"
{
    PageType = Document;
    SourceTable = "HMS Treatment Admission";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field(WardNo; Rec."Ward No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Ward No. field.';
                }
                field(BedNo; Rec."Bed No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Bed No. field.';
                }
                field(DateOfAdmission; Rec."Date Of Admission")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Of Admission field.';
                }
                field(AdmissionReason; Rec."Admission Reason")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Admission Reason field.';
                }
                field(AdmissionRemarks; Rec."Admission Remarks")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Admission Remarks field.';
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
            action(PlaceRequest)
            {
                ApplicationArea = Basic;
                Caption = '&Place Request';
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the &Place Request action.';

                trigger OnAction()
                begin
                    /*Ask for user confirmation*/
                    HMSSetup.Reset;
                    HMSSetup.Get();
                    NewNo := NoSeriesMgt.GetNextNo(HMSSetup."Admission Request Nos", 0D, true);
                    if Confirm('Send the admission request?', false) = false then begin exit end;
                    TreatmentHeader.Reset;
                    if TreatmentHeader.Get(Rec."Treatment No.") then begin
                        AdmissionHeader.Reset;
                        AdmissionHeader.Init;
                        AdmissionHeader."Admission No." := NewNo;
                        AdmissionHeader."Admission Date" := Today;
                        AdmissionHeader."Admission Time" := Time;
                        AdmissionHeader."Admission Area" := AdmissionHeader."admission area"::Doctor;
                        AdmissionHeader."Patient No." := TreatmentHeader."Patient No.";
                        AdmissionHeader."Employee No." := TreatmentHeader."Treatment No.";
                        AdmissionHeader."Relative No." := TreatmentHeader."Relative No.";
                        AdmissionHeader.Ward := Rec."Ward No.";
                        AdmissionHeader.Bed := Rec."Bed No.";
                        AdmissionHeader.Doctor := TreatmentHeader."Doctor ID";
                        AdmissionHeader.Remarks := Rec."Admission Remarks";
                        AdmissionHeader."Admission Reason" := Rec."Admission Reason";
                        AdmissionHeader."Student No." := TreatmentHeader."Student No.";
                        AdmissionHeader."Link Type" := 'Doctor';
                        AdmissionHeader."Link No." := TreatmentHeader."Treatment No.";
                        AdmissionHeader.Insert();
                        Message('The Admission Request has been sent');
                    end;

                end;
            }
        }
    }

    var
        TreatmentHeader: Record "HMS Treatment Form Header";
        AdmissionHeader: Record "HMS Admission Form Header";
        HMSSetup: Record "HMS Setup";
        NoSeriesMgt: Codeunit "No. Series";
        NewNo: Code[20];
}

