table 50938 "BidAnalysis Tender"

{

    fields
    {
        field(1; "Tender No."; Code[20]) { }
        field(2; "Tender Line No."; Integer) { }
        field(3; "Quote No."; Code[20]) { }
        field(4; "Vendor No."; Code[20]) { }
        field(5; "Item No."; Code[20]) { }
        field(6; Description; Text[100]) { }
        field(7; Quantity; Decimal) { }
        field(8; "Unit Of Measure"; Code[20]) { }
        field(9; Amount; Decimal) { }
        field(10; "Line Amount"; Decimal) { }
        field(11; Total; Decimal) { }
        field(12; "Last Direct Cost"; Decimal)
        {
            CalcFormula = lookup(Item."Last Direct Cost" where("No." = field("Item No.")));
            FieldClass = FlowField;
        }
        field(13; Remarks; Text[50])
        {

            trigger OnValidate()
            begin
                PurchLine.Reset;
                PurchLine.SetRange(PurchLine."Document Type", PurchLine."document type"::Quote);
                PurchLine.SetRange(PurchLine."Document No.", "Quote No.");
                PurchLine.SetRange(PurchLine."Line No.", "Tender Line No.");
                if PurchLine.FindSet then begin
                    PurchLine."RFQ Remarks" := Remarks;
                    PurchLine.Modify;
                end
            end;
        }
        field(14; "Vendor Name"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup(Vendor.Name WHERE("No." = FIELD("Vendor No.")));
            Editable = false;

        }
        field(15; "Market Survey Attached"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(16; "TOR/Specifications Attached"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Appointment report"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Opening Minutes"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Due Dilligence"; Boolean)
        {
            Caption = 'Evaluation Report';
            DataClassification = ToBeClassified;
        }
        field(20; "Professional Opinion"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(21; Status; Option)
        {   
            
            CalcFormula = Lookup(TenderAwards.Type WHERE("Vendor No" = FIELD("Vendor No."),
                                                          "Tender No"= FIELD("Tender No.")));
            FieldClass = FlowField;
            OptionCaption = ' ,Awarded,Regret';
            OptionMembers = " ",Award,Regret;
        }
        field(22; Awarded; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(23; "Expiry Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(24; "Notify Vendors"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'Notify vendors on financial opening if is rfp';
        }
        field(25; "Acknowledgement"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(26; "Date of Acknowledgement"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(27; Select; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(28; "Selected Count"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("BidAnalysis Tender" WHERE("Tender No." = field("Tender No."), Select = filter(true), "Item No." = field("Item No.")));
        }
        field(29; "Min code"; Code[30])
        {
            
        }
    }

    keys
    {
        key(Key1; "Tender No.", "Tender Line No.", "Quote No.", "Vendor No.")
        {
            Clustered = true;
        }
        key(Key2; "Item No.") { }
        key(Key3; "Vendor No.") { }
        key(Key4; "Tender No.", "Item No.", Amount) { }
    }

    fieldgroups { }

    var
        PurchLine: Record "Purchase Line";
}


