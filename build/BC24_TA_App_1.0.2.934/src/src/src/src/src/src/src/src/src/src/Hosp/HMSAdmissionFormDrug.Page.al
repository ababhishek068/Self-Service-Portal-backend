Page 50422 "HMS Admission Form Drug"
{
    PageType = ListPart;
    SourceTable = "HMS Admission Drug Prescribe";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field("Admission No."; Rec."Admission No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Admission No. field.';
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
                field(MarkedasIncompatible; Rec."Marked as Incompatible")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Marked as Incompatible field.';
                }
                field(Issued; Rec.Issued)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Issued field.';
                }
                field(ActualQuantityIssued; Rec."Actual Quantity Issued")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Actual Quantity Issued field.';
                }
                field(RemainingQuantity; Rec."Remaining Quantity")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Remaining Quantity field.';
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
                    AdmissionHeader.Reset;
                    if AdmissionHeader.Get(Rec."Admission No.") then begin
                        PharmHeader.Reset;
                        PharmHeader.Init;
                        PharmHeader."Pharmacy No." := NewNo;
                        PharmHeader."Pharmacy Date" := Today;
                        PharmHeader."Pharmacy Time" := Time;
                        PharmHeader."Request Area" := PharmHeader."request area"::Doctor;
                        PharmHeader."Patient No." := AdmissionHeader."Patient No.";
                        PharmHeader."Student No." := AdmissionHeader."Student No.";
                        PharmHeader."Employee No." := AdmissionHeader."Employee No.";
                        PharmHeader."Relative No." := AdmissionHeader."Relative No.";
                        PharmHeader."Link Type" := 'Admission';
                        PharmHeader."Link No." := Rec."Admission No.";
                        PharmHeader.Insert();

                        AdmissionLine.Reset;
                        AdmissionLine.SetRange(AdmissionLine."Admission No.", Rec."Admission No.");
                        if AdmissionLine.Find('-') then begin
                            repeat
                                PharmLine.Init;
                                PharmLine."Pharmacy No." := NewNo;
                                PharmLine."No." := AdmissionLine."Drug No.";
                                PharmLine.Quantity := AdmissionLine.Quantity;
                                PharmLine.Validate(PharmLine.Quantity);
                                PharmLine."Measuring Unit" := AdmissionLine."Unit Of Measure";
                                PharmLine.Validate(PharmLine.Quantity);
                                PharmLine.Dosage := AdmissionLine.Dosage;
                                //  PharmLine.Pharmacy:=AdmissionLine."Pharmacy Code";
                                PharmLine.Insert();
                            until AdmissionLine.Next = 0;
                        end;
                        Message('The Prescription has been sent to the Pharmacy for Issuance');
                    end;

                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        PharmacyCodeOnFormat;
        DrugNoOnFormat;
        DrugNameOnFormat;
        QuantityOnFormat;
        UnitOfMeasureOnFormat;
        DosageOnFormat;
        RemarksOnFormat;
        ActualQuantityIssuedOnFormat;
        RemainingQuantityOnFormat;
    end;

    var
        HMSSetup: Record "HMS Setup";
        NoSeriesMgt: Codeunit "No. Series";
        NewNo: Code[20];
        AdmissionHeader: Record "HMS Admission Form Header";
        AdmissionLine: Record "HMS Admission Drug Prescribe";
        PharmHeader: Record "HMS Pharmacy Header";
        PharmLine: Record "HMS Pharmacy Line";

    local procedure PharmacyCodeOnFormat()
    begin
        if Rec."Marked as Incompatible" = true then;
    end;

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

    local procedure RemarksOnFormat()
    begin
        if Rec."Marked as Incompatible" = true then;
    end;

    local procedure ActualQuantityIssuedOnFormat()
    begin
        if Rec."Marked as Incompatible" = true then;
    end;

    local procedure RemainingQuantityOnFormat()
    begin
        if Rec."Marked as Incompatible" = true then;
    end;
}

