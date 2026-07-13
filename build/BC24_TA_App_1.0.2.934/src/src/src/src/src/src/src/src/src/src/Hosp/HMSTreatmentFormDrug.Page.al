Page 50821 "HMS Treatment Form Drug"
{
    PageType = ListPart;
    SourceTable = "HMS Treatment Form Drug";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field(DrugGroup; Rec."Product Group")
                {
                    ApplicationArea = Basic;
                    Caption = 'Drug Group';
                    ToolTip = 'Specifies the value of the Drug Group field.';
                }
                field(DrugNo; Rec."Drug No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Drug No. field.';
                }
                field(DrugName; Rec."Drug Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Drug Name field.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Quantity field.';
                }
                field(UnitOfMeasure; Rec."Unit Of Measure")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Unit Of Measure field.';
                }
                field(Dosage; Rec.Dosage)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Dosage field.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
                field(Issued; Rec.Issued)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Issued field.';
                }
                field(MarkedasIncompatible; Rec."Marked as Incompatible")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Marked as Incompatible field.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(PrescribeDrugs)
            {
                ApplicationArea = Basic;
                Caption = '&Prescribe Drugs';
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the &Prescribe Drugs action.';

                trigger OnAction()
                begin
                    if Confirm('Alert Pharmacy About Prescription?') = false then begin exit end;
                    HMSSetup.Reset;
                    HMSSetup.Get();
                    NewNo := NoSeriesMgt.GetNextNo(HMSSetup."Pharmacy Nos", 0D, true);

                    /*Get the treatment from the database*/
                    TreatmentHeader.Reset;
                    if TreatmentHeader.Get(Rec."Treatment No.") then begin
                        PharmHeader.Reset;
                        PharmHeader.Init;
                        PharmHeader."Pharmacy No." := NewNo;
                        PharmHeader."Pharmacy Date" := Today;
                        PharmHeader."Pharmacy Time" := Time;
                        PharmHeader."Request Area" := PharmHeader."request area"::Doctor;
                        PharmHeader."Patient No." := TreatmentHeader."Patient No.";
                        PharmHeader."Student No." := TreatmentHeader."Student No.";
                        PharmHeader."Employee No." := TreatmentHeader."Employee No.";
                        PharmHeader."Relative No." := TreatmentHeader."Relative No.";
                        PharmHeader."Link Type" := 'Doctor';
                        PharmHeader."Link No." := Rec."Treatment No.";
                        PharmHeader.Insert();

                        TreatmentLine.Reset;
                        TreatmentLine.SetRange(TreatmentLine."Treatment No.", Rec."Treatment No.");
                        if TreatmentLine.Find('-') then begin
                            repeat
                                PharmLine.Init;
                                PharmLine."Pharmacy No." := NewNo;
                                PharmLine."No." := TreatmentLine."Drug No.";
                                PharmLine.Quantity := TreatmentLine.Quantity;
                                PharmLine.Validate(PharmLine.Quantity);
                                PharmLine."Measuring Unit" := TreatmentLine."Unit Of Measure";
                                PharmLine.Validate(PharmLine.Quantity);
                                PharmLine.Dosage := TreatmentLine.Dosage;
                                PharmLine.Pharmacy := TreatmentLine."Pharmacy Code";
                                PharmLine."Link Code" := TreatmentHeader."Link No.";
                                PharmLine.Insert();
                            until TreatmentLine.Next = 0;
                        end;
                        Message('The Prescription has been sent to the Pharmacy for Issuance');
                    end;

                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        DrugNoOnFormat;
        DrugNameOnFormat;
        QuantityOnFormat;
        UnitOfMeasureOnFormat;
        DosageOnFormat;
    end;

    var
        HMSSetup: Record "HMS Setup";
        NoSeriesMgt: Codeunit "No. Series";
        NewNo: Code[20];
        TreatmentHeader: Record "HMS Treatment Form Header";
        TreatmentLine: Record "HMS Treatment Form Drug";
        PharmHeader: Record "HMS Pharmacy Header";
        PharmLine: Record "HMS Pharmacy Line";

    local procedure DrugNoOnFormat()
    begin
        if Rec."Marked as Incompatible" = true then;
    end;

    local procedure DrugNameOnFormat()
    begin
        if Rec."Marked as Incompatible" = true then;
    end;

    local procedure QuantityOnFormat()
    begin
        if Rec."Marked as Incompatible" = true then;
    end;

    local procedure UnitOfMeasureOnFormat()
    begin
        if Rec."Marked as Incompatible" = true then;
    end;

    local procedure DosageOnFormat()
    begin
        if Rec."Marked as Incompatible" = true then;
    end;
}

