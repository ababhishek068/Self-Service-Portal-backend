Table 50588 "HMS Treatment Form Drug"
{

    fields
    {
        field(1; "Treatment No."; Code[20])
        {
            NotBlank = true;
        }
        field(2; "Drug No."; Code[20])
        {
            NotBlank = true;

            trigger OnValidate()
            begin
                Item.Reset;
                Item.SetRange(Item."No.", "Drug No.");
                if Item.Find('-') then begin
                    "Drug Name" := Item.Description;
                    "Unit Of Measure" := Item."Base Unit of Measure";
                    /* Route := Item.Route;
                     Frequency := Item.Frequency;
                     //Dosage := Item.Dosage;
                     Take := Item.Take;
                     "Number of Days" := Item."Number of Days";

                    // //IF CalcDosage(Dosage)=TRUE THEN
                    IF UnitsOfMeasure.GET("Unit Of Measure") THEN
                      IF UnitsOfMeasure."Per Piece"=TRUE THEN
                       Quantity  := Take * Frequency * "Number of Days";*/

                    if Treath.Get("Treatment No.") then
                        HmsPat.SetRange(HmsPat."Patient No.", Treath."Patient No.");
                    if HmsPat.Find('-') then begin
                        if HmsPat."Patient Type" = HmsPat."patient type"::Private then begin
                            "Unit Price" := Item."Unit Price";
                            "Total Price" := Item."Unit Price" * Quantity;
                        end;
                        if HmsPat."Patient Type" = HmsPat."patient type"::Student then begin
                            "Unit Price" := Item."Unit Price";
                            "Total Price" := Item."Unit Price" * Quantity;
                        end;

                    end;
                end;

                /*Check if the drug has any drug within the prescription where it is not compatible*/
                /*Interaction.RESET;
                Interaction.SETRANGE(Interaction."Drug No.","Drug No.");
                IF Interaction.FIND('-') THEN
                  BEGIN
                    REPEAT
                      {Get the lines of drugs that have been identified as being incompatible with the drug selected}
                        Line.RESET;
                        Line.SETRANGE(Line."Treatment No.","Treatment No.");
                        Line.SETRANGE(Line."Drug No.",Interaction."Drug No. 1");
                        IF Line.FIND('-') THEN
                          BEGIN
                            Line.CALCFIELDS(Line."Drug Name");
                            IF CONFIRM('Drug:' + Line."Drug Name" + '::' + Interaction."Alert Remarks" + '. CONTINUE?',FALSE)=TRUE THEN
                              BEGIN
                                Line."Marked as Incompatible":=TRUE;
                                Line.MODIFY;
                              END
                            ELSE
                              BEGIN
                                ERROR('Drug Incompatible.Operation Cancelled');
                              END;
                          END;
                        Line.RESET;
                        Line.SETRANGE(Line."Treatment No.","Treatment No.");
                        Line.SETRANGE(Line."Drug No.",Interaction."Drug No.");
                        IF Line.FIND('-') THEN
                          BEGIN
                            Line.CALCFIELDS(Line."Drug Name");
                            IF CONFIRM('Drug:' + Line."Drug Name" + '::' + Interaction."Alert Remarks" + '. CONTINUE?',FALSE)=TRUE THEN
                              BEGIN
                                Line."Marked as Incompatible":=TRUE;
                                Line.MODIFY;
                              END
                            ELSE
                              BEGIN
                                ERROR('Drug Incompatible.Operation Cancelled');
                              END;
                          END;
                
                    UNTIL Interaction.NEXT=0;
                  END;
                  */

            end;
        }
        field(3; "Drug Name"; Text[100]) { }
        field(4; Quantity; Integer)
        {

            trigger OnValidate()
            begin
                if Treath.Get("Treatment No.") then begin
                    HmsPat.SetRange(HmsPat."Patient No.", Treath."Patient No.");
                    if HmsPat.Find('-') then begin
                        if HmsPat."Patient Type" = HmsPat."patient type"::Private then begin
                            "Unit Price" := Item."Unit Price";
                            "Total Price" := Item."Unit Price" * Quantity;
                        end;
                        if HmsPat."Patient Type" = HmsPat."patient type"::Student then begin
                            "Unit Price" := Item."Unit Price";
                            "Total Price" := Item."Unit Price" * Quantity;
                        end;
                    end;
                end;
            end;
        }
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
        field(10; Issued; Boolean) { }
        field(11; Take; Decimal)
        {
            Description = 'taken per day';
            NotBlank = true;

            trigger OnValidate()
            begin
                //IF CalcDosage(Dosage)=TRUE THEN
                //  Quantity  := Take * Frequency * "Number of Days";
                if UnitsOfMeasure.Get("Unit Of Measure") then
                    if UnitsOfMeasure."Per Piece" = true then
                        Quantity := Take * Frequency * "Number of Days"
                    else
                        Quantity := 1;
            end;
        }
        field(12; "Marked as Incompatible"; Boolean) { }
        field(13; "Product Group"; Code[20])
        {
            //  TableRelation = "Product Group".Code;
        }
        field(14; Route; Option)
        {
            OptionCaption = 'Oral,IV,Rectal,Vaginal,Subcutaneuos,Nasal,Intrathical,Intradermal,Intramuscular,I.M,Topical';
            OptionMembers = Oral,IV,Rectal,Vaginal,Subcutaneuos,Nasal,Intrathical,Intradermal,Intramuscular,"I.M",Topical;
        }
        field(15; Frequency; Integer)
        {
            Description = 'number of days';

            trigger OnValidate()
            begin
                //IF CalcDosage(Dosage)=TRUE THEN
                if UnitsOfMeasure.Get("Unit Of Measure") then
                    if UnitsOfMeasure."Per Piece" = true then
                        Quantity := Take * Frequency * "Number of Days"
                    else
                        Quantity := 1;
            end;
        }
        field(16; Dosage; Code[10]) { }
        field(50005; "Number of Days"; Integer)
        {
            Description = 'Number of Days';

            trigger OnValidate()
            begin
                //IF CalcDosage(Dosage)=TRUE THEN
                if UnitsOfMeasure.Get("Unit Of Measure") then
                    if UnitsOfMeasure."Per Piece" = true then
                        Quantity := Take * Frequency * "Number of Days"
                    else
                        Quantity := 1;
            end;
        }
        field(50006; Posted; Boolean) { }
        field(50007; "IP Status"; Option)
        {
            OptionCaption = ',Ongoing,Stopped';
            OptionMembers = ,Ongoing,Stopped;
        }
        field(50008; Inpatient; Boolean) { }
        field(50009; "Stopped by"; Code[50]) { }
        field(50010; "Stopped Date"; Date) { }
        field(50011; "Prescription Dose"; Code[20]) { }
        field(50012; "Date Taken"; Date) { }
        field(50013; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'New,Forwarded,Completed';
            OptionMembers = New,Forwarded,Completed;
        }
        field(50014; "Unit Price"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50015; "Total Price"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50016; "Lline No"; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(50017; Branch; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Dimension Code" = const('BRANCH'));
        }
    }

    keys
    {
        key(Key1; "Treatment No.", "Product Group", "Drug No.", "Lline No")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    var
        Item: Record Item;
        UnitsOfMeasure: Record "Unit of Measure";
        Treath: Record "HMS Treatment Form Header";
        HmsPat: Record "HMS Patient";

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

