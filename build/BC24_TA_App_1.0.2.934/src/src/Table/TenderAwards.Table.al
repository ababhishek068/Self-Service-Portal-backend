table 50939 TenderAwards
{
 

    fields
    {
        field(1; "Vendor No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Tender No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Type; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Award,Regret';
            OptionMembers = " ",Award,Regret;
        }
        field(4; "Date of Award"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Awarded By"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Expiry Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(7; Description; Text[250])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Purchase Quote Header"."Request Description" WHERE("No." = FIELD("Tender No")));

        }
        field(8; Acknowledged; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Bid Analysis".Acknowledgement where("RFQ No." = field("Tender No"), "Vendor No." = field("Vendor No")));
        }
        field(9; "Date of Acknowledgement"; DateTime)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Bid Analysis"."Date of Acknowledgement" where("RFQ No." = field("Tender No"), "Vendor No." = field("Vendor No")));
        }
        field(10; "Vendor Name"; Text[250])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Vendor.Name where("No." = field("Vendor No")));
        }
        field(11; Remarks; Text[300])
        {
            DataClassification = ToBeClassified;
        }
        field(12; Quantity; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Unit Of Measure"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(14; Amount; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Line Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(16; Total; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Item No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Quote No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Vendor No", "Tender No")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}


