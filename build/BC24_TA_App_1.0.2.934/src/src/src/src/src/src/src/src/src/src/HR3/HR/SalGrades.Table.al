table 50937 "Sal Grades"

{
    DrillDownPageID = "Salary Grades List";
    LookupPageID = "Salary Grades List";

    fields
    {
        field(1; "Salary Grade"; Integer) { }
        field(2; "Salary Gross Amount"; Decimal)
        {
            Editable = false;

        }
        field(3; Description; Text[100]) { }
        field(4; "House Allowance"; Decimal)
        {
            Editable = false;
            trigger OnValidate()
            begin
               // TestField(Basic_salary);
                TestField("Job Group");
                TestField("Salary Grade");
                updateemps("Job Group", "Salary Grade")
            end;
        }
        field(5; "Hardship Allowance"; Decimal)
        {
            Editable = false;


        }
        field(7; Basic_salary; Decimal)
        {
            trigger OnValidate()
            var
                hard: record "Hardhsip Rates";
                vitals: Record "PR Vital Setup Info";
                hallowancesetup: Record "House Allowance Setup";
            begin
                if Basic_salary <> 0 then
                    Clear("Hardship Allowance");
                Clear("Salary Gross Amount");
                //TestField("Global Dimension 2 Code");
                TestField(Basic_salary);
                TestField("Job Group");
                TestField("Salary Grade");
                vitals.Get();

                //calculate house allowance dynamically
                hallowancesetup.Reset();
                hallowancesetup.SetRange(hallowancesetup.Active,true);
                if hallowancesetup.Find('-') then begin
                    repeat
                    if (rec."Salary Grade">=hallowancesetup."Lower Salary Grade Limit") and (rec."Salary Grade"<=hallowancesetup."Upper Salary Grade Limit") then begin
                        rec."House Allowance":=rec.Basic_salary*(hallowancesetup."Perrcentage of Basic"/100);

                    end

                    until hallowancesetup.Next()=0;
                end;

                // if vitals."House Allowance Percentage" <> 0 then begin
                //     "House Allowance" := (vitals."House Allowance Percentage" / 100) * Basic_salary;
                //     Modify;
                // end;
                // if rec."Salary Grade"='1' then begin

                // end;
                // if rec."Salary Grade"='2' or
                updateemps("Job Group", "Salary Grade");
                validate("House Allowance");



            end;
        }
        field(8; "Travel Allowance"; Decimal)
        {
            trigger OnValidate()
            var
            begin
                //"Salary Gross Amount":=Basic_salary+"Hardship Allowance"+"Travel Allowance";

            end;

        }
        field(9; "Transport Allowance"; Decimal)
        {
            trigger OnValidate()
            var
            begin
                TestField(Basic_salary);
                TestField("Job Group");
                TestField("Salary Grade");
                updateemps("Job Group", "Salary Grade")
                //"Salary Gross Amount":=Basic_salary+"Hardship Allowance"+"Travel Allowance"+"Transport Allowance";
            end;
        }
        field(13; "Position Allowance"; Decimal)
        {
            trigger OnValidate()
            var
            begin
                TestField(Basic_salary);
                TestField("Job Group");
                TestField("Salary Grade");
                updateemps("Job Group", "Salary Grade")

                //"Salary Gross Amount":=Basic_salary+"Hardship Allowance"+"Travel Allowance"+"Transport Allowance"
            end;
        }



        field(10; "Job Group"; Code[20])
        {
            Caption = 'Job Grade';
            TableRelation = "HR Job Grades".Code;
        }
        field(11; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = 'Branch';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));

            trigger OnValidate()
            begin

                DimVal.Reset;
                DimVal.SetRange(DimVal.Code, "Global Dimension 2 Code");
                if DimVal.Find('-') then
                    "Global Dimension 2 Name" := DimVal.Name;
            end;
        }
        field(12; "Global Dimension 2 Name"; Text[55])
        {
            Editable = false;
        }
        field(25; Managerial; Boolean) { }

    }

    keys
    {
        key(Key1; "Salary Grade", "Job Group")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
    var
        DimVal: Record "Dimension Value";
        emps: Record "HR-Employee";

    procedure updateemps(jobgrade: Code[50]; salgrade: Integer)
    begin
        emps.Reset();
        emps.SetRange(emps.Status, emps.Status::Active);
        emps.SetRange(emps."Job Group", "Job Group");
        emps.SetRange(emps.Grade, "Salary Grade");
        if emps.Find('-') then begin
            repeat
                emps.Validate(Grade);
            until emps.next = 0;
        end;

    end;
}

