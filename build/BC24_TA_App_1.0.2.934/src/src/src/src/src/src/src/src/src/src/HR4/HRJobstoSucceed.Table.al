Table 50213 "HR Jobs to Succeed"
{

    fields
    {
        field(1; "Job ID"; Code[20])
        {
            TableRelation = "HR Jobs"."Job ID" where("Job ID" = field("Job ID"));
        }
        field(2; Description; Text[50])
        {
            CalcFormula = lookup("HR Jobs"."Job Description" where("Job ID" = field("Job ID")));
            FieldClass = FlowField;
        }
        field(3; Department; Text[50]) { }
        field(4; "Dimension 1"; Code[50]) { }
        field(5; "Dimension 2"; Code[50]) { }
        field(6; Availability; Boolean) { }
        field(7; Comment; Text[250]) { }
        field(8; "No of Posts"; Integer) { }
        field(9; "Position Reporting to"; Code[10]) { }
        field(10; "Occupied Positions"; Integer) { }
        field(11; "Vacant Positions"; Decimal) { }
        field(12; Dimension3; Code[10]) { }
        field(13; Dimension4; Code[10]) { }
        field(14; Dimension5; Code[10]) { }
        field(15; Dimension6; Code[10]) { }
        field(16; Dimension7; Code[10]) { }
        field(17; Dimension8; Code[10]) { }
        field(18; "Dimension Filter 1"; Code[10]) { }
        field(19; "Dimension Filter 2"; Code[10]) { }
        field(20; "Dimension Filter 3"; Code[10]) { }
        field(21; "Dimension Filter 4"; Code[10]) { }
        field(22; "Dimension Filter 5"; Code[10]) { }
        field(23; "Dimension Filter 6"; Code[10]) { }
        field(24; "Dimension Filter 7"; Code[10]) { }
        field(25; "Dimension Filter 8"; Code[10]) { }
        field(26; Grade; Code[10]) { }
        field(27; "Show Only Existing"; Boolean) { }
        field(28; "Act Job ID"; Code[10]) { }
        field(30; Source; Option)
        {
            OptionMembers = " ",Dismissal,"New Post","Organisation Change";
        }
        field(31; "Responsibility Center"; Code[10]) { }
        field(32; Status; Option)
        {
            OptionMembers = New,"Pending Approval",Approved;
        }
        field(33; "No."; Code[20]) { }
        field(50000; "No series"; Code[30]) { }
    }

    keys
    {
        key(Key1; "Job ID", "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        if "No." = '' then begin
            HRSetup.Get;
            HRSetup.TestField(HRSetup."Succession No");
            "No.":=NoSeriesMgt.GetNextNo(HRSetup."Succession No", 0D,true);
        end;
    end;

    var
        HRSetup: Record "HR Setup";
        NoSeriesMgt: Codeunit "No. Series";
}

