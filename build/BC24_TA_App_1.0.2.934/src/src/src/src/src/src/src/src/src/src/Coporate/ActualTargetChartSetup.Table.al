table 51021 "Actual Target Chart Setup"
{
    Caption = 'Achievement vs Target Tasks Chart Setup';
    DataClassification = ToBeClassified;
    
    fields
    {
        field(1; "User ID"; Text[100])
        {
            Caption = 'UserID';
        }
        field(2; ChartType; Option)
        {
            Caption = 'ChartType';
            OptionMembers="Column",Bar,Pie,Line,Bubble,"Area";
        }
        field(3; "Baseline Type"; Option)
        {
            Caption = 'Baseline Type';
            OptionMembers=NA,Percentage,Number;
        }
        field(4; "Activity Type"; option)
        {
            Caption = 'Activity Type';
            OptionMembers="",Outcome,Output,Activity;
        }
        field(5;"Task No";code[20]){
            TableRelation="Job Task"."Job Task No." where("Job No."=field(Project),Job_Type=field("Activity Type"),"Baseline Type"=field("Baseline Type"));
            
            trigger OnValidate()
            begin
                projects.Reset();
                projects.SetRange(projects."Job Task No.",rec."Task No");
                if projects.FindFirst() then begin
                    "Task Description":=projects.Description;
                    
                end;
            end;
        }
        field(6;"Task Description";text[200]){
            Editable=false;
        }
        field(7;"Exclude From Chart";Boolean){}
        field(8;Project;Code[20])
        {
            TableRelation="My Job"."Job No." where("Show task line Graphs"=filter(true),"User ID"=field("User ID"));
        }
    }
    keys
    {
        key(PK; "User ID",Project,"Task No")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        "User ID":=UserID;
        myjobs.Reset();
        myjobs.SetRange(myjobs."User ID",UserID);
        if myjobs.FindFirst() then begin
            myproject:=myjobs."Job No.";
        end;
        Project:=myproject;

    end;
    var
    projects: Record "Job Task";
    myjobs:Record "My Job";
    myproject:Code[20];
}
