table 50002 "Online Application Users"
{
    Caption = 'Online Application Users';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; UserId; Integer)
        {
            AutoIncrement = true;
        }
        field(2; SurName; Text[100]) { }
        field(3; Password; Text[20]) { }
        field(4; Email; Text[30]) { }
        field(5; "Created Date"; Date) { }
        field(6; "Last login Date"; Date) { }
        field(7; "Date of Birth"; Date) { }
        field(8; Gender; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = ,Male,Female;
            OptionCaption = ',Male,Female';

        }
        field(9; "ID Number"; Code[30]) { }
        field(10; "Other Names"; Text[150]) { }
        field(11; "Postal Address"; Text[50]) { }
        field(12; "Postal code"; Code[30]) { }
        field(13; "City"; Code[50]) { }
        field(14; "Region"; Text[150]) { }
        field(15; "Home Phone Number"; Code[50]) { }
        field(16; "Cellular Phone Number"; Code[20]) { }




    }

    keys
    {
        key(Key1; UserId)
        {
            Clustered = true;
        }
    }
}
