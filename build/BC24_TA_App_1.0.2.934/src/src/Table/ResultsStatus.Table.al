Table 50075 "Results Status"
{


    fields
    {
        field(1; "Code"; Code[50]) { }
        field(2; Description; Text[100]) { }
        field(3; "Students Count"; Integer)
        {
            CalcFormula = count("Course Registration" where(Programme = field("Programme Filter"),
                                                             Semester = field("Semester Filter"),
                                                             Stage = field("Stage Filter"),
                                                             "Exam Status" = field(Code),
                                                             "Settlement Type" = field("Settlement Type"),
                                                             Options = field("Options Filter")));
            FieldClass = FlowField;
        }
        field(4; "Programme Filter"; Code[100])
        {
            FieldClass = FlowFilter;
            TableRelation = Programme.Code;
        }
        field(5; "Stage Filter"; Code[100])
        {
            FieldClass = FlowFilter;
            TableRelation = "Programme Stages".Code where("Programme Code" = field("Programme Filter"));
        }
        field(6; "Semester Filter"; Code[100])
        {
            FieldClass = FlowFilter;
            TableRelation = "Programme Semesters".Semester where("Programme Code" = field("Programme Filter"));
        }
        field(7; "Status Msg1"; Text[250]) { }
        field(8; "Status Msg2"; Text[250]) { }
        field(9; "Status Msg3"; Text[250]) { }
        field(10; "Status Msg4"; Text[250]) { }
        field(11; "Status Msg5"; Text[250]) { }
        field(12; "Order No"; Integer) { }
        field(13; "Student Type Filter"; Option)
        {
            FieldClass = FlowFilter;
            OptionCaption = 'Full Time,Part Time,Distance Learning';
            OptionMembers = "Full Time","Part Time","Distance Learning";

            trigger OnValidate()
            begin
                /*
                IF "Registration Date" <> 0D THEN BEGIN
                "Settlement Type":='FULL PAYMENT';
                VALIDATE("Settlement Type");
                END;
                */

            end;
        }
        field(14; "Show Reg. Remarks"; Boolean) { }
        field(15; "Manual Status Processing"; Boolean) { }
        field(50000; Semester; Code[100])
        {
            FieldClass = FlowFilter;
            TableRelation = "Programme Semesters".Semester where("Programme Code" = field("Programme Filter"));
        }
        field(50001; Prefix; Code[20]) { }
        field(50002; "Session Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = Intake.Code;
        }
        field(50003; "Campus Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code where("Dimension Code" = filter('CAMPUS'));
        }
        field(50004; "Students Count Cumm"; Integer)
        {
            CalcFormula = count("Course Registration" where(Programme = field("Programme Filter"),
                                                             Semester = field(Semester),
                                                             Stage = field("Stage Filter"),
                                                             "Cumm Status" = field(Code),
                                                             Reversed = const(false),
                                                             "Intake Code" = field("Session Filter"),
                                                             "Cust Exist" = filter(> 0),
                                                             "Units Taken" = filter(> 0),
                                                             Reversed = const(false),
                                                             "Campus Filter" = field("Campus Filter"),
                                                             "Settlement Type" = field("Settlement Type"),
                                                             Options = field("Options Filter")));
            FieldClass = FlowField;
        }
        field(50005; "Status Msg6"; Text[250]) { }
        field(50006; "Settlement Type"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Settlement Type".Code;
        }
        field(50007; "Status Msg7"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(50008; "Status Msg8"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(50009; "Options Filter"; Code[50])
        {
            FieldClass = FlowFilter;
            TableRelation = "Programme Options".Code where("Programme Code" = field("Programme Filter"));
        }
        field(50010; "Student Year"; Code[20])
        {
            FieldClass = FlowFilter;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
        key(Key2; "Order No") { }
    }

    fieldgroups { }
}

