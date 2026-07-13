Table 50472 "Current Employment Details"
{

    fields
    {
        field(2; "From Date"; Date) { }
        field(3; "To Date"; Date) { }
        field(4; "Job Title"; Text[100]) { }
        field(5; Department; Text[100]) { }
        field(6; "Duties and Responsibility"; Text[250]) { }
        field(7; "Current Salary"; Code[50]) { }
        field(8; Position; Option)
        {
            OptionCaption = ' ,Junior,Intermediate,Management,Senior Management,Director,Board';
            OptionMembers = " ",Junior,Intermediate,Management,"Senior Management",Director,Board;
        }
        field(9; "Major Achiements"; Text[200]) { }
        field(10; "Contract Type"; Option)
        {
            OptionCaption = ' ,Casual,Contract 1yr,Contract 2yr,Contract 3yr,Gratuity,Missionary,Pension,Short Term Contract,Permanent';
            OptionMembers = " ",Casual,"Contract 1yr","Contract 2yr","Contract 3yr",Gratuity,Missionary,Pension,"Short Term Contract",Permanent;
        }
        field(11; Displinary; Option)
        {
            OptionCaption = 'Warning Letter,Suspension';
            OptionMembers = "Warning Letter",Suspension;
        }
        field(12; "Account No"; Code[30]) { }
        field(13; "Email Address"; Code[30]) { }
        field(14; "Line No"; Integer)
        {
            AutoIncrement = true;
        }
        field(15; "Notice Period"; Option)
        {
            OptionCaption = ' ,Immediately,One Month,Two Months,Three Months,Four Months,Five Months,Six Months,Seven Months,Eight months,Nine Months,Ten Months,Eleven Months,Twelve months';
            OptionMembers = " ",Immediately,"One Month","Two Months","Three Months","Four Months","Five Months","Six Months","Seven Months","Eight months","Nine Months","Ten Months","Eleven Months","Twelve months";
        }
        field(16; "Company Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Curr Supervisor"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Curr Supervisor Title"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Line No", "Account No")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        if "To Date" = 0D then
            "To Date" := Today;
    end;
}

