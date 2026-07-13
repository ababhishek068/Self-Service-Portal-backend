Table 50350 "HR Appraisal Val and Compt-UP"
{
    Caption = 'HR Appraisal Values & Competences';
    DrillDownPageID = "HR Appraisal Values - List";
    LookupPageID = "HR Appraisal Values - List";

    fields
    {
        field(1; "Code"; Code[10])
        {
            Editable = false;
        }
        field(2; Category; Option)
        {
            OptionMembers = " ","Staff Values","Core Competence","Managerial and Supervisory Competence";
        }
        field(3; Description; Text[50]) { }
        field(4; "Description 2"; Text[150])
        {
            DataClassification = ToBeClassified;
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

    trigger OnDelete()
    var
        Lines_ValComp: Record "HR Appraisal Lines - Values";
    begin
        Lines_ValComp.Reset;
        Lines_ValComp.SetRange(Description, Description);
        if not Lines_ValComp.IsEmpty then begin
            Error('You cannot Delete this Records because it in use already in an Appraisal Period');
        end;
    end;

    trigger OnInsert()
    begin
        //No. Series
        if Code = '' then begin
            HRAppValComp.Reset();
            if HRAppValComp.FindLast then begin
                Code := IncStr(HRAppValComp.Code)
            end else begin
                Code := 'VCL-0001';
            end;
        end;
    end;

    var
        HRAppValComp: Record "HR Appraisal Val and Compt-UP";
}

