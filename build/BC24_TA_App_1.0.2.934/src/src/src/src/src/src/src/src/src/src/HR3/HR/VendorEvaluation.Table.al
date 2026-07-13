table 50974 "Vendor Evaluation Header"
{
    Caption = 'Trainer Evaluation';
    DataClassification = ToBeClassified;
    DrillDownPageId = "Vendor Evaluation List";

    fields
    {
        field(1; "Evaluation Code"; Code[20])
        {
            Caption = 'Evaluation Code';
            Editable = false;
        }
        field(2;"Average Score";Decimal){
            Editable=false;
        }

        
       
        field(5; Vendor; Code[20])
        {
            Caption = 'Vendor';
            Editable = true;
            TableRelation=Vendor."No." ;
            trigger OnValidate()
            var
            vends: Record Vendor;
            begin

                if vends.get(Vendor) then begin

                    "Vendor Name":=vends.Name;
                end

            end;
        }
        field(6; "Vendor Name"; Text[100])
        {
            Caption = 'Vendor Name';
            Editable = false;
        }
        field(7; "Employee Code"; Code[20])
        {
            Caption = 'Employee Code';
            TableRelation = "HR-Employee"."No." where(Status=const(Active));
            trigger OnValidate()
            begin

                hremployees.Reset();
                hremployees.SetRange(hremployees."No.", "Employee Code");
                if hremployees.Get("Employee Code") then begin
                    "Employee name" := hremployees."First Name" + ' ' + hremployees."Last Name";
                    "Manager Id" := hremployees."Supervisor No.";
                    if hremployees.Get("Manager Id") then begin

                        "Manager Name" := hremployees."First Name" + ' ' + hremployees."Last Name";
                    end;

                end;

            end;
        }
        field(8; "Employee name"; Text[50])
        {
            Caption = 'Employee name';
            editable = false;
        }
        field(9; "Manager Id"; Code[20])
        {
            Caption = 'Manager Id';
            Editable = false;
        }
        field(10; "Manager Name"; Text[50])
        {
            Caption = 'Manager Name';
            Editable = false;
        }
        field(11; "Created By"; Code[20]) { }
        field(12; "Date Created"; Date) { }
        field(13; "Date Submitted"; Date) { }
    }
    keys
    {
        key(PK; "Evaluation Code", Vendor,"Date Created")
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
        "Date Created" := Today;
        "Created By" := UserId;
        "Date Submitted" := today;
    end;


    var
        hrsetup: Record "HR Setup";
        NoSeriesMgt: Codeunit "No. Series";
        trainingcourses: Record "HR Training Courses";
        hremployees: Record "HR-Employee";

}
