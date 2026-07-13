table 50964 "Trainer Evaluation Header"
{
    Caption = 'Trainer Evaluation';
    DataClassification = ToBeClassified;
    DrillDownPageId="Provider Evaluation List";
    
    fields
    {
        field(1; "Evaluation Code"; Code[20])
        {
            Caption = 'Evaluation Code';
            Editable=false;
        }
        field(2; "Course Code"; Code[20])
        {
            Caption = 'Course Code';
            TableRelation="HR Training Courses"."Course Code" where(Closed=const(false));
            trigger OnValidate()
            begin
                if trainingcourses.Get("Course Code") then begin
                    Trainer:=trainingcourses.Provider;
                    "Trainer Name":=trainingcourses."Provider Name";
                    "Course Name":=trainingcourses."Course Tittle";            

                end;
            end;
        }
        field(3; "Training Need"; Code[20])
        {
            Caption = 'Training Code';
            TableRelation="HR Training Needs Analysis".Code;
        }
        field(4; "Course Name"; Text[100])
        {
            Caption = 'Course Name';
            Editable=false;
        }
        field(5; Trainer; Code[20])
        {
            Caption = 'Trainer';
            Editable=false;
        }
        field(6; "Trainer Name"; Text[100])
        {
            Caption = 'Trainer Name';
            Editable=false;
        }
        field(7; "Employee Code"; Code[20])
        {
            Caption = 'Employee Code';
            TableRelation="HR Training Participants"."Employee Code";
            trigger OnValidate()
            begin

                hremployees.Reset();
                hremployees.SetRange(hremployees."No.","Employee Code");
                if hremployees.Get("Employee Code") then begin
                    "Employee name":=hremployees."First Name"+' '+hremployees."Last Name";
                    "Manager Id":=hremployees."Supervisor No.";
                    if hremployees.Get("Manager Id") then begin

                        "Manager Name":=hremployees."First Name"+' '+hremployees."Last Name";
                    end;

                end;

            end;
        }
        field(8; "Employee name"; Text[50])
        {
            Caption = 'Employee name';
            editable=false;
        }
        field(9; "Manager Id"; Code[20])
        {
            Caption = 'Manager Id';
            Editable=false;
        }
        field(10; "Manager Name"; Text[50])
        {
            Caption = 'Manager Name';
            Editable=false;
        }
        field(11;"Created By";Code[20]){}
        field(12;"Date Created";Date){}
        field(13;"Date Submitted";Date){}
        field(14;"Average Score";Decimal){
            Editable=false;
        }
    }
    keys
    {
        key(PK; "Evaluation Code",Trainer,"Course Code","Training Need","Employee Code")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        if "Evaluation Code" = '' then begin
            hrsetup.Get;
            
                hrsetup.TestField(hrsetup."Probation Nos.");
                "Evaluation Code" := NoSeriesMgt.GetNextNo(hrsetup."Probation Nos.", Today, true);
            
        end;

        // "Probation Code":=getnex
        "Date Created":=Today;
        "Created By":=UserId;
        "Date Submitted":=today;
    end;


    var
    hrsetup: Record "HR Setup";
    NoSeriesMgt: Codeunit "No. Series";
    trainingcourses: Record "HR Training Courses";
    hremployees: Record "HR-Employee";

}
