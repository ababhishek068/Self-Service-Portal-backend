Table 50405 "HR Appraisal Objectives"
{

    fields
    {
        field(1; "Line No"; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Document No"; Code[30]) { }
        field(3; Objective; Text[250]) { }
        field(4; "Key Performance Indicator"; Text[250]) { }
        field(5; Targets; Text[250]) { }
        field(6; "Max Weight"; Decimal) { }
        field(7; Achievements; Text[200]) { }
        field(8; Ratings; Decimal) { }
        field(9; "Appraisal Period"; Code[30]) { }
        field(10; Section; Option)
        {
            OptionCaption = ',Strategic Objectives,Performance Improvement Plan,Learning and Development,Notes and Validation,Mid Year,Core Values,End Year,Quarter2';
            OptionMembers = ,"Strategic Objectives","Performance Improvement Plan","Learning and Development","Notes and Validation","Mid Year","Core Values","End Year",Quarter2;
        }
        field(11; "Staff No"; Code[30]) { }
        field(12; "User ID"; Code[50]) { }
        field(13; "Last Modified By"; Code[30]) { }
        field(14; Deliverables; Text[200]) { }
        field(15; "Time Lines"; Option)
        {
            OptionCaption = ',Q1,Q2,Q3,Q4';
            OptionMembers = ,Q1,Q2,Q3,Q4;
        }
        field(16; "Notes By Appraisee"; Text[250]) { }
        field(17; "Notes By Appraiser"; Text[250]) { }
        field(18; "Notes By HOD"; Text[250]) { }
        field(19; "Approval Comment Line"; Text[250]) { }
        field(20; "Supervisor Rating"; Decimal) { }
        field(21; "HOD Rating"; Decimal) { }
        field(22; "Is stratigic objective"; Boolean) { }
        field(23; "Objective Number"; Integer) { }
    }

    keys
    {
        key(Key1; "Document No", "Line No")
        {
            Clustered = true;
        }
    }

    fieldgroups { }
}

