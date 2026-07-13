Table 50068 "Programme Stages"
{


    fields
    {
        field(1; "Programme Code"; Code[20])
        {
            NotBlank = false;
            TableRelation = Programme.Code;
        }
        field(2; "Code"; Code[20])
        {
            NotBlank = false;
            // TableRelation = Stages.Stage;
            trigger OnValidate()
            begin
                if Prog.Get("Programme Code") then
                    Department := Prog."School Code";
            end;
        }
        field(3; Description; Text[150]) { }
        field(4; "G/L Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(5; Department; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(6; Remarks; Text[150]) { }
        field(7; "Total Income"; Decimal)
        {
            CalcFormula = sum("Student Charges"."Amount Paid" where(Programme = field("Programme Code"),
                                                                     Stage = field(Code),
                                                                     Semester = field("Semester Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(8; "Student Registered"; Integer)
        {
            CalcFormula = count("Course Registration" where(Programme = field("Programme Code"),
                                                             Stage = field(Code),
                                                             Semester = field("Semester Filter"),
                                                             "Registration Date" = field("Date Filter"),
                                                             Status = field(Status),
                                                             Reversed = const(false),
                                                             "Intake Code" = field("Intake Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(9; "Semester Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = Semesters.Code;
        }
        field(10; "Modules Registration"; Boolean) { }
        field(11; "Period (M)"; Integer) { }
        field(12; "Distribution Full Time (%)"; Decimal) { }
        field(13; "Distribution Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(14; Registered; Integer)
        {
            CalcFormula = count("Course Registration" where(Programme = field("Programme Code"),
                                                             Stage = field(Code),
                                                             Semester = field("Semester Filter"),
                                                             "Registration Date" = field("Date Filter"),
                                                             Status = field(Status),
                                                             Reversed = const(false)));
            Editable = false;
            FieldClass = FlowField;
        }

        field(16; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(17; "Registered Part Time"; Integer)
        {
            CalcFormula = count("Course Registration" where(Programme = field("Programme Code"),
                                                             Stage = field(Code),
                                                             Semester = field("Semester Filter"),
                                                             "Registration Date" = field("Date Filter"),
                                                             Status = field(Status),
                                                             Reversed = const(false),
                                                             "Intake Code" = field("Intake Filter"),
                                                             "Student Type" = const("Part Time")));
            Editable = false;
            FieldClass = FlowField;
        }

        field(19; "Registered Full Time"; Integer)
        {
            CalcFormula = count("Course Registration" where(Programme = field("Programme Code"),
                                                             Stage = field(Code),
                                                             Semester = field("Semester Filter"),
                                                             "Registration Date" = field("Date Filter"),
                                                             "Student Type" = const("Full Time"),
                                                             Status = field(Status),
                                                             Reversed = const(false)));
            Editable = false;
            FieldClass = FlowField;
        }

        field(21; "Distribution Part Time (%)"; Decimal) { }
        field(22; "Full Time Budget"; Decimal)
        {
            DecimalPlaces = 0 : 0;
        }
        field(23; "Part Time Budget"; Decimal)
        {
            DecimalPlaces = 0 : 0;
        }
        field(24; Status; Option)
        {
            FieldClass = FlowFilter;
            OptionMembers = " ",Registration,Current,Alluminae,Dropped;
        }
        field(25; "Ignore No. Of Units"; Boolean) { }
        field(26; "Total Income1"; Decimal)
        {
            CalcFormula = sum("Student Charges"."Amount Paid" where(Programme = field("Programme Code"),
                                                                     Semester = field("Semester Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(27; Minimum; Integer) { }
        field(28; Maximum; Integer) { }
        field(29; "Student No."; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = Customer."No.";
        }
        field(30; "Units Taken"; Integer)
        {
            CalcFormula = count("Student Units" where(Programme = field("Programme Code"),
                                                       "Unit Stage" = field(Code),
                                                       Taken = const(true),
                                                       "Student No." = field("Student No."),
                                                       "Reg. Transacton ID" = field("Reg. ID")));
            FieldClass = FlowField;
        }
        field(31; "Reg. ID"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Course Registration"."Reg. Transacton ID";
        }
        field(32; "Do not Graduate"; Boolean) { }
        field(33; "Student Type Filter"; Code[100])
        {
            FieldClass = FlowFilter;
            TableRelation = "Settlement Type".Code;
        }
        field(34; "Campus Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(35; "Intake Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = Intake.Code;
        }
        field(41; "Failed Count"; Integer)
        {
            CalcFormula = count("Course Registration" where(Programme = field("Programme Code"),
                                                             Semester = field("Semester Filter"),
                                                             Stage = field(Code),
                                                             "Units Failed" = filter(<> 0),
                                                             "Units Repeat" = const(0)));
            FieldClass = FlowField;
        }
        field(42; "Pass Count"; Integer)
        {
            CalcFormula = count("Course Registration" where(Programme = field("Programme Code"),
                                                             Semester = field("Semester Filter"),
                                                             Stage = field(Code),
                                                             "Units Failed" = const(0),
                                                             "Units Passed" = filter(<> 0),
                                                             "Units Repeat" = const(0),
                                                             Reversed = const(false)));
            FieldClass = FlowField;
        }
        field(43; "Stage Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Programme Stages".Code where("Programme Code" = field("Programme Code"));
        }
        field(44; "Repeat Count"; Integer)
        {
            CalcFormula = count("Course Registration" where(Programme = field("Programme Code"),
                                                             Semester = field("Semester Filter"),
                                                             Stage = field(Code),
                                                             "Units Repeat" = filter(<> 0)));
            FieldClass = FlowField;
        }
        field(45; "Final Stage"; Boolean) { }
        field(46; "Academic Leave"; Integer)
        {
            CalcFormula = count("Course Registration" where(Programme = field("Programme Code"),
                                                             Stage = field(Code),
                                                             Semester = field("Semester Filter"),
                                                             "Registration Date" = field("Date Filter"),
                                                             "Registration Status" = const("Academic Leave"),
                                                             Reversed = const(false)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(47; Withheld; Integer)
        {
            CalcFormula = count("Course Registration" where(Programme = field("Programme Code"),
                                                             Stage = field(Code),
                                                             Semester = field("Semester Filter"),
                                                             "Registration Date" = field("Date Filter"),
                                                             "Registration Status" = const(WithHold),
                                                             Reversed = const(false)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(48; Special; Integer)
        {
            CalcFormula = count("Course Registration" where(Programme = field("Programme Code"),
                                                             Stage = field(Code),
                                                             Semester = field("Semester Filter"),
                                                             "Registration Date" = field("Date Filter"),
                                                             "Registration Status" = const(Specials),
                                                             Reversed = const(false)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(49; Discontinue; Integer)
        {
            CalcFormula = count("Course Registration" where(Programme = field("Programme Code"),
                                                             Stage = field(Code),
                                                             Semester = field("Semester Filter"),
                                                             "Registration Date" = field("Date Filter"),
                                                             "Registration Status" = const(Discontinue),
                                                             Reversed = const(false)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50; Nullification; Integer)
        {
            CalcFormula = count("Course Registration" where(Programme = field("Programme Code"),
                                                             Stage = field(Code),
                                                             Semester = field("Semester Filter"),
                                                             "Registration Date" = field("Date Filter"),
                                                             "Registration Status" = const(Nullification),
                                                             Reversed = const(false)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(51; "Next Stage Attachment"; Boolean) { }
        field(52; "Allow Programme Options"; Boolean) { }
        field(53; "Include in Time Table"; Boolean) { }
        field(50000; "Campus Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(50001; "Order"; Integer) { }
        field(50002; "Maximum Allowed CF"; Decimal) { }
        field(50003; "Next Stage"; Text[50]) { }
        field(50004; "Block Online Results Release"; Boolean) { }
        field(50005; "Current Semester"; Code[20])
        {
            CalcFormula = lookup(Semesters.Code where("Current Semester" = const(true)));
            FieldClass = FlowField;
            TableRelation = Semesters.Code where("Current Semester" = const(true));
        }
        field(50006; "Student Count"; Integer)
        {
            CalcFormula = count("Student Units" where(Semester = field("Current Semester"),
                                                       Stage = field(Code)));
            FieldClass = FlowField;
        }
        field(50007; "Course Count"; Integer)
        {
            CalcFormula = count("Units/Subjects" where("Programme Code" = field("Programme Code"),
                                                        "Stage Code" = field(Code)));
            FieldClass = FlowField;
        }
        field(50008; "Minimum Pass Core"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50009; "Minimum Pass All"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50010; "Contribution to Final Score"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50011; "Total Core Course"; Integer)
        {
            CalcFormula = count("Units/Subjects" where("Programme Code" = field("Programme Code"),
                                                        "Stage Code" = field(Code),
                                                        "Unit Type" = filter(Core)));
            FieldClass = FlowField;
        }
        field(50012; "Total Required Course"; Integer)
        {
            CalcFormula = count("Units/Subjects" where("Programme Code" = field("Programme Code"),
                                                        "Stage Code" = field(Code),
                                                        "Unit Type" = filter(Required)));
            FieldClass = FlowField;
        }
        field(50013; "Total Elective Course"; Integer)
        {
            CalcFormula = count("Units/Subjects" where("Programme Code" = field("Programme Code"),
                                                        "Stage Code" = field(Code),
                                                        "Unit Type" = filter(Elective)));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Programme Code", "Code")
        {
            Clustered = true;
            SumIndexFields = "Full Time Budget", "Part Time Budget";
        }
        key(Key2; "Code") { }
    }

    fieldgroups { }

    var
        Prog: Record programme;
}

