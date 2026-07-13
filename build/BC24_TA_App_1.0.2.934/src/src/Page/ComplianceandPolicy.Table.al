table 50921 "Compliance and Policy"
{
    Caption = 'Compliance and Policy';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Emp Id"; Code[20])
        {
            Caption = 'Emp Id';
            DataClassification = CustomerContent;
            TableRelation = "HR-Employee"."No." where(Status = const(Active));
        }
        field(2; "Hr Policy No"; Code[20])
        {
            Caption = 'Hr Policy No';
            DataClassification = CustomerContent;
        }
        field(3; "Hr policy description"; Text[100])
        {
            Caption = 'Hr policy description';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(4; "Version"; Code[20])
        {
            Caption = 'Version';
            DataClassification = CustomerContent;
        }
        field(5; "Acknowledgement Date"; Date)
        {
            Caption = 'Acknowledgement Date';
        }
        field(6; "Expiry Date"; Date)
        {
            Caption = 'Expiry Date';
        }
        field(7; "Delivery Method"; Option)
        {
            OptionMembers = "",Email,ERP,"In-person";
            OptionCaption = '"",Email,ERP,"In-person"';
            Caption = 'Delivery Method';
            DataClassification = CustomerContent;
        }
        field(8; "Acknowledgement Status"; Option)
        {
            OptionMembers = "",Pending,Signed,Declined;
            OptionCaption = '"",Pending,Signed,Declined';
            Caption = 'Acknowledgement Status';
            DataClassification = CustomerContent;
        }
        field(9; "Created By"; Code[30])
        {
            Caption = 'Created By';
            Editable = false;
        }
        field(10; "Date Created"; Date)
        {
            Caption = 'Date Created';
            Editable = false;
        }
        field(11; "Time Created"; Time)
        {
            Caption = 'Time created';
            Editable = false;
        }
        field(12; Department; code[50])
        {
            Caption = 'Department';
            Editable = false;
        }
        field(13; Project; Code[50])
        {
            Caption = 'Project';
            Editable = false;
        }
        field(14; Branch; Code[50])
        {
            Caption = 'Branch';
            Editable = false;
        }
    }
    keys
    {
        key(PK; "Emp Id", "Hr Policy No", "Version")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        "Created By" := UserId;
        "Date Created" := Today;
        "Time Created" := time;

    end;

    var
        employees: record "HR-Employee";
}
