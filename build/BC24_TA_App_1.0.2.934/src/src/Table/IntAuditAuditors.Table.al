Table 50356 "Int. Audit Auditors"
{

    fields
    {
        field(1; "Quarter Code"; Code[20])
        {
            FieldClass = Normal;
            TableRelation = "Int. Audit Quarters".Code;
        }
        field(2; "Auditor ID"; Code[100])
        {
            DataClassification = ToBeClassified;
            TableRelation = "User Setup"."User ID";

        }
        field(3; "Auditor Name"; Text[150])
        {
            CalcFormula = lookup("User Setup".UserName where("User ID" = field("Auditor ID")));
            FieldClass = FlowField;
        }
        field(4; Findings; Text[1000])
        {
            DataClassification = ToBeClassified;
        }
        field(8; Risk; Text[1000])
        {
            DataClassification = ToBeClassified;
        }
        field(12; Remommendation; Text[1000])
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Date Created"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Created By"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Last Edited"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Last Editor"; Code[200])
        {
            DataClassification = ToBeClassified;
        }
        field(20; Auditee; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "User Setup"."User ID";
            trigger OnValidate()
            var
                TbDimension: record Dimension;
                TbUserSetup: record "User Setup";
            begin
                TbUserSetup.Reset();
                TbUserSetup.SetRange("User ID", Auditee);
                if TbUserSetup.FindFirst() then begin
                    TbDimension.Reset();
                    TbDimension.SetRange(Code, TbUserSetup.Department);
                    if TbDimension.FindFirst() then begin
                        "Auditee Department" := TbDimension.Description;
                    end;
                    "Auditee Name" := TbUserSetup.UserName;
                end;
            end;
        }
        field(27; "Auditee Name"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(35; "Auditee Department"; text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(21; "Auditee Response"; Text[500])
        {
            DataClassification = ToBeClassified;
        }
        field(25; "Auditee Response Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'New,Pending,Submittted';
            OptionMembers = New,Pending,Submittted;
        }
        field(26; "Quarter Name"; Option)
        {
            OptionCaption = ',1st Quarter,2nd Quarter,3rd Quarter,4th Quarter';
            OptionMembers = ,"1st Quarter","2nd Quarter","3rd Quarter","4th Quarter";
            FieldClass = FlowField;
            CalcFormula = lookup("Int. Audit Quarters".Quarter where(code = field("Quarter Code")));
        }
        field(28; "Audit Area"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Int. Audit Areas".code;
        }
        field(29; "Audit Area Name"; Text[250])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Int. Audit Areas"."Area of Audit" where(code = field("Audit Area")));

        }
        field(30; "Workplan"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Int. Audit Work Plans".Code;
        }
        field(31; "Workplan Name"; Text[250])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Int. Audit Work Plans".Description where(code = field(Workplan)));
        }
        field(32; "Auditee Submission Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(33; "Objectives"; text[2000])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Int. Audit Areas".Objectives where("Area of Audit" = field("Audit Area")));
            Editable = false;
        }
        field(34; "Indicators"; text[2000])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Int. Audit Areas".Indicators where("Area of Audit" = field("Audit Area")));
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Quarter Code", "Auditor ID")
        {
            Clustered = true;
        }
        key(MyKey; "Auditor ID", "Quarter Code")
        {
            Unique = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Auditor ID", "Auditor Name") { }
    }

}

