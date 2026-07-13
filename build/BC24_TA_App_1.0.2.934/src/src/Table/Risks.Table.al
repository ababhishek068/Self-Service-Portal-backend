Table 50698 Risks
{

    fields
    {
        field(1; "Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Department; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = filter(2));

        }
        field(3; "Risk Desc 1"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Risk Desc 2"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Risk Desc 3"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Risk Desc 4"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Indicator Desc 1"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Indicator Desc 2"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(9; Environment; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ',Economic';
            OptionMembers = ,Economic;
        }
        field(10; Impact; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(11; Likelihood; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(12; Level; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Date Created"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Created By"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(15; "No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Line No"; integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }

    }

    keys
    {
        key(Key1; "Code", "Line No", Department)
        {
            Clustered = true;
        }
    }

    fieldgroups { }
    trigger OnInsert()
    var
        GenLedgerSetup: Record "Security Setups";
        NoSeriesMgt: Codeunit "No. Series";
        HREmp: Record "HR-Employee";
        UserSetup: record "User Setup";
    begin
        if "Code" = '' then begin
            GenLedgerSetup.Get;
            GenLedgerSetup.TestField(GenLedgerSetup."Risk Nos");
            "Code":=NoSeriesMgt.GetNextNo(GenLedgerSetup."Risk Nos",  0D, true);

        end;
        if UserSetup.get(Database.UserId) then
            if HREmp.get(UserSetup."Employee No.") then
                Department := HREmp."Department Code";
    end;
}

