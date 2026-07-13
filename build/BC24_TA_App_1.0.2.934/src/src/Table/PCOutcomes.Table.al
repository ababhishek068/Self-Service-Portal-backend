table 50194 "PC Outcomes"
{
    DataClassification = ToBeClassified;
    LookupPageId = "PC Outcomes";
    fields
    {
        field(1; Code; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Strategic Plan"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Key Result Area"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Strategic Objective"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Annual Plan"; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Impact"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(Key1; Code, "Strategic Plan", "Key Result Area", "Strategic Objective", "Annual Plan", Impact)
        {
            Clustered = true;
        }
    }
}