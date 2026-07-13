Page 50819 "HMS Treatment Form Radiology"
{
    PageType = ListPart;
    SourceTable = "HMS Treatment Form Radiology";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field(RadiologyTypeCode; Rec."Radiology Type Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Radiology Type Code field.';
                }
                field(RadiologyTypeName; Rec."Radiology Type Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Radiology Type Name field.';
                }
                field(DateDue; Rec."Date Due")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Due field.';
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
            action(RequestTests)
            {
                ApplicationArea = Basic;
                Caption = '&Request Tests';
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the &Request Tests action.';

                trigger OnAction()
                begin
                    if Confirm('Send Radiology Request?', false) = false then begin exit end;

                    HMSSetup.Reset;
                    HMSSetup.Get();
                    NewNo := NoSeriesMgt.GetNextNo(HMSSetup."Radiology Nos", 0D, true);
                    TreatmentHeader.Reset;
                    if TreatmentHeader.Get(Rec."Treatment No.") then begin
                        RadiologyHeader.Reset;
                        RadiologyHeader.Init;
                        RadiologyHeader."Radiology No." := NewNo;
                        RadiologyHeader."Radiology Date" := Today;
                        RadiologyHeader."Radiology Time" := Time;
                        RadiologyHeader."Radiology Area" := RadiologyHeader."radiology area"::Doctor;
                        RadiologyHeader."Patient No." := TreatmentHeader."Patient No.";
                        RadiologyHeader."Student No." := TreatmentHeader."Student No.";
                        RadiologyHeader."Employee No." := TreatmentHeader."Employee No.";
                        RadiologyHeader."Relative No." := TreatmentHeader."Relative No.";
                        RadiologyHeader."Link No." := TreatmentHeader."Treatment No.";
                        RadiologyHeader."Link Type" := 'Doctor';
                        RadiologyHeader.Insert();

                        /*Insert the lines*/
                        TreatmentLine.Reset;
                        TreatmentLine.SetRange(TreatmentLine."Treatment No.", Rec."Treatment No.");
                        if TreatmentLine.Find('-') then begin
                            repeat
                                RadiologyLine.Reset;
                                RadiologyLine.Init;
                                RadiologyLine."Radiology no." := NewNo;
                                RadiologyLine."Radiology Type Code" := TreatmentLine."Radiology Type Code";
                                RadiologyLine.Insert();
                            until TreatmentLine.Next = 0;
                        end;
                    end;
                    Report.Run(70135209, true, true, TreatmentHeader);
                    Message('Radiology Test Request Forwarded');

                end;
            }
        }
    }

    var
        TreatmentHeader: Record "HMS Treatment Form Header";
        TreatmentLine: Record "HMS Treatment Form Radiology";
        RadiologyHeader: Record "HMS Radiology Form Header";
        RadiologyLine: Record "HMS Radiology Form Line";
        NewNo: Code[20];
        NoSeriesMgt: Codeunit "No. Series";
        HMSSetup: Record "HMS Setup";
}

