Table 50047 "Fee By Unit"
{
    //  DrillDownPageID = "Marksheet List";
    //  LookupPageID = "Marksheet List";

    fields
    {
        field(1; "Programme Code"; Code[20])
        {

            TableRelation = Programme.Code;
        }
        field(2; "Stage Code"; Code[20])
        {

            TableRelation = "Programme Stages".Code where("Programme Code" = field("Programme Code"));
        }
        field(3; "Unit Code"; Code[20])
        {
            TableRelation = "Units/Subjects".Code where("Programme Code" = field("Programme Code"));
        }
        field(4; "Settlemet Type"; Code[20])
        {

            TableRelation = "Settlement Type".Code;
        }
        field(5; "Seq."; Integer) { }
        field(6; "Unit Fees"; Decimal) { }
        field(7; Remarks; Text[150]) { }
        field(9; Semester; Code[20])
        {

            TableRelation = "Programme Semesters".Semester where("Programme Code" = field("Programme Code"));
        }
        field(10; "Student Type"; Code[20])
        {
            TableRelation = "Student Types".Code;
        }
        field(11; "Campus Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(12; "Other Charges"; Decimal)
        {
            CalcFormula = sum("Fee By Unit Charges".Amount where("Programme Code" = field("Programme Code"),
                                                                  "Student Type" = field("Student Type"),
                                                                  "Campus Code" = field("Campus Code"),
                                                                  "Applicable Group" = field("Applicable Group"),
                                                                  "Settlement Type" = field("Settlemet Type")));
            FieldClass = FlowField;
        }
        field(13; "Applicable Group"; Option)
        {
            OptionCaption = ' ,New Students,Continuing Students';
            OptionMembers = " ","New Students","Continuing Students";
        }
        field(14; "Exam Fees"; Decimal) { }
        field(15; "Other Charges Exam"; Decimal)
        {
            CalcFormula = sum("Fee By Unit Charges".Amount where("Programme Code" = field("Programme Code"),
                                                                  "Student Type" = field("Student Type"),
                                                                  "Campus Code" = field("Campus Code"),
                                                                  "Applicable Group" = field("Applicable Group"),
                                                                  "Settlement Type" = field("Settlemet Type"),
                                                                  Description = filter('*Examination*')));
            FieldClass = FlowField;
        }
        field(16; "Programme Category"; code[20])
        {
            TableRelation = "Programme Categories".code;
        }
    }

    keys
    {
        key(Key1; "Programme Code", "Unit Code", "Student Type", "Settlemet Type", "Campus Code", "Applicable Group", "Programme Category")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

