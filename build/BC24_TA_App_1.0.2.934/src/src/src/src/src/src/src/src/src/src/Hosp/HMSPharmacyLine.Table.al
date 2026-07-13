Table 50599 "HMS Pharmacy Line"
{

    fields
    {
        field(1; "Pharmacy No."; Code[20])
        {
            TableRelation = "HMS Pharmacy Header"."Pharmacy No.";
        }
        field(2; "No."; Code[20])
        {
            Caption = 'Drug No.';
            NotBlank = true;
            TableRelation = Item;

            trigger OnValidate()
            begin
                hmssetup.Get('');

                //
                // HMSPharmLine.RESET;
                // HMSPharmLine.SETRANGE(HMSPharmLine."Patient No","Patient No");
                // HMSPharmLine.SETRANGE("Issue Date","Issue Date");
                // HMSPharmLine.SETRANGE(HMSPharmLine."No.","No.");
                // IF HMSPharmLine.COUNT>1 THEN
                //  IF CONFIRM('The selected patient has been issued Drug No. '+"No."+' more than onces on the same day. Do want to proceed?',FALSE) THEN ERROR('Aborted');

                HMSPharmHD.Get("Pharmacy No.");
                HMSPatient.Get(HMSPharmHD."Patient No.");

                if Item.Get("No.") then begin
                    "Unit Cost" := Item."Unit Cost";
                    HMSPatient.Reset;
                    HMSPatient.SetRange(HMSPatient."Patient No.", HMSPharmHD."Patient No.");
                    if HMSPatient.Find('-') then
                        if HMSPatient."Patient Type" = HMSPatient."patient type"::Student then "Unit Price" := Item."Unit Price";
                    if HMSPatient."Patient Type" = HMSPatient."patient type"::Private then "Unit Price" := Item."Unit Price";


                    Item.CalcFields(Item.Inventory);
                    // IF Item.Inventory<=0 THEN ERROR('There is no enough stock');

                end;

                CalculateQtyAndPrices();

                if Item.Get("No.") then begin
                    "Drug Name" := Item.Description;
                    "Measuring Unit" := Item."Base Unit of Measure";
                    /* Route := Item.Route;
                     Frequency := Item.Frequency;
                     Dosage := Item.Dosage;
                     Take := Item.Take;
                     "Number of Days" := Item."Number of Days";*/
                    //  IF CalcDosage(Dosage)=TRUE THEN BEGIN
                    //   Quantity  := Take * Frequency * "Number of Days";
                    //   "Issued Units"    :=Take * Frequency * "Number of Days";
                    //   "Issued Quantity"   :=Take * Frequency * "Number of Days";
                    //  END;

                end;


                if HMSPharmHD.Get("Pharmacy No.") then begin
                    "Link Code" := HMSPharmHD."Link No.";

                    HMSPatient.Reset;
                    HMSPatient.SetRange(HMSPatient."Patient No.", HMSPharmHD."Patient No.");
                    if HMSPatient.Find('-') then begin
                        if HMSPatient.Inpatient = true then
                            Location := hmssetup."Pharmacy In Patient Location"
                        else
                            Location := hmssetup."Pharmacy Location";
                    end;

                    // IF HMSPharmHD."Request Area"=HMSPharmHD."Request Area"::Doctor THEN
                    if TreatH.Get(HMSPharmHD."Link No.") then
                        "Link Code" := TreatH."Link No.";
                end;
                // ERROR('Test3-'+"Link Code");
                if HMSObs.Get("Link Code") then
                    "Link Code" := HMSObs."Link No.";


            end;
        }
        field(3; "Drug Name"; Text[100])
        {
            CalcFormula = lookup(Item.Description where("No." = field("No.")));
            FieldClass = FlowField;
        }
        field(4; Quantity; Decimal)
        {

            trigger OnValidate()
            begin
                CalculateQtyAndPrices();
                "Total Price" := Quantity * "Unit Price";
                "Insurance Total Amount" := Quantity * "Insurance Amount";
                "Issued Quantity" := Quantity;
                if Quantity < 0 then Error('You cannot enter a negative quantity');

                HMSPharmHD.Get("Pharmacy No.");
                if TreatH.Get(HMSPharmHD."Link No.") then
                    TreatDrug.SetRange(TreatDrug."Treatment No.", TreatH."Treatment No.");
                TreatDrug.SetRange(TreatDrug."Drug No.", "No.");
                if TreatDrug.Find('-') then begin
                end else begin
                    TreatDrug.Init;
                    TreatDrug."Treatment No." := TreatH."Treatment No.";
                    TreatDrug."Drug No." := "No.";
                    TreatDrug.Validate("Drug No.");
                    TreatDrug.Quantity := Quantity;
                    TreatDrug.Validate(Quantity);
                    TreatDrug.Status := TreatDrug.Status::Forwarded;
                    TreatDrug.Insert;
                end;
            end;
        }
        field(5; "Measuring Unit"; Code[20])
        {
            TableRelation = "Item Unit of Measure".Code where("Item No." = field("No."));
        }
        field(6; "Unit Price"; Decimal)
        {

            trigger OnValidate()
            begin
                "Total Price" := Quantity * "Unit Price";
            end;
        }
        field(7; "Actual Qty"; Decimal) { }
        field(8; "Actual Price"; Decimal) { }
        field(9; "Issued Quantity"; Decimal)
        {

            trigger OnValidate()
            begin
                if "Actual Qty" < "Issued Quantity" then Error('You Cannot Issued more than what is in the stock');
                CalculateQtyAndPrices();
            end;
        }
        field(10; "Issued Units"; Decimal)
        {

            trigger OnValidate()
            begin
                if "Actual Qty" < "Issued Units" then Error('You Cannot Issued more than what is in the stock');

                CalculateQtyAndPrices();
            end;
        }
        field(11; "Issued Price"; Decimal) { }
        field(12; Dosage; Text[100]) { }
        field(13; Remarks; Text[200]) { }
        field(14; Pharmacy; Code[20])
        {
            TableRelation = Location.Code;
        }
        field(15; Remaining; Decimal) { }
        field(16; Date; Date)
        {
            CalcFormula = lookup("HMS Pharmacy Header"."Pharmacy Date" where("Pharmacy No." = field("Pharmacy No.")));
            FieldClass = FlowField;
        }
        field(17; "Linking No."; Code[20])
        {
            CalcFormula = lookup("HMS Pharmacy Header"."Link No." where("Pharmacy No." = field("Pharmacy No.")));
            FieldClass = FlowField;
        }
        field(18; "Link Type"; Code[20])
        {
            CalcFormula = lookup("HMS Pharmacy Header"."Link Type" where("Pharmacy No." = field("Pharmacy No.")));
            FieldClass = FlowField;
        }
        field(19; "Drugs Category"; Code[20])
        {
            TableRelation = Item."Item Category Code";
        }
        field(20; "Patient No"; Code[20])
        {
            CalcFormula = lookup("HMS Pharmacy Header"."Patient No." where("Pharmacy No." = field("Pharmacy No.")));
            FieldClass = FlowField;
        }
        field(22; Invoiced; Boolean) { }
        field(23; Paid; Boolean) { }
        field(24; "Invoice Counter"; Integer)
        {
            FieldClass = Normal;
        }
        field(25; "Link Code"; Code[20]) { }
        field(26; "Link Type LK"; Code[20])
        {
            CalcFormula = lookup("HMS Treatment Form Header"."Link No." where("Treatment No." = field("Linking No.")));
            FieldClass = FlowField;
        }
        field(27; "Posted Doc No"; Code[20]) { }
        field(28; Location; Code[20])
        {
            TableRelation = Location.Code;

            trigger OnValidate()
            begin
                CalculateQtyAndPrices;
            end;
        }
        field(29; Balance; Decimal) { }
        field(30; Take; Decimal)
        {
            Description = 'taken per day';
            NotBlank = true;

            trigger OnValidate()
            begin
                if CalcDosage(Dosage) = true then begin
                    Quantity := Take * Frequency * "Number of Days";
                    "Issued Units" := Take * Frequency * "Number of Days";
                    // "Issued Quantity"   :=Take * Frequency * "Number of Days";
                end;
            end;
        }
        field(31; Route; Option)
        {
            OptionCaption = 'Oral,IV,Rectal,Vaginal,Subcutaneuos,Nasal,Intrathical,Intradermal,Intramuscular,I.M,Topical';
            OptionMembers = Oral,IV,Rectal,Vaginal,Subcutaneuos,Nasal,Intrathical,Intradermal,Intramuscular,"I.M",Topical;
        }
        field(32; Frequency; Integer)
        {
            Description = 'number of days';

            trigger OnValidate()
            begin
                if CalcDosage(Dosage) = true then begin
                    Quantity := Take * Frequency * "Number of Days";
                    "Issued Units" := Take * Frequency * "Number of Days";
                    //  "Issued Quantity"   :=Take * Frequency * "Number of Days";
                end;
            end;
        }
        field(50005; "Number of Days"; Integer)
        {
            Description = 'Number of Days';

            trigger OnValidate()
            begin
                if CalcDosage(Dosage) = true then begin
                    Quantity := Take * Frequency * "Number of Days";
                    "Issued Units" := Take * Frequency * "Number of Days";
                    // "Issued Quantity"   :=Take * Frequency * "Number of Days";
                end;
            end;
        }
        field(50006; "Returns Quantity"; Decimal) { }
        field(50007; Reversed; Boolean) { }
        field(50008; "line no"; Integer) { }
        field(50009; "Total Price"; Decimal) { }
        field(50010; Status; Option)
        {
            CalcFormula = lookup("HMS Pharmacy Header".Status where("Pharmacy No." = field("Pharmacy No.")));
            FieldClass = FlowField;
            OptionMembers = New,Completed,Cancelled;
        }
        field(50011; "Issue Date"; Date)
        {
            CalcFormula = lookup("HMS Pharmacy Header"."Pharmacy Date" where("Pharmacy No." = field("Pharmacy No.")));
            FieldClass = FlowField;
        }
        field(50012; Names; Text[200])
        {
            CalcFormula = lookup("HMS Patient"."Search Name" where("Patient No." = field("Patient No")));
            FieldClass = FlowField;
        }
        field(50013; "Insurance Amount"; Decimal) { }
        field(50014; "Insurance Total Amount"; Decimal) { }
        field(50015; "Unit Cost"; Decimal) { }
        field(50016; "Prescription Dose"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50017; "Item Journal"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50018; "Global Dimension 1"; Code[20])
        {
            CalcFormula = lookup("HMS Patient"."Patient No." where("Patient No." = field("Patient No")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Pharmacy No.", "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        //IF UserRec.GET(USERID) THEN
        //Location:=UserRec."Default Store Location";
    end;

    var
        Item: Record Item;
        HMSPatient: Record "HMS Patient";
        HMSPharmHD: Record "HMS Pharmacy Header";
        DrugsProfitPerc: Decimal;
        TreatH: Record "HMS Treatment Form Header";
        HMSObs: Record "HMS Observation Form Header";
        hmssetup: Record "HMS Setup";
        TreatDrug: Record "HMS Treatment Form Drug";

    local procedure CalculateQtyAndPrices()
    begin
        DrugsProfitPerc := 1;
        /* HMSPharmHD.RESET;
         HMSPharmHD.SETRANGE(HMSPharmHD."Pharmacy No.","Pharmacy No.");
         IF HMSPharmHD.FIND('-') THEN BEGIN
          HMSPatient.RESET;
          HMSPatient.SETRANGE(HMSPatient."Patient No.",HMSPharmHD."Patient No.");
          IF HMSPatient.FIND('-') THEN BEGIN
           HMSDrugsProf.RESET;
           HMSDrugsProf.SETRANGE(HMSDrugsProf."Patients Type",HMSPatient."Patient Type");
           IF HMSDrugsProf.FIND('-') THEN BEGIN
            DrugsProfitPerc:=HMSDrugsProf."Drugs Profit Perc.";
           END;
          END;
            IF HMSPharmHD."Cash Sale"=TRUE THEN
            DrugsProfitPerc:=1.3;

         END;*/

        if Item.Get("No.") then begin
            Item.SetFilter(Item."Location Filter", Location);
            //"Unit Price":=Item."Unit Price";
            HMSPatient.Reset;
            HMSPatient.SetRange(HMSPatient."Patient No.", HMSPharmHD."Patient No.");
            if HMSPatient.Find('-') then
                if HMSPatient."Patient Type" = HMSPatient."patient type"::Student then "Unit Price" := Item."Unit Price";
            if HMSPatient."Patient Type" = HMSPatient."patient type"::Private then "Unit Price" := Item."Unit Price";
            Item.CalcFields(Item.Inventory);
            "Actual Qty" := Item.Inventory;
            "Issued Price" := Item."Unit Price" * DrugsProfitPerc * "Issued Quantity";
            "Actual Price" := Item."Unit Price" * DrugsProfitPerc;
            "Insurance Amount" := Item."Unit Price";
            if HMSPatient.Get("Patient No") then begin
                //  IF Cust.GET(HMSPatient."Insurance No.") THEN
                // IF (Cust."Insurance Rate">0)  THEN BEGIN
                //   "Insurance Amount" := 0.0;
                //    "Insurance Amount":= Item."Unit Price Insurance";
                //"Insurance Amount":= (Item."Unit Price"+(Item."Unit Price"*(Cust."Insurance Rate"/100)));

                //END;
            end;
        end;

    end;

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

