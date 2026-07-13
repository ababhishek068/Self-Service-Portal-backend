Table 50842 "HR Policies"
{

    fields
    {
        field(1; "Code"; Code[20])
        {
            ToolTip = 'Shows the policy code';
            trigger OnValidate()
            begin
                "Date Created" := Today;
                "Time Created" := Time;
                "Created By" := UserId;
                "Last modified By" := UserId;
                "Last Modified on" := CurrentDateTime;
                "Active?" := true;
            end;

        }
        field(2; Date; Date)
        {

        }
        field(3; "Rules & Regulations"; Text[250]) { }
        field(4; "Document Link"; Text[200]) { }
        field(5; Remarks; Text[200])
        {
            NotBlank = false;
        }
        field(6; "Language Code (Default)"; Code[10]) { }
        field(7; Attachement; Option)
        {
            OptionMembers = No,Yes;
        }
        field(8; Type; Option)
        {
            OptionCaption = ' , ,Is Rules & Regulation","Is Policy","Is Procedure';
            OptionMembers = "Is Rules & Regulation","Is Policy","Is Procedure";
        }

        field(9; Version; Code[20])
        {

        }
        field(10; Department; Code[50])
        {

        }
        field(11; "Date Created"; date)
        {
            Editable = false;
        }
        field(12; "Time Created"; Time)
        {
            Editable = false;
        }
        field(13; "Created By"; Code[50])
        {
            Editable = false;
        }
        field(14; "Last Modified on"; DateTime)
        {
            Editable = false;
        }
        field(15; "Last modified By"; Code[50])
        {
            Editable = false;
        }
        field(16; "Next review date"; Date) { }
        field(17; "Expiry Date"; Date) { }
        field(18; "Active?"; Boolean) { }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    trigger OnModify()
    begin
        "Last modified By" := UserId;
        "Last Modified on" := CurrentDateTime;
    end;

}

