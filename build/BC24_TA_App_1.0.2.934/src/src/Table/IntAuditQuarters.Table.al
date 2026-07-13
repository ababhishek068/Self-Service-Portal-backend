Table 50355 "Int. Audit Quarters"
{

    fields
    {
        field(1; "Code"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Audit; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Int. Audits".Code;
        }
        field(3; Quarter; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ',1st Quarter,2nd Quarter,3rd Quarter,4th Quarter';
            OptionMembers = ,"1st Quarter","2nd Quarter","3rd Quarter","4th Quarter";
        }
        field(4; Stage; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Pending,Notification,Auditee Response,Draft Report,Final Report,Exit Meeting,Done';
            OptionMembers = Pending,Notification,"Auditee Response","Draft Report","Final Report","Exit Meeting",Done;
        }
        field(5; "Expected Submission Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Actual Submission Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(7; Comments; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(8; Objectives; Text[1000])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Date Created"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Created By"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Last Edited"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Last Editor"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Work Plan"; Text[150])
        {
            CalcFormula = lookup("Int. Audits"."Work Plan" where(Code = field(Audit)));
            FieldClass = FlowField;
        }
        field(15; "Audit Area"; Text[150])
        {
            CalcFormula = lookup("Int. Audits"."Audit Area" where(Code = field(Audit)));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Code", Audit, Quarter)
        {
            Clustered = true;
        }
        key(MyKey; Audit, Quarter)
        {
            Unique = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Code", "Work Plan", "Audit Area", Quarter) { }
    }
}

