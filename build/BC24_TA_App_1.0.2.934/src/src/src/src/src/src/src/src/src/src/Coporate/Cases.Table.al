table 50198 "Cases"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Case No"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Case Date"; date)
        {
            DataClassification = ToBeClassified;

        }
        field(3; "Case Nature"; text[200])
        {
            DataClassification = ToBeClassified;

        }
        field(4; "Type of Offence"; text[500])
        {
            DataClassification = ToBeClassified;

        }
        field(5; "Offense Date"; date)
        {
            DataClassification = ToBeClassified;

        }
        field(6; "Offense Time"; time)
        {
            DataClassification = ToBeClassified;

        }
        field(7; "Offense Place"; text[100])
        {
            DataClassification = ToBeClassified;

        }
        field(8; "Amount Involved"; Decimal)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                Balance := "Amount Involved" - "Amount Recovered";
            end;
        }
        field(9; "Amount Recovered"; Decimal)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                Balance := "Amount Involved" - "Amount Recovered";
            end;

        }
        field(10; "Balance"; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(11; "No Series"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(12; "Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = ,Investigation,ODPP,"Pending Arrest","Pending Before Court",Convicted,Acquittal,Closed,"No Further Police Action",Withdrawn;

        }
        field(13; "Plea Date"; Date)
        {
            DataClassification = ToBeClassified;

        }
        field(44; "Submission Date"; Date)
        {
            DataClassification = ToBeClassified;

        }
        field(14; "Mention Date"; date)
        {
            DataClassification = ToBeClassified;

        }
        field(15; "Hearing Date"; date)
        {
            DataClassification = ToBeClassified;

        }
        field(16; "Verdict"; Text[200])
        {
            DataClassification = ToBeClassified;

        }
        field(36; "Verdict Status"; option)
        {
            OptionMembers = ,Guilty,"No Guilty";
            DataClassification = ToBeClassified;

        }
        field(17; "Trial Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = ,Convicted,Acquittal,Withdrawn,Appeal,Retrial,Closed;

        }
        field(18; "User ID"; code[20]) { }
        field(19; "Date of submission to ODPP"; date) { }
        field(20; "Reference"; text[200]) { }
        field(21; "Case Description"; text[500]) { }
        field(22; "Source of Complaint"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = ,"Walk-ins","Authority/Institutional",Anonymous;
        }
        field(23; "Sentence"; text[500]) { }
        field(24; "Remarks"; text[1000]) { }
        field(25; "Court Name"; text[500]) { }
        field(26; "Court File No."; text[500]) { }
        field(27; "Investigators Count"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Investigator Information" where(Code = field("Case No")));
        }
        field(28; Priority; option)
        {
            OptionMembers = ,Normal,Urgent;
        }
        field(29; "Sacco No"; code[20])
        {

            TableRelation = Customer."No." where("Customer Posting Group" = filter(<> 'IMPREST'));
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                Cust: record Customer;
            begin
                if Cust.get("Sacco No") then
                    "Sacco Name" := Cust.Name;
            end;


        }
        field(30; "Sacco Name"; Text[200]) { }
        field(31; "Handed Over On"; date) { }
        field(32; "Taken Over By"; Text[200]) { }
        field(33; "Taken Over On"; date) { }
        field(34; "Handed Over By"; Text[200]) { }
    }

    keys
    {
        key(Key1; "Case No")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var
        GenSetu: record "Security Setups";
        NoSeriesMgt: Codeunit "No. Series";
    begin
        if "Case No" = '' then begin
            GenSetu.Get;
            GenSetu.TestField(GenSetu."Case Nos");
            "Case No":=NoSeriesMgt.GetNextNo(GenSetu."Case Nos",  0D, true)

        end;
        "User ID" := Database.UserId;

    end;


    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}