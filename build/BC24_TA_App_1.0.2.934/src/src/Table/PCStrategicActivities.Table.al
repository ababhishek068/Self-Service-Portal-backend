table 50439 "PC Strategic Activities"
{
    DataClassification = ToBeClassified;
    LookupPageId = "PC Strategic Activities";
    fields
    {
        field(1; Code; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; Description; text[2000])
        {
            DataClassification = ToBeClassified;

        }
        field(3; "Strategic Plan"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "PC Strategies".Code;
        }
        field(4; "Key Result Area"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "PC Key Results Area".Code;
        }
        field(5; "Strategic Objective"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "PC Strategic Objectives".Code;
        }
        field(6; "Annual Plan"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "PC Annual Plan".Code;
        }
        field(7; Impact; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "PC Impact".Code;
        }
        field(8; Outcome; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "PC Outcomes".Code;
        }
        field(9; Output; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "PC Outputs".Code;
        }
        field(10; "Delivery Unit Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "","Employee Based","Department Based","Station Based","Project Based","Organization Based","Donor Based","Directorate Based";
            OptionCaption = ',Employee Based,Department Based,Station Based,Project Based,Organization Based,Donor Based,Directorate Based';

        }
        field(11; "Delivery Unit"; text[2000])
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
        field(12; "Performance Indicator"; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Date From"; Date)
        {
            DataClassification = ToBeClassified;
            TableRelation = "Accounting Period"."Starting Date" where(Closed = filter('No'));
        }
        field(14; "Date To"; Date)
        {
            DataClassification = ToBeClassified;
            //TableRelation = "Accounting Period".Name where(Closed = filter('No'));
            trigger OnValidate()
            begin
                if "Date To" < "Date From" then error('Date To cannot be grater than the from date');
            end;
        }
        field(15; "Budget (In Millions)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Source of Funds"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer."No." where("Customer Posting Group" = filter('DONORS'));
        }
        field(17; "Global Dimension 1"; Code[50])
        {
            DataClassification = TobeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = filter(1));
        }
        field(18; "Global Dimension 2"; Code[50])
        {
            DataClassification = TobeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = filter(2));
        }
        field(19; "Global Dimension 3"; Code[50])
        {
            DataClassification = TobeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = filter(3));
        }
        field(20; "Global Dimension 4"; Code[50])
        {
            DataClassification = TobeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = filter(4));
        }
        field(21; "Global Dimension 5"; Code[50])
        {
            DataClassification = TobeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = filter(5));
        }
        field(22; "Global Dimension 6"; Code[50])
        {
            DataClassification = TobeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = filter(6));
        }


    }

    keys
    {
        key(PK; Code, "Strategic Plan", "Key Result Area", "Strategic Objective", "Annual Plan", Impact, Outcome, Output)
        {
            Clustered = true;
        }
    }



}