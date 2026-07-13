Table 50017 "Fee By Stage"
{
    DrillDownPageID = "Fee By Stage";
    LookupPageID = "Fee By Stage";

    fields
    {
        field(1; "Programme Code"; Code[20])
        {
            NotBlank = true;
            TableRelation = Programme.Code;
        }
        field(2; "Stage Code"; Code[20])
        {
            NotBlank = true;
            TableRelation = "Programme Stages".Code where("Programme Code" = field("Programme Code"));
        }
        field(3; "Settlemet Type"; Code[20])
        {
            NotBlank = true;
            TableRelation = "Settlement Type".Code;
        }
        field(4; "Seq."; Integer)
        {
            AutoIncrement = true;

        }
        field(5; "Break Down"; Decimal) { }
        field(6; Remarks; Text[150]) { }
        field(7; Semester; Code[20])
        {
            TableRelation = Semesters.Code;
        }
        field(8; "Amount Not Distributed"; Decimal) { }
        field(9; "Student Type"; Option)
        {
            OptionCaption = ' Full Time,Part Time,Distance Learning';
            OptionMembers = " Full Time","Part Time","Distance Learning";
        }
        field(10; "No Of Units"; Integer)
        {
            CalcFormula = count("Units/Subjects" where("Programme Code" = field("Programme Code"),
                                                        "Stage Code" = field("Stage Code")));
            FieldClass = FlowField;
        }
        field(12; "Copy From Semester"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Programme Semesters".Semester where("Programme Code" = field("Programme Code"));
        }
        field(13; "Copy To Semester"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Programme Semesters".Semester where("Programme Code" = field("Programme Code"));
        }
        field(14; "Copy From Programme"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = Programme.Code;
        }
        field(15; "Copy To Programme"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = Programme.Code;
        }
        field(50000; "Programme Description"; Text[150])
        {
            CalcFormula = lookup(Programme.Description where(Code = field("Programme Code")));
            FieldClass = FlowField;
        }
        field(50001; "Stage Description"; Text[30])
        {
            CalcFormula = lookup("Programme Stages".Description where(Code = field("Stage Code")));
            FieldClass = FlowField;
        }
        field(50002; "Stage Charges"; Decimal)
        {
            CalcFormula = sum("Stage Charges".Amount where("Programme Code" = field("Programme Code"),
                                                            "Stage Code" = field("Stage Code"),
                                                            "Settlement Type" = field("Settlemet Type")));
            FieldClass = FlowField;
        }
        field(50003; "programme Name"; Text[250]) { }
        field(50004; "Campus Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(50005; "Total Charges"; Decimal)
        {
            CalcFormula = sum("Stage Charges".Amount where("Programme Code" = field("Programme Code"),
                                                            "Stage Code" = field("Stage Code"),
                                                            Semester = field(Semester),
                                                            "Settlement Type" = field("Settlemet Type"),
                                                            "Campus Code" = field("Campus Code")));
            FieldClass = FlowField;
        }
        field(50006; "Prog Exist"; Code[20])
        {
            CalcFormula = lookup(Programme.Code where(Code = field("Programme Code")));
            FieldClass = FlowField;
        }
        field(50007; "Stage2 Amount"; Decimal)
        {
            CalcFormula = lookup("Fee By Stage"."Break Down" where("Programme Code" = field("Programme Code"),
                                                                    "Stage Code" = field("Stage2 Filter"),
                                                                    "Settlemet Type" = field("Settlemet Type")));
            FieldClass = FlowField;
        }
        field(50008; "Stage2 Filter"; Code[20])
        {
            FieldClass = FlowFilter;
        }
    }

    keys
    {
        key(Key1; "Programme Code", "Stage Code", Semester, "Student Type", "Settlemet Type", "Seq.", "Campus Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

