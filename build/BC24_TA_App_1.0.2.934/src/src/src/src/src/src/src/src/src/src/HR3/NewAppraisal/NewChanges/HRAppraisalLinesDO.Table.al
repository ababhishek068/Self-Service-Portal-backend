Table 50345 "HR Appraisal Lines - DO"
{


    fields
    {
        field(1; "Appraisal No."; Code[10])
        {
            Editable = false;
            TableRelation = "HR Appraisal Header - UP"."Appraisal No";
        }
        field(2; "Objective Code"; Code[20])
        {
            TableRelation = "HR Appraisal Dept. Obj. Setup"."Objective Code" where("Department Code" = field("Department Code"));
        }
        field(3; "Objective Description"; Text[150])
        {
            Caption = 'Performance Measures';
            DataClassification = ToBeClassified;
        }
        field(4; "Department Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code;

            trigger OnValidate()
            begin
            end;
        }
        field(5; "Perspective Code"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR Lookup Values".Code where(Type = const("Appraisal Perspective"));
            trigger OnValidate()
            var
                HRLookupVal: Record "HR Lookup Values";
            begin
                HRLookupVal.Reset();
                HRLookupVal.SetRange(Type, HRLookupVal.Type::"Appraisal Perspective");
                HRLookupVal.SetRange(Code, "Perspective Code");
                if HRLookupVal.FindFirst() then begin
                    "Perspective Description" := HRLookupVal.Description;
                end;
            end;
        }
        field(6; "Perspective Description"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Perspective Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Stewardship,Customer,"Internal Process","Learning & Growth";
        }
        field(8; "Line Number"; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }

        field(450; "Last Line Number"; Integer)
        {
            DataClassification = ToBeClassified;
            //  AutoIncrement = true;
        }
        field(9; "Strategic objectives"; Text[150])
        {
            DataClassification = ToBeClassified;

        }

        field(10; "Strategic/Dept initiatives"; Text[150])
        {
            Caption = 'Strategic departmental initiatives';
            DataClassification = ToBeClassified;

        }
        field(11; "Performance measures"; Text[150])
        {

            DataClassification = ToBeClassified;

        }
        field(12; "Target"; Decimal)
        {

            DataClassification = ToBeClassified;

        }

        field(13; "Weight"; Decimal)
        {
            Caption = 'Weight %';
            DataClassification = ToBeClassified;

        }

        field(14; "July"; Decimal)
        {

            DataClassification = ToBeClassified;

        }
        field(15; "August"; Decimal)
        {

            DataClassification = ToBeClassified;

        }
        field(16; "September"; Decimal)
        {

            DataClassification = ToBeClassified;

        }
        field(17; "October"; Decimal)
        {

            DataClassification = ToBeClassified;

        }
        field(18; "November"; Decimal)
        {

            DataClassification = ToBeClassified;

        }
        field(19; "December"; Decimal)
        {

            DataClassification = ToBeClassified;

        }
        field(20; "January"; Decimal)
        {

            DataClassification = ToBeClassified;

        }
        field(21; "February"; Decimal)
        {

            DataClassification = ToBeClassified;

        }
        field(22; "March"; Decimal)
        {

            DataClassification = ToBeClassified;

        }

        field(23; "April"; Decimal)
        {

            DataClassification = ToBeClassified;

        }
        field(24; "May"; Decimal)
        {

            DataClassification = ToBeClassified;

        }
        field(25; "June"; Decimal)
        {

            DataClassification = ToBeClassified;

        }
        field(26; "Total Actual"; Decimal)
        {

            DataClassification = ToBeClassified;

        }
        field(27; "Max"; Decimal)
        {

            DataClassification = ToBeClassified;

        }

        field(28; "Noderated"; Decimal)
        {

            DataClassification = ToBeClassified;

        }

        field(29; "SCORE"; Decimal)
        {
            Caption = 'SCORE %';
            DataClassification = ToBeClassified;

        }

        field(30; "Weighted"; Decimal)
        {
            Caption = 'Weighted %';
            DataClassification = ToBeClassified;

        }

        field(31; "performance tracking"; Decimal)
        {
            Caption = 'Weighted %';
            DataClassification = ToBeClassified;

        }

        field(32; "Admissible evidence"; Decimal)
        {

            DataClassification = ToBeClassified;

        }

    }

    keys
    {
        key(Key1; "Appraisal No.", "Objective Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Objective Code", "Objective Description", "Department Code", "Perspective Code", "Perspective Description") { }
    }
}

