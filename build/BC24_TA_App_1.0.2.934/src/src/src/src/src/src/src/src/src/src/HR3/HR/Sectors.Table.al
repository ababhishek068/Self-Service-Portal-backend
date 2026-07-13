table 50936 Sectors
{
    Caption = 'Sectors';
    DrillDownPageId="Sector List";
    DataClassification = ToBeClassified;
    
    fields
    {
        field(1; "Sector code"; Code[20])
        {
            Caption = 'Sector code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
            trigger OnValidate()
            begin
                dimensions.Reset();
                dimensions.SetRange(dimensions."Global Dimension No.",1);
                dimensions.SetRange(dimensions.Code,"Sector code");
                if dimensions.FindFirst() then begin
                    "Sector Name":=dimensions.Name;
                end;
            end;
            
        }
                field(5; "Sector Name"; Text[50])
        {
            Caption = 'Sector Name';
            Editable=false;
        }
    }
    keys
    {
        key(PK; "Sector Code")
        {
            Clustered = true;
        }
    }
    var
     distrctsRec: Record Districts;
    branchesRec: Record Branches;

    departmentsRec: Record Departments;

    sectorsRec: Record Sectors;
    dimensions: Record "Dimension Value";

    
}
