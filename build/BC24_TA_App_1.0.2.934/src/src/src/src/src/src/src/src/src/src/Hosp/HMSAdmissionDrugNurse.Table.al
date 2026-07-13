Table 50703 "HMS Admission Drug Nurse"
{

    fields
    {
        field(1; "Admission No."; Code[20])
        {
            NotBlank = true;
        }
        field(2; "Drug No."; Code[20])
        {
            NotBlank = true;

            trigger OnValidate()
            begin

                /*Check if the drug has any drug within the prescription where it is not compatible*/
                Interaction.Reset;
                Interaction.SetRange(Interaction."Drug No.", "Drug No.");
                if Interaction.Find('-') then begin
                    repeat
                        /*Get the lines of drugs that have been identified as being incompatible with the drug selected*/
                        Line.Reset;
                        Line.SetRange(Line."Admission No.", "Admission No.");
                        Line.SetRange(Line."Drug No.", Interaction."Drug No. 1");
                        if Line.Find('-') then begin
                            Line.CalcFields(Line."Drug Name");
                            if Confirm('Drug:' + Line."Drug Name" + '::' + Interaction."Alert Remarks" + '. CONTINUE?', false) = true then begin
                                Line."Marked as Incompatible" := true;
                                Line.Modify;
                            end
                            else begin
                                Error('Drug Incompatible.Operation Cancelled');
                            end;
                        end;
                        Line.Reset;
                        Line.SetRange(Line."Admission No.", "Admission No.");
                        Line.SetRange(Line."Drug No.", Interaction."Drug No.");
                        if Line.Find('-') then begin
                            Line.CalcFields(Line."Drug Name");
                            if Confirm('Drug:' + Line."Drug Name" + '::' + Interaction."Alert Remarks" + '. CONTINUE?', false) = true then begin
                                Line."Marked as Incompatible" := true;
                                Line.Modify;
                            end
                            else begin
                                Error('Drug Incompatible.Operation Cancelled');
                            end;
                        end;

                    until Interaction.Next = 0;
                end;

            end;
        }
        field(3; "Drug Name"; Text[100])
        {
            CalcFormula = lookup(Item.Description where("No." = field("Drug No.")));
            FieldClass = FlowField;
        }
        field(4; Quantity; Integer) { }
        field(5; "Unit Of Measure"; Code[20])
        {
            NotBlank = true;
            TableRelation = "Item Unit of Measure".Code where("Item No." = field("Drug No."));
        }
        field(6; Remarks; Text[100]) { }
        field(7; "Pharmacy Code"; Code[20])
        {
            NotBlank = true;
            TableRelation = Location.Code;
        }
        field(8; "Actual Quantity"; Decimal) { }
        field(9; Inventory; Decimal) { }
        field(10; Issued; Boolean)
        {

            trigger OnValidate()
            begin
                if Issued = true then begin
                    "Issued Date" := Today;
                    "Issued Time" := Time;
                    "Issued By" := UserId;
                end;
            end;
        }
        field(11; Dosage; Text[200])
        {
            NotBlank = true;
        }
        field(12; "Marked as Incompatible"; Boolean) { }
        field(13; "Actual Quantity Issued"; Decimal)
        {
            CalcFormula = lookup("HMS Pharmacy Line"."Issued Quantity" where("Linking No." = field("Admission No."),
                                                                              "Link Type" = const('ADMISSION'),
                                                                              "No." = field("Drug No.")));
            FieldClass = FlowField;
        }
        field(14; "Remaining Quantity"; Decimal)
        {
            CalcFormula = lookup("HMS Pharmacy Line".Remaining where("Linking No." = field("Admission No."),
                                                                      "Link Type" = const('ADMISSION'),
                                                                      "No." = field("Drug No.")));
            FieldClass = FlowField;
        }
        field(15; "Issued Date"; Date) { }
        field(16; "Issued Time"; Time) { }
        field(17; "Issued By"; Text[100]) { }
        field(18; "Prescription Dose"; Option)
        {
            OptionCaption = ' ,STAT,PRN,PD,TDS,OD,QID,NOCTE,HOURLY';
            OptionMembers = " ",STAT,PRN,PD,TDS,OD,QID,NOCTE,HOURLY;
        }
        field(20; "Patient No"; Code[20])
        {
            CalcFormula = lookup("HMS Admission Form Header"."Patient No." where("Admission No." = field("Admission No.")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Admission No.", "Drug No.", "Issued Date", "Issued Time")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    var
        Interaction: Record "HMS Drug Interaction";
        Line: Record "HMS Admission Drug Prescribe";
}

