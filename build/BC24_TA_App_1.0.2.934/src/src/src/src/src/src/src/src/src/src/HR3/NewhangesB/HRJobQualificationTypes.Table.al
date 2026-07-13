Table 50414 "HR Job Qualification Types"
{
    DataCaptionFields = "Qualification Type", "Qualification Code", "Qualification Description";
    DrillDownPageID = "HR Job Qualification Types - L";
    LookupPageID = "HR Job Qualification Types - L";

    fields
    {
        field(1; "Qualification Type"; Code[20])
        {
            TableRelation = "HR Lookup Values".Code where(Type = const("Qualification Type"));
        }
        field(2; "Qualification Code"; Code[20])
        {
            //Editable = false;
        }
        field(3; "Qualification Description"; Text[150])
        {
            Caption = 'Description';

            trigger OnValidate()
            var
                QualificationExistErr: label 'Qualification Description %1 exists with Qualification Code %2';
            begin

                HRJobQualificationTypes.Reset();
                HRJobQualificationTypes.SetRange("Qualification Description", "Qualification Description");
                if HRJobQualificationTypes.Count > 1 then Error(QualificationExistErr, "Qualification Description", "Qualification Code");

                if "Qualification Description" <> '' then "Qualification Description" := UpperCase("Qualification Description");
                if (StrLen("Qualification Description") > MaxStrLen("Qualification Description")) then Error('Maximum characters for Qualification Description is %1', MaxStrLen("Qualification Description"));
            end;
        }
    }

    keys
    {
        key(Key1; "Qualification Type", "Qualification Code")
        {
            Clustered = true;
        }
        key(Key2; "Qualification Description") { }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Qualification Type", "Qualification Code", "Qualification Description") { }
    }

    trigger OnInsert()
    begin

    end;

    var
        HRJobQualificationTypes: Record "HR Job Qualification Types";
}

