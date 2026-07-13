table 50932 Organogram
{
    Caption = 'Organogram';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; District; Code[20])
        {
            Caption = 'District';
            Editable = false;
            TableRelation=Districts." District Code";
        }
        field(2; "District Name"; Text[50])
        {
            Caption = 'District Name';
            Editable = false;
        }
        field(3; Branch; Code[20])
        {
            Caption = 'Branch';
            Editable = false;
            TableRelation=Branches."Division/Branch Code";
        }
        field(4; "Branch Name"; Text[50])
        {
            Caption = 'Branch Name';
            Editable = false;

        }
        field(5; Department; Code[20])
        {
            Caption = 'Department';
            Editable = false;
            TableRelation=Departments."Department Code";
        }
        field(6; "Department Name"; Text[50])
        {
            Caption = 'Department Name';
            Editable = false;
        }
        field(7; Sector; Code[20])
        {
            Caption = 'Sector';
            Editable = false;
            TableRelation=Sectors."Sector Code";
        }
        field(8; "Sector Name"; Text[50])
        {
            Caption = 'Sector Name';
            Editable = false;
        }
       
        field(10; "Process Name"; Text[50])
        {
            Caption = 'Process Name';
            Editable = false;
        }
        field(11; "Cost Center"; Code[20])
        {
            Caption = 'Cost Center';
            Editable = false;
        }
        field(12; "Cost Centre Name"; Text[50])
        {
            Caption = 'Cost Centre Name';
            Editable = false;
        }
    }
    keys
    {
        key(PK; District, Branch, Department, Sector)
        {
            Clustered = true;
        }
    }
    var
    distrctsRec: Record Districts;
    branchesRec: Record Branches;

    departmentsRec: Record Departments;

    sectorsRec: Record Sectors;

    

    //CostCentresRec: Record cos
}
