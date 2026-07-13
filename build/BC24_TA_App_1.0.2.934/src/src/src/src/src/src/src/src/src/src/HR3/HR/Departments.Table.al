table 50935 Departments
{
    Caption = 'Departments/Districts';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Sector Code"; Code[20])
        {
            Caption = 'Sector Code';
            TableRelation = Sectors."Sector code";
            Editable = true;
            NotBlank = true;
        }
        field(3; "Department Code"; Code[20])
        {
            Caption = 'Department/District Code';
            NotBlank = true;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
            trigger OnValidate()
            var
            begin
             TestField("Sector Code");
             dimensions.Reset();
                dimensions.SetRange(dimensions."Global Dimension No.",2);
                dimensions.SetRange(dimensions.Code,"Department Code");
                if dimensions.FindFirst() then begin
                    "Department Name":=dimensions.Name;
                end;

            end;
        }
        field(4; "Department Name"; Text[50])
        {
            Caption = 'Department/District Name';
            Editable=false;
        }
        field(5; level; Option)
        {
            OptionMembers = Department,District;
        }
    }
    keys
    {
        key(PK; "Sector Code", "Department Code")
        {
            Clustered = true;
        }
    }
    var
        distrctsRec: Record Districts;
        branchesRec: Record Branches;

        departmentsRec: Record Departments;
        dimensions: Record "Dimension Value";

        sectorsRec: Record Sectors;


}
