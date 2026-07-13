Table 50818 "TNA Application List"
{
    fields
    {
        field(1; "Code"; Code[20])
        {
            NotBlank = false;
        }
        field(2; "Entry No"; Integer)
        {
            AutoIncrement = true;
        }
        field(3; "Proposed Intervention"; Text[100])
        {
            Caption = 'Training Name';
        }
        field(4; "justification(Skill Gap)"; Text[300]) { }
        field(5; "Proposed Start Date"; Date) { }
        field(6; "Duration Units"; Option)
        {
            OptionMembers = Hours,Days,Weeks,Months,Years;
        }
        field(7; "Proposed End Date"; Date) { }
        field(8; "Source of Funds"; Option)
        {
            OptionMembers = "",Self,Company,Donor,Other;
        }
        field(9; "Cost Of Training"; Decimal)
        {
            trigger OnValidate()
            begin
                "Total Cost" := "Cost Of Training" + "Daily Subsistence" + "Transport Transfers";
            end;
        }
        field(10; Location; Text[100]) { }
        field(11; "Need Source"; Option)
        {
            OptionCaption = 'Appraisal,Professional Need,Others';
            OptionMembers = Appraisal,"Professional Need",Others;
        }

        field(12; "Quarter Offered"; Option)
        {
            OptionCaption = ' ,Q1,Q2,Q3,Q4';
            OptionMembers = " ",Q1,Q2,Q3,Q4;
        }
        field(13; Trainer; Code[20])
        {
            TableRelation = Vendor."No.";
            trigger OnValidate()
            var
                Vend: Record Vendor;
            begin
                Vend.Reset();
                Vend.SetRange("No.", Trainer);
                if Vend.Find('-') then "Trainer Name" := Vend.Name;
            end;
        }
        field(14; "Trainer Name"; Text[100]) { }
        field(15; "Daily Subsistence"; Decimal)
        {
            trigger OnValidate()
            begin
                "Total Cost" := "Cost Of Training" + "Daily Subsistence" + "Transport Transfers";
            end;
        }
        field(16; "Transport Transfers"; Decimal)
        {
            trigger OnValidate()
            begin
                "Total Cost" := "Cost Of Training" + "Daily Subsistence" + "Transport Transfers";
            end;
        }
        field(17; "Total Cost"; Decimal) { }
    }

    keys
    {
        key(Key1; "Code", "Entry No")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnInsert()
    begin

    end;
}

