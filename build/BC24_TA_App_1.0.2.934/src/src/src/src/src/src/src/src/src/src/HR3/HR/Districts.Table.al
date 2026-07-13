table 50933 Districts
{
    Caption = 'Districts';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; " District Code"; Code[20])
        {
            Caption = ' District Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
            trigger OnValidate()
            var
            begin
                updateorganogramdistrict(" District Code", "District Name");
            end;
        }
        field(2; "District Name"; Text[50])
        {
            Caption = 'District Name';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
            trigger OnValidate()
            var
            begin
                updateorganogramdistrict(" District Code", "District Name");
            end;
        }
    }
    keys
    {
        key(PK; " District Code")
        {
            Clustered = true;
        }
    }
    var
        distrctsRec: Record Districts;
        branchesRec: Record Branches;

        departmentsRec: Record Departments;

        sectorsRec: Record Sectors;

        

        organogram: Record Organogram;

        district: code[20];

    local procedure updateorganogramdistrict(DistrictCode: Code[20]; DistrictName: Text[50])
    begin
        organogram.Reset();
        organogram.SetRange(organogram.District);
        if organogram.FindFirst() then begin
            if DistrictName <> '' then begin
                organogram."District Name" := DistrictName;
            end;

        end else if not organogram.find() then begin
            organogram.Init();
            organogram.District := DistrictCode;
            organogram."District Name" := DistrictName;
        end;
    end;

}


