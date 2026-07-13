table 50919 "Compensation Benchmarking"
{
    Caption = 'Compensation Benchmarking';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Job ID"; Code[20])
        {
            Caption = 'Job ID';
            DataClassification = CustomerContent;
            TableRelation = "HR Jobs"."Job ID";
            trigger OnValidate()
            begin
                jobs.Reset();
                ;
                jobs.SetRange(jobs."Job ID", rec."Job ID");
                if jobs.FindFirst() then begin
                    "Job Description" := jobs."Job Description";

                end;
            end;

        }
        field(2; "Job Description"; Text[100])
        {
            Caption = 'Job Description';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(3; "Job Grade"; Code[20])
        {
            Caption = 'Job Grade';
            DataClassification = CustomerContent;
            TableRelation = "HR Job Grades".Code;
        }
        field(4; "Salary Grade"; Integer)
        {
            Caption = 'Salary Grade';
            DataClassification = CustomerContent;
            TableRelation = "Sal Grades"."Salary Grade";
            trigger OnValidate()
            begin
                TestField("Job Grade");
                salarygrades.Reset();
                ;
                salarygrades.SetRange(salarygrades."Salary Grade", "Salary Grade");
                salarygrades.SetRange(salarygrades."Job Group", "Job Grade");
                if salarygrades.FindFirst() then begin
                    "Current Basic" := salarygrades.Basic_salary;
                    "Current Gross" := salarygrades."Salary Gross Amount";

                end;
            end;
        }
        field(5; "Market Source"; Text[100])
        {
            Caption = 'Market Source';
            DataClassification = CustomerContent;
        }
        field(6; "Market Average"; Decimal)
        {
            Caption = 'Market Average';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                TestField("Salary Grade");
                "Competitive Gap Basic" := "Market Average" - "Current Basic";
            end;
        }
        field(7; "Date Created"; Date)
        {
            Caption = 'Date Created';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(8; "Time Created"; Time)
        {
            Caption = 'Time Created';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(9; "Last Modified"; DateTime)
        {
            Caption = 'Last Modified';
            Editable = false;
        }
        field(10; "Last modified By"; Code[50])
        {
            Caption = 'Last modified By';
            DataClassification = CustomerContent;
        }
        field(11; "Created By"; Code[50])
        {
            Caption = 'Created By';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(12; "Current Basic"; decimal)
        {
            Caption = 'Current Basic';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(13; "Current Gross"; decimal)
        {
            Caption = 'Current Gross';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(14; "Competitive Gap Basic"; decimal)
        {
            Caption = 'Competitive Gap Basic';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(15; "Adjustment Recommended"; decimal)
        {
            Caption = 'Adjustment Recommended';
            Editable = false;
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Job ID")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()

    begin
        "Date Created" := Today;
        "Time Created" := time;
        "Created By" := UserId;
        "Last Modified" := CurrentDateTime;
        "Last modified By" := UserId;
    end;

    trigger OnModify()
    begin
        "Last Modified" := CurrentDateTime;
        "Last modified By" := UserId;
    end;

    var
        jobs: Record "HR Jobs";
        jobgrades: Record "HR Job Grades";
        salarygrades: Record "Sal Grades";
}
