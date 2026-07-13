table 50312 "Student Clearance"
{
    DataClassification = ToBeClassified;
    LookupPageId = "Student Clearance List";
    fields
    {
        field(1; "Student No"; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(11; "Names"; text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Customer.Name where("No." = field("Student No")));

        }
        field(2; Date; date)
        {
            DataClassification = ToBeClassified;

        }
        field(3; "Fully Cleared"; Boolean)
        {
            DataClassification = ToBeClassified;


        }
        field(4; "Finance"; Option)
        {
            OptionMembers = ,Approved,Rejected;
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                UserSetup: record "User Setup";
            begin
                UserSetup.get();
                UserSetup.TestField("Can Clear Finance");
                if (Finance = Finance::Approved) and (Store = store::Approved) and (Laboratory = Laboratory::Approved) and ("Leather goods section" = "Leather goods section"::Approved)
                 and ("Centre Administrator" = "Centre Administrator"::Approved) and ("Human Resource" = "Human Resource"::Approved) then
                    "Fully Cleared" := true
                else
                    "Fully Cleared" := false;
            end;
        }
        field(5; "Store"; Option)
        {
            OptionMembers = ,Approved,Rejected;
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                UserSetup: record "User Setup";
            begin
                UserSetup.get();
                UserSetup.TestField("Can Clear Store");
                if (Finance = Finance::Approved) and (Store = store::Approved) and (Laboratory = Laboratory::Approved) and ("Leather goods section" = "Leather goods section"::Approved)
                 and ("Centre Administrator" = "Centre Administrator"::Approved) and ("Human Resource" = "Human Resource"::Approved) then
                    "Fully Cleared" := true
                else
                    "Fully Cleared" := false;
            end;
        }
        field(6; "Footwear section"; Option)
        {
            OptionMembers = ,Approved,Rejected;
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                UserSetup: record "User Setup";
            begin
                UserSetup.get();
                UserSetup.TestField("Can Clear Footwear section");
                if (Finance = Finance::Approved) and (Store = store::Approved) and (Laboratory = Laboratory::Approved) and ("Leather goods section" = "Leather goods section"::Approved)
                 and ("Centre Administrator" = "Centre Administrator"::Approved) and ("Human Resource" = "Human Resource"::Approved) then
                    "Fully Cleared" := true
                else
                    "Fully Cleared" := false;
            end;

        }
        field(7; "Leather goods section"; Option)
        {
            OptionMembers = ,Approved,Rejected;
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                UserSetup: record "User Setup";
            begin
                UserSetup.get();
                UserSetup.TestField("Can Clear Leather section");
                if (Finance = Finance::Approved) and (Store = store::Approved) and (Laboratory = Laboratory::Approved) and ("Leather goods section" = "Leather goods section"::Approved)
                 and ("Centre Administrator" = "Centre Administrator"::Approved) and ("Human Resource" = "Human Resource"::Approved) then
                    "Fully Cleared" := true
                else
                    "Fully Cleared" := false;
            end;

        }
        field(8; "Laboratory"; Option)
        {
            OptionMembers = ,Approved,Rejected;
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                UserSetup: record "User Setup";
            begin
                UserSetup.get();
                UserSetup.TestField("Can Clear Laboratory");
                if (Finance = Finance::Approved) and (Store = store::Approved) and (Laboratory = Laboratory::Approved) and ("Leather goods section" = "Leather goods section"::Approved)
                 and ("Centre Administrator" = "Centre Administrator"::Approved) and ("Human Resource" = "Human Resource"::Approved) then
                    "Fully Cleared" := true
                else
                    "Fully Cleared" := false;
            end;
        }
        field(9; "Human Resource"; Option)
        {
            OptionMembers = ,Approved,Rejected;
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                UserSetup: record "User Setup";
            begin
                UserSetup.get();
                UserSetup.TestField("Can Clear Human Resource");
                if (Finance = Finance::Approved) and (Store = store::Approved) and (Laboratory = Laboratory::Approved) and ("Leather goods section" = "Leather goods section"::Approved)
                 and ("Centre Administrator" = "Centre Administrator"::Approved) and ("Human Resource" = "Human Resource"::Approved) then
                    "Fully Cleared" := true
                else
                    "Fully Cleared" := false;
            end;

        }
        field(10; "Centre Administrator"; Option)
        {
            OptionMembers = ,Approved,Rejected;
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                UserSetup: record "User Setup";
            begin
                UserSetup.get();
                UserSetup.TestField("Can Clear Centre Administrator");

                if (Finance = Finance::Approved) and (Store = store::Approved) and (Laboratory = Laboratory::Approved) and ("Leather goods section" = "Leather goods section"::Approved)
                 and ("Centre Administrator" = "Centre Administrator"::Approved) and ("Human Resource" = "Human Resource"::Approved) then
                    "Fully Cleared" := true
                else
                    "Fully Cleared" := false;
            end;

        }

    }

    keys
    {
        key(Key1; "Student No")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin

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