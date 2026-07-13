Table 50051 "Graduation Request"
{

    fields
    {
        field(1; "Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Student No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Names; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(6; Address; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(7; Region; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(8; Telephone; Code[40])
        {
            DataClassification = ToBeClassified;
        }
        field(9; Email; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(10; Programme; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "ID Number"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(12; Specialization; Code[250])
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Date Requested"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Responsibility Center"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Responsibility Center BR".Code;
        }
        field(17; "No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(18; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Open,Pending Approval,Approved';
            OptionMembers = Open,"Pending Approval",Approved;
        }
        field(19; "Sender ID"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Department Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(21; Campus; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(22; "Personal Email"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(23; "Current profession"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(24; "Current Institustion/Company"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(25; Country; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(26; "No.  Units Completed"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(27; "Credit Hrs Completed"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(28; Classification; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(29; "Current Phone No"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(30; Paid; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(31; Balance; Decimal)
        {
            CalcFormula = sum("Detailed Cust. Ledg. Entry".Amount where("Customer No." = field("Student No"),
                                                                         "Entry Type" = const("Initial Entry")));
            FieldClass = FlowField;
        }
        field(33; "Gown Required"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(32; "Gown Collection Campus"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = filter(1));
        }
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

