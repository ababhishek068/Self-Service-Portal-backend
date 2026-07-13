table 50654 "PC Annual Plan Entries"
{
    DataClassification = ToBeClassified;
    LookupPageId = "PC Annual Plan Entries";
    fields
    {
        field(1; EntryNo; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;

        }
        field(2; "Annual Plan"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "PC Annual Plan".Code;
        }
        field(3; "Strategic Plan"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "PC Strategies".Code;
        }
        field(4; Active; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Delivery Unit Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "","Employee Based","Department Based","Station Based","Project Based","Organization Based","Donor Based","Directorate Based";
            OptionCaption = ',Employee Based,Department Based,Station Based,Project Based,Organization Based,Donor Based,Directorate Based';

        }
        field(6; "Delivery Unit"; text[2000])
        {
            DataClassification = ToBeClassified;
            TableRelation = if ("Delivery Unit Type" = filter('Employee Based')) "HR-Employee"."No."
            else
            if ("Delivery Unit Type" = filter('Department Based')) "Dimension Value".Code where("Global Dimension No." = const(2))
            else
            if ("Delivery Unit Type" = filter('Station Based')) "Dimension Value".Code where("Global Dimension No." = const(1))
            else
            if ("Delivery Unit Type" = filter('Project Based')) "Dimension Value".Code where("Global Dimension No." = const(4))
            else
            if ("Delivery Unit Type" = filter('Donor Based')) "Dimension Value".Code where("Global Dimension No." = const(3))
            else
            if ("Delivery Unit Type" = filter('Directorate Based')) "Dimension Value".Code where("Global Dimension No." = const(5));
        }
        field(7; Output; text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(8; Activity; text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Performance Indicator"; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Date From"; Date)
        {
            DataClassification = ToBeClassified;
            TableRelation = "Accounting Period"."Starting Date" where(Closed = filter('No'));
        }
        field(11; "Date To"; Date)
        {
            DataClassification = ToBeClassified;
            //TableRelation = "Accounting Period".Name where(Closed = filter('No'));
            trigger OnValidate()
            begin
                if "Date To" < "Date From" then error('Date To cannot be grater than the from date');
            end;
        }
        field(12; "Budget"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Source of Funds"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer."No." where("Customer Posting Group" = filter('DONORS'));
        }

    }
    keys
    {
        key(PK; EntryNo, "Annual Plan", "Strategic Plan")
        {
            Clustered = true;
        }
    }
}