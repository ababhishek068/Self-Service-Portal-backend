Table 50289 "Marksheet Header1"
{

    fields
    {
        field(1; "Code"; Code[50]) { }
        field(2; "Campus Filter"; Code[20])
        {
            FieldClass = Normal;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
            ValidateTableRelation = true;
        }
        field(3; "Programme Filter"; Code[20])
        {
            FieldClass = Normal;
            TableRelation = Programme.Code;
        }
        field(4; "Semester Filter"; Code[20])
        {
            FieldClass = Normal;
            TableRelation = Semesters.Code;
        }
        field(5; "Intake Filter"; Code[20])
        {
            FieldClass = Normal;
            TableRelation = Intake.Code;
        }
        field(6; "Stage Filter"; Code[20])
        {
            FieldClass = Normal;
            TableRelation = "Programme Stages".Code where("Programme Code" = field("Programme Filter"));
        }
        field(7; "Term Filter"; Option)
        {
            FieldClass = Normal;
            OptionCaption = ' ,Term1,Term2,Term3,Term4,Term5,Term6,Term7,Term8,Term9';
            OptionMembers = " ",Term1,Term2,Term3,Term4,Term5,Term6,Term7,Term8,Term9;
        }
        field(8; "Unit Filter"; Code[20])
        {
            FieldClass = Normal;
            TableRelation = "Units/Subjects".Code where("Programme Code" = field("Programme Filter"),
                                                         "Stage Code" = field("Stage Filter"));
            trigger OnValidate()
            var
                StudentUnits: record "Student Units";
            begin
                StudentUnits.Reset();
                StudentUnits.SetRange("Student No.", "Student Filter");
                StudentUnits.SetRange(Unit, "Unit Filter");
                if StudentUnits.find('-') then begin
                    StudentUnits."Concept Paper Status" := StudentUnits."Concept Paper Status"::Submitted;
                    StudentUnits.modify();
                end
            end;
        }
        field(9; "Student Filter"; Code[20])
        {
            TableRelation = Customer."No." where("Customer Posting Group" = const('STUDENT'));
        }
        field(10; "Approved By"; Code[80]) { }
        field(11; "Approval Date"; Date) { }
        field(12; Approved; Boolean) { }
        field(13; "No. Series"; Code[20]) { }
        field(14; "Verified By"; Code[80]) { }
        field(15; "Verified Date"; Date) { }
        field(16; Verified; Boolean) { }
        field(17; "Moderation Factor"; Decimal)
        {
            MaxValue = 1.5;
            MinValue = 0.5;
        }
        field(18; "Moderated By"; Code[80]) { }
        field(19; "Moderated On"; Date) { }
        field(20; "Prepared By"; Code[80]) { }
        field(21; Description; Text[150])
        {
            CalcFormula = lookup("Units/Subjects".Desription where("Programme Code" = field("Programme Filter"),
                                                                    Code = field("Unit Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(22; "Mode of Study Filter"; Code[20])
        {
            TableRelation = "Student Types".Code;
        }
        field(23; iCounter; Integer)
        {
            CalcFormula = count("Student Units" where(Semester = field("Semester Filter"),
                                                       Programme = field("Programme Filter"),
                                                       Stage = field("Stage Filter"),
                                                       Unit = field("Unit Filter"),
                                                       "Exam Marks" = filter(> 0)));
            FieldClass = FlowField;
        }
        field(24; "Lecturer No"; Code[30])
        {
            CalcFormula = lookup("Lecturers Units".Lecturer where(Programme = field("Programme Filter"),
                                                                   Stage = field("Stage Filter"),
                                                                   Unit = field("Unit Filter"),
                                                                   Semester = field("Semester Filter"),
                                                                   "Campus Code" = field("Campus Filter")));
            FieldClass = FlowField;
        }
        field(25; "Class Filter"; Code[20])
        {
            FieldClass = Normal;
            TableRelation = "Course Classes".Code;
        }
        field(26; Status; Option)
        {
            FieldClass = Normal;
            OptionCaption = ' ,Concept,Proposal,Thesis,Project';
            OptionMembers = " ",Concept,Proposal,Thesis,Project;
        }
        field(28; "Date Requested"; date)
        {
            FieldClass = Normal;
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

    trigger OnInsert()
    begin
        //IF NOT MK.GET(Code) THEN
        //Code:=USERID;
        //
        if Code = '' then begin
            GeneralSetup.Get;
            GeneralSetup.TestField(GeneralSetup."Marks Approval Nos");
            Code:=NoSeriesMgt.GetNextNo(GeneralSetup."Marks Approval Nos", 0D, true);
        end;
        "Prepared By" := UserId;

        // Load prev user settings
        MK.Reset;
        MK.SetRange(MK."Prepared By", UserId);
        MK.SetFilter(MK.Code, '<>%1', Code);
        if MK.Find('+') then begin
            "Campus Filter" := MK."Campus Filter";
            "Programme Filter" := MK."Programme Filter";
            "Semester Filter" := MK."Semester Filter";
            "Intake Filter" := MK."Intake Filter";
            "Stage Filter" := MK."Stage Filter";
            //"Term Filter":= MK."Term Filter" ;
            "Mode of Study Filter" := MK."Mode of Study Filter";
        end;

    end;

    var
        MK: Record "Marksheet Header1";
        GeneralSetup: Record "General Set-Up";
        NoSeriesMgt: Codeunit "No. Series";
}

