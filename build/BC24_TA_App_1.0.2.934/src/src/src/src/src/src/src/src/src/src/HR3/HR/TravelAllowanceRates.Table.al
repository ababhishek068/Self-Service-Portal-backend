table 50971 "Travel Allowance Rates"
{
    Caption = 'Travel Allowance Rates';
    DataClassification = ToBeClassified;
    DrillDownPageId = "Travel allowance setup";

    fields
    {
        field(1; "Job Grade"; Code[20])
        {
            Caption = 'Job Grade';
            TableRelation = "HR Job Grades".Code;
            trigger OnValidate()
            begin
                jobgrade.Reset();
                jobgrade.SetRange(jobgrade.Code, "Job Grade");
                if jobgrade.FindFirst() then begin
                    "Job Grade name" := jobgrade.Descrition;
                end;
            end;
        }
        field(2; Location; Code[20])
        {
            Caption = 'Location';
            TableRelation = Branches."Division/Branch Code";
            trigger OnValidate()
            begin
                if branches.Get(Location) then begin
                    "Location Name" := branches."Division/Branch Name";
                end;
            end;
        }
        field(3; "Location Name"; Text[50])
        {
            Caption = 'Location Name';
        }
        field(4; "Job Grade name"; Text[50])
        {
            Caption = 'Job Grade name';
        }
        field(5; Amount; Decimal)
        {
            trigger OnValidate()
            var
            salcard: Record "HR-Employee";
            begin
                TestField("Job Grade");
                TestField(level);
                updateemps();
                Message('All employees under same job group updated with the new rates for the current payroll period');


            end;
        }
        field(6; level; Option)
        {
            OptionMembers = "",Branch,Division;
            NotBlank = true;
            trigger OnValidate()
            begin
                vitalsetup.Get();
                if vitalsetup."Fuel Rate" < 1 then begin
                    Error('Fuel Rate must be setup in payroll rates and ceilings');
                end;
            end;
        }
    }
    keys
    {
        key(PK; "Job Grade", level)
        {
            Clustered = true;
        }


    }
    var
        jobgrade: Record "HR Job Grades";
        branches: Record Branches;
        vitalsetup: Record "PR Vital Setup Info";
        emps: record "HR-Employee";
        hremps: Record "HR-Employee";

    procedure updateemps()
    var
    empgrade: Integer;
    begin
        empgrade:=0;
        emps.Reset();
        emps.SetRange(emps.Status, emps.Status::Active);
        emps.SetRange(emps."Job Group", "Job Grade");        
        if emps.Find('-') then begin
            repeat  
            empgrade:=emps.Grade;
            if empgrade<>0 then
            hremps.Reset();
            hremps.SetRange(hremps."No.",emps."No.");
            if hremps.FindFirst() then begin
                
              hremps.Grade:=empgrade;
              hremps.Modify();

            end;           

               // hremps.Validate("Salary Grade");
                     
                
            until emps.next = 0;
        end;

    end;
}
