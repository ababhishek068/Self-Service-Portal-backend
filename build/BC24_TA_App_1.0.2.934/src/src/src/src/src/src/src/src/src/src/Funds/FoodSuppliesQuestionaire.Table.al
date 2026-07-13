Table 50761 "Food Supplies Questionaire"
{

    fields
    {
        field(1; "Line No."; Integer)
        {
            AutoIncrement = true;
            Editable = false;
        }
        field(2; "Tender No."; Code[20])
        {
            Editable = true;
        }
        field(3; "Receipt No."; Code[20])
        {
            Editable = true;
        }
        field(4; "TIN No."; Code[20])
        {
            Editable = true;
        }
        field(5; "Supplier Name"; Text[70]) { }
        field(6; Date; Date) { }
        field(7; "Box Number"; Text[50]) { }
        field(8; "Postal Code"; Code[20]) { }
        field(9; Town; Text[50]) { }
        field(10; "Physical Location"; Text[100]) { }
        field(11; "Contact Name"; Text[70]) { }
        field(12; "Phone No"; Text[30]) { }
        field(13; "Commodity Supplied"; Text[250]) { }
        field(14; "Product Description"; Option)
        {
            OptionCaption = 'High Risk,Medium Risk,Low Risk';
            OptionMembers = "High Risk","Medium Risk","Low Risk";
        }
        field(15; "FS Risk Assessment"; Boolean) { }
        field(16; "Externally Evaluated"; Boolean) { }
        field(17; Satisfactory; Boolean) { }
        field(18; "CCP Identified"; Boolean) { }
        field(19; "CCP Operators Trained"; Boolean) { }
        field(20; "CCP Regularly Reviewed"; Boolean) { }
        field(21; "CCP Last Review"; Date) { }
        field(22; "CCP Routinely Monitored"; Boolean) { }
        field(23; Prosecuted; Boolean) { }
        field(24; "Served Improvement Notice"; Boolean) { }
        field(25; "Food Handlers Employed"; Integer) { }
        field(26; "Food Handlers Trained"; Boolean) { }
        field(27; "Basic Trained Personnel"; Integer) { }
        field(28; "Intermidiate Trained Personnel"; Integer) { }
        field(29; "Advanced Trained Personnel"; Integer) { }
        field(30; "Person Completing Questionaire"; Text[70]) { }
        field(31; "Position Held"; Text[50]) { }
        field(32; "Evaluated By"; Text[100]) { }
        field(33; "Completion Date"; Date) { }
        field(39004242; MyRecId; RecordID) { }
    }

    keys
    {
        key(Key1; "Tender No.", "Receipt No.", "TIN No.")
        {
            Clustered = true;
        }
        key(Key2; "Line No.") { }
    }

    fieldgroups { }

    trigger OnDelete()
    begin
        Error('You cannot delete data from this table');
    end;
}

