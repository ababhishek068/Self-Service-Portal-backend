table 52130 "Portal Employee Transfer Setup"
{
    Caption = 'Portal Employee Transfer Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "HR Approver User ID"; Code[50])
        {
            Caption = 'HR Approver User ID';
            TableRelation = "User Setup"."User ID";

            trigger OnValidate()
            var
                HrUserSetup: Record "User Setup";
            begin
                if "HR Approver User ID" = '' then
                    exit;
                if not HrUserSetup.Get("HR Approver User ID") then
                    Error('Business Central User Setup was not found for HR approver %1.', "HR Approver User ID");
            end;
        }
        field(3; "Immediate Supervisor User ID"; Code[50])
        {
            Caption = 'Immediate Supervisor User ID';
            TableRelation = "User Setup"."User ID";

            trigger OnValidate()
            var
                SupervisorUserSetup: Record "User Setup";
            begin
                if "Immediate Supervisor User ID" = '' then
                    exit;
                if not SupervisorUserSetup.Get("Immediate Supervisor User ID") then
                    Error('Business Central User Setup was not found for Immediate Supervisor %1.', "Immediate Supervisor User ID");
            end;
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}
