Table 50171 Charge
{
    fields
    {
        field(1; "Code"; Code[20])
        {
            NotBlank = true;
        }
        field(2; Description; Text[30]) { }
        field(3; Amount; Decimal) { }
        field(4; "Fixed Amount"; Boolean) { }
        field(5; "G/L Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(6; Remarks; Text[150]) { }

        field(8; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(9; "Recover First"; Boolean) { }

        field(11; "Reg. ID Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            // TableRelation = "Student Requisitions"."Effective Date" where(Code = field("Student No. Filter"));
        }
        field(12; "Student No. Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = Customer."No.";
        }
        field(13; Show; Boolean) { }
        field(14; Currency; Code[20])
        {
            TableRelation = Currency.Code;
        }

        field(34; "Global Dimension 1"; Code[20])
        {
            TableRelation = "Dimension Value".code where("Global Dimension No." = filter(1));
        }
        field(35; "Global Dimension 2"; Code[20])
        {
            TableRelation = "Dimension Value".code where("Global Dimension No." = filter(2));
        }

        field(19; Gender; Option)
        {
            OptionCaption = ' ,Male,Female';
            OptionMembers = " ",Male,Female;
        }
        field(20; Active; Boolean) { }
        field(21; "Posting Type"; Option)
        {
            CalcFormula = lookup("G/L Account"."Gen. Posting Type" where("No." = field("G/L Account")));
            FieldClass = FlowField;
            OptionCaption = ' ,Purchase,Sale';
            OptionMembers = " ",Purchase,Sale;
        }
        field(22; "Graduation Fee"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(23; "Programme Category"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ',Certificate ,Diploma,Undergraduate,Masters,PHD,Professional,Course List,Post Graduate Diploma';
            OptionMembers = ,"Certificate ",Diploma,Undergraduate,Masters,PHD,Professional,"Course List","Post Graduate Diploma";
        }
        field(24; "Gown Fee"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(25; "Penalty"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(26; "Installment"; Boolean)
        {
            DataClassification = ToBeClassified;
        }

        field(28; "Default Dimension"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = filter(4));
        }

        field(30; "Exclude In PayPlan"; Boolean) { }
        field(31; "Hostel"; Boolean) { }
        field(32; "Annual Charge"; Boolean) { }

    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

