table 50040 "Courses Master"
{
    DataClassification = ToBeClassified;
    LookupPageId = "Courses Master";
    DrillDownPageId = "Courses Master";
    fields
    {
        field(1; Code; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; Description; Text[150])
        {
            DataClassification = ToBeClassified;

        }
        field(3; Units; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(4; "Unit Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Core,Elective,Required,Free Elective,General Education';
            OptionMembers = Core,Elective,Required,"Free Elective","General Education";
        }
        field(5; "Department Code"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = filter(2));
            trigger OnValidate()
            var
                DimRec: Record "Dimension Value";
            begin
                dimrec.reset;
                dimrec.setrange(dimrec.Code, "Department Code");
                if DimRec.find('-') then
                    "Department Name" := Dimrec.Name;
            end;
        }
        field(6; "School Code"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = filter(3));
            trigger OnValidate()
            var
                DimRec: Record "Dimension Value";
            begin
                dimrec.reset;
                dimrec.setrange(dimrec.Code, "School Code");
                if DimRec.find('-') then
                    "School Name" := Dimrec.Name;
            end;
        }
        field(7; "Stage"; code[20])
        {
            DataClassification = ToBeClassified;
            // TableRelation = Stages.Stage;
        }
        field(17; "Charge Credits"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Charge Credits';
        }
        field(8; "Teaching Type"; Option)
        {
            OptionCaption = 'Lecture,Teaching Practice,Thesis, Independent Study,Practicum,Senior Project,Project	Dissertation';
            OptionMembers = Lecture,"Teaching Practice",Thesis,"Independent Study",Practicum,"Senior Project","Project	Dissertation";
            DataClassification = ToBeClassified;
        }
        field(9; "Time Table"; Boolean)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                UnitsRec: Record "Units/Subjects";
            begin
                UnitsRec.Reset;
                UnitsRec.SetRange(UnitsRec.Code, Code);
                if UnitsRec.find('-') then begin
                    repeat
                        UnitsRec."Time Table" := "Time Table";
                        UnitsRec.modify;
                    until UnitsRec.next = 0;
                end;
            end;
        }
        field(20; "Prerequisite Unit"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Courses Master".Units;
        }
        field(21; " Core Prerequisite Unit"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Courses Master".Units;
        }
        field(22; "Substitute Unit"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Courses Master".Units;
        }
        field(23; "Unit Category"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Unit Type".Code;
        }
        field(24; "Department Name"; text[200])
        {
            DataClassification = ToBeClassified;

        }
        field(25; "School Name"; text[200])
        {
            DataClassification = ToBeClassified;

        }
        field(26; "Old Unit"; Boolean)
        {
            DataClassification = ToBeClassified;

        }
        field(260; "Disable Inc Rule"; Boolean)
        {
            DataClassification = ToBeClassified;

        }

        field(27; "Time Tabled"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = exist("Time Table" where(Unit = field(Code), "Current Semester" = filter(true)));


        }
    }

    keys
    {
        key(PK; code)
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}