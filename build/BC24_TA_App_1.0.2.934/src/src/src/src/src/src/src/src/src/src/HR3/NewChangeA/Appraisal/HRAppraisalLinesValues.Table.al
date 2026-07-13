table 50682 "HR Appraisal Lines - Values"
{
    // version APPRAISAL BC160

    Caption = '"HR Appraisal Lines - Values and Competences "';
    // DrillDownPageID = 50427;
    // LookupPageID = 50427;

    fields
    {
        field(1; "Appraisal No."; Code[10])
        {
            Editable = false;
            TableRelation = "HR Appraisal Header - UP"."Appraisal No";
        }
        field(2; Category; Option)
        {
            Editable = false;
            OptionMembers = " ",Staff,"Managerial & Supervisory";
        }
        field(3; "Sub Category"; Option)
        {
            Editable = false;
            OptionMembers = " ",Values,Competency;
        }
        field(4; "Code"; Code[10])
        {
            //TableRelation = "HR Appraisal Values and Compt.".Code WHERE("Blocked" = CONST("No"));

            trigger OnValidate();
            var
                HRApp_ValComp: Record "HR Appraisal Lines - Values-UP";
            begin
                CLEAR(Description);
                CLEAR(Category);
                CLEAR("Sub Category");
                CLEAR("Supervisor Comments");

                HRApp_ValComp.RESET;
                HRApp_ValComp.SETRANGE(Code, Code);

                IF HRApp_ValComp.FIND('-') THEN BEGIN
                    Description := HRApp_ValComp.Description;
                    Category := HRApp_ValComp.Category;
                    //"Sub Category" := HRApp_ValComp."Sub Category";
                END;

                //
                // //Duplicates
                // Lines_ValComp.RESET;
                // Lines_ValComp.SETRANGE("Appraisal No.","Appraisal No.");
                // Lines_ValComp.SETRANGE(Code,Code);
                // IF Lines_ValComp.FIND('-') THEN ERROR('Code [ %1 ] already exists on current lines',Code);
            end;
        }
        field(5; Description; Text[50])
        {
            Editable = false;
        }
        field(6; "Supervisor Comments"; Text[100]) { }
    }

    keys
    {
        key(Key1; "Appraisal No.", "Code") { }
        key(Key2; Category, "Sub Category") { }
    }

    fieldgroups { }
}

