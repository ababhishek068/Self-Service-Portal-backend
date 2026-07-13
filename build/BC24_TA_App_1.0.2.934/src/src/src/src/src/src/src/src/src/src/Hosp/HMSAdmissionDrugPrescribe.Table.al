Table 50771 "HMS Admission Drug Prescribe"
{
    // DrillDownPageID = UnknownPage70135094;
    // LookupPageID = UnknownPage70135094;

    fields
    {
        field(1; "Admission No."; Code[20])
        {
            NotBlank = true;
        }
        field(2; "Drug No."; Code[20])
        {
            TableRelation = Item."No." where("Location Filter" = field("Location Code"));

            trigger OnValidate()
            begin

                if Item.Get("Drug No.") then begin
                    "Drug Name" := Item.Description;
                    "Unit Of Measure" := Item."Base Unit of Measure";
                    // Route := Item.Route;
                    //Frequency := Item.Frequency;
                    //  Dosage := Item.Dosage;
                    //  Take := Item.Take;
                    //  "Number of Days" := Item."Number of Days";

                    ///Triage Patients
                    Observation.SetRange(Observation."Observation No.", "Admission No.");
                    if Observation.Find('-') then begin
                        Patient.Reset;
                        Patient.SetRange(Patient."Patient No.", Observation."Patient No.");
                        if Patient.Find('-') then begin
                            if Patient."Patient Type" = Patient."patient type"::Student then "Unit Price" := Item."Unit Price";
                            if Patient."Patient Type" = Patient."patient type"::Private then "Unit Price" := Item."Unit Price";




                        end;
                    end;

                    //Inpatients
                    Admission.SetRange(Admission."Admission No.", "Admission No.");
                    if Admission.Find('-') then begin
                        Patient.Reset;
                        Patient.SetRange(Patient."Patient No.", Admission."Patient No.");
                        if Patient.Find('-') then begin
                            if Patient."Patient Type" = Patient."patient type"::Student then "Unit Price" := Item."Unit Price";
                            if Patient."Patient Type" = Patient."patient type"::Private then "Unit Price" := Item."Unit Price";


                        end;
                    end;




                    if CalcDosage(Dosage) = true then
                        Quantity := Take * Frequency * "Number of Days";
                    Validate(Quantity);
                end;

                /*Check if the drug has any drug within the prescription where it is not compatible*/
                Interaction.Reset;
                Interaction.SetRange(Interaction."Drug No.", "Drug No.");
                if Interaction.Find('-') then begin
                    repeat
                        /*Get the lines of drugs that have been identified as being incompatible with the drug selected*/
                        Line.Reset;
                        Line.SetRange(Line."Admission No.", "Admission No.");
                        //Line.SETRANGE(Line."Drug No.",Interaction."Drug No. 1");
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
        field(3; "Drug Name"; Text[50]) { }
        field(4; Quantity; Integer)
        {

            trigger OnValidate()
            begin
                Amount := "Unit Price" * Quantity;
            end;
        }
        field(5; "Unit Of Measure"; Code[20])
        {
            NotBlank = true;
            TableRelation = "Item Unit of Measure".Code where("Item No." = field("Drug No."));
        }
        field(6; Remarks; Text[100]) { }
        field(7; "Location Code"; Code[20])
        {
            TableRelation = Location.Code;
        }
        field(8; "Actual Quantity"; Decimal) { }
        field(9; Inventory; Decimal) { }
        field(10; Issued; Boolean) { }
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
        field(15; Take; Decimal)
        {
            Description = 'taken per day';
            NotBlank = true;

            trigger OnValidate()
            begin
                if CalcDosage(Dosage) = true then
                    Quantity := Take * Frequency * "Number of Days";
            end;
        }
        field(16; Route; Option)
        {
            OptionCaption = 'Oral,IV,Rectal,Vaginal,Subcutaneuos,Nasal,Intrathical,Intradermal,Intramuscular,I.M,Topical';
            OptionMembers = Oral,IV,Rectal,Vaginal,Subcutaneuos,Nasal,Intrathical,Intradermal,Intramuscular,"I.M",Topical;
        }
        field(17; Frequency; Integer)
        {
            Description = 'number of days';

            trigger OnValidate()
            begin
                if CalcDosage(Dosage) = true then
                    Quantity := Take * Frequency * "Number of Days";
            end;
        }
        field(50005; "Number of Days"; Integer)
        {
            Description = 'Number of Days';

            trigger OnValidate()
            begin
                if CalcDosage(Dosage) = true then
                    Quantity := Take * Frequency * "Number of Days";
            end;
        }
        field(50006; Posted; Boolean) { }
        field(50007; "Posted By"; Code[200]) { }
        field(50008; "Posted Date"; Date) { }
        field(50009; "Date Created"; Date) { }
        field(50010; "Created By"; Code[200]) { }
        field(50011; Selected; Boolean) { }
        field(50012; "Line No"; Integer)
        {
            AutoIncrement = true;
        }
        field(50013; "Unit Price"; Decimal) { }
        field(50014; Amount; Decimal) { }
        field(50015; "Inventory Group"; Code[20])
        {
            CalcFormula = lookup(Item."Inventory Posting Group" where("No." = field("Drug No.")));
            FieldClass = FlowField;
        }
        field(50017; "Transaction Type"; Code[20])
        {
            TableRelation = "HMS Transactions code"."Transaction Type";
        }
        field(50018; "Posting Date"; Date) { }
    }

    keys
    {
        key(Key1; "Admission No.", "Drug No.", "Location Code", "Line No")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnDelete()
    begin
        if Posted = true then Error('You cannot delete an already posted entry')
    end;

    trigger OnInsert()
    begin
        "Date Created" := Today;
        "Posted Date" := Today;
        "Posting Date" := Today;
        "Created By" := UserId;
    end;

    var
        Interaction: Record "HMS Drug Interaction";
        Line: Record "HMS Admission Drug Prescribe";
        Item: Record Item;
        Observation: Record "HMS Observation Form Header";
        Admission: Record "HMS Admission Form Header";
        Patient: Record "HMS Patient";

    local procedure CalcDosage(Dosages: Code[20]) Calc_Dosage: Boolean
    var
        DosageSetup: Record "HMS Dosage Setup";
    begin
        Calc_Dosage := false;

        DosageSetup.Reset;
        DosageSetup.SetRange(DosageSetup."Dose Code", Dosages);
        if DosageSetup.Find('-') then begin
            Calc_Dosage := DosageSetup."Calculate Dosage";
        end;
    end;
}

