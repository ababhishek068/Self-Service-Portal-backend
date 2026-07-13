table 50928 "Branch Grading"
{
    Caption = 'Branch Grading';
    LookupPageId = "Branch Grading";
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Branch Code"; Code[20])
        {
            Caption = 'Branch Code';
            DataClassification = CustomerContent;
            TableRelation = Branches."Division/Branch Code" where(level=const(Branch));

            trigger OnValidate()
            var
            brang: Record Branches;
            begin

                // DimVal.Reset;
                // DimVal.SetRange(DimVal.Code, "Branch Code");
                // if DimVal.Find('-') then
                //     "Branch Name" := DimVal.Name;
                Clear("Branch Name");
                brang.Reset();
                brang.SetRange(brang."Division/Branch Code","Branch Code");
                brang.SetRange(brang.level,brang.level::Branch);
                if brang.FindFirst() then begin
                    "Branch Name":=brang."Division/Branch Name";

                end;
            end;
        }
        field(2; "Branch Grade"; Integer)
        {
            Caption = 'Branch Grade';
            DataClassification = CustomerContent;
        }
        field(3; "Branch Name"; text[50])
        {
            Caption = 'Branch Name';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(4; StartDate; Date)
        {
            Caption = 'StartDate';
            DataClassification = CustomerContent;
        }
        field(5; EndDate; Date)
        {
            Caption = 'EndDate';
            DataClassification = CustomerContent;
        }
        field(6; "Created By"; Code[50])
        {
            Caption = 'Created By';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(7; Status; Option)
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
            OptionMembers = Open,pending,Approved;
        }
        field(8; "Date Created"; Date) { }


    }


    keys
    {
        key(PK; "Branch Code", StartDate)
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        "Created By" := UserId;
        "Date Created" := Today;
    end;

    var
        DimVal: Record "Dimension Value";
}
