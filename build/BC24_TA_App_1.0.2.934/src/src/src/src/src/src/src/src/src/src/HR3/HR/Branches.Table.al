table 50934 Branches
{
    Caption = 'Branches';
    DataClassification = ToBeClassified;
    DrillDownPageId="Branches List";
    
    fields
    {
        field(1; "Sector Code"; Code[20])
        {
            Caption = 'Sector Code';
            TableRelation=Sectors."Sector Code";
            NotBlank=true;
        }
        field(2; "Department/District Code"; Code[20])
        {
            Caption = 'Department/District Code';
            NotBlank=true;
            TableRelation = Departments."Department Code" where("Sector Code"=field("Sector Code"));
            trigger OnValidate()
            begin
                TestField("Sector Code");
               // updateorg("District Code","Branch Code");
            end;
        }
        field(3; "Division/Branch Code"; Code[20])
        {
            Caption = 'Division/Branch Code';
            NotBlank=true;
            TableRelation="Dimension Value".Code where("Global Dimension No." = const(3));
            trigger OnValidate()
            var
            begin

                TestField("Department/District Code");
                dimensions.Reset();
                dimensions.SetRange(dimensions."Global Dimension No.",3);
                dimensions.SetRange(dimensions.Code,"Division/Branch Code");
                if dimensions.FindFirst() then begin
                    "Division/Branch Name":=dimensions.Name;
                end;
            end;
        }
        field(4;"Division/Branch Name";Text[50])
        {
            Editable=false;

        }
        field(5;level;Option)
        {
            OptionMembers=Division,Branch;
        }
        field(6;Taxed;Boolean){
            Caption='Not Taxed';
            trigger OnValidate()
            begin
                if level<>level::Branch then
                Error('Applies only to branches');
            end;
        }
    }
    keys
    {
        key(PK;"Sector Code","Department/District Code","Division/Branch Code",level)
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

    
    organogra: Record Organogram;

    local procedure updateorg(DistrictCode: Code[20]; BranchCode: Code[20])
    begin
        
        organogra.Reset();
        organogra.SetRange(organogra.District,DistrictCode);
        organogra.SetRange(organogra.Branch,BranchCode);
        if organogra.Find('-') then begin

        end else if not organogra.Find() then begin
            organogra.Reset();
            organogra.SetRange(organogra.District);
            organogra.SetRange(organogra.Branch,'');
            if organogra.FindFirst() then begin
                
            end;
        
        
        end;
    end;
}
