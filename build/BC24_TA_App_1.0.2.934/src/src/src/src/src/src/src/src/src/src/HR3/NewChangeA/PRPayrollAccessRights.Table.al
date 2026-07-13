table 50375 "PR Payroll Access Rights"
{
    Caption = 'PR Payroll Access Rights';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "User ID"; Code[50])
        {
            Caption = 'User ID';
            DataClassification = ToBeClassified;
            TableRelation = "User Setup"."User ID";
        }
        field(2; Authorized; Boolean)
        {
            Caption = 'Authorized';
            DataClassification = ToBeClassified;
        }

        field(3; "Last Modified By"; Code[50])
        {
            Caption = 'Last Modified By';
            Editable = false;
        }

        field(4; "Last DateTime Modified"; DateTime)
        {
            Caption = 'Last Modified DateTime';
            Editable = false;
        }
    }
    keys
    {
        key(PK; "User ID")
        {
            Clustered = true;
        }
    }
    trigger OnDelete()
    begin
        if UserId <> 'BRS\DSL' then
            if UserId <> 'BRS\DWESA' THEN
                Error('Deletion disabled');

    end;
}
