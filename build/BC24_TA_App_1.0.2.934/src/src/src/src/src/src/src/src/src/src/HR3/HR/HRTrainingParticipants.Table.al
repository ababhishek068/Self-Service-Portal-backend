Table 50622 "HR Training Participants"
{
    DrillDownPageID = "HR Training Partcipants";
    LookupPageID = "HR Training Partcipants";

    fields
    {
        field(1; "Training Code"; Code[30])
        {

            trigger OnValidate()
            begin
                /*IF Training."Training category"<> Training."Training category"::Group THEN
                ERROR(mcontent);
                */

            end;
        }
        field(2; "Employee Code"; Code[30])
        {
            TableRelation = "HR-Employee"."No.";

            trigger OnValidate()
            begin
                if Hr.Get("Employee Code") then
                    "Employee name" := Hr."First Name" + ' ' + Hr."Middle Name" + ' ' + Hr."Last Name";
            end;
        }
        field(3; "Employee name"; Text[60]) { }
        field(4; Objectives; Text[100]) { }
    }

    keys
    {
        key(Key1; "Training Code", "Employee Code")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        Training.Reset;
        Training.SetRange(Training."Application No", "Training Code");
        if Training.Find('-') then begin
            if Training."Training Category" <> Training."training category"::Group then
                Error(mcontent);
        end;
    end;

    var
        Hr: Record "HR-Employee";
        Training: Record "HR Training Applications";
        mcontent: label 'You cannot assign participants where training category is ''Individual''';
}

