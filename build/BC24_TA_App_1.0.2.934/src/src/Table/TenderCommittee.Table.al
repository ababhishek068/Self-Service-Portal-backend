table 50218 "Tender Committee"
{

    fields
    {
        field(1; "Tendor No"; Code[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'No.';
            //TableRelation = "Tender Plan Header"."No.";

            //if get("TPH"."No.")
        }
        field(2; "Tender Description"; Text[250])
        {
            FieldClass = FlowField;
            editable = false;
            CalcFormula = lookup("Tender Plan Header"."Tender Description" where("No." = field("Tendor No")));
        }
        field(3; "Last Modified Date"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Last Modified By"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(5; User; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "HR-Employee"."No." where(Status=const(Active));
            trigger OnValidate()
            begin
                if hremps.Get(User) then begin
                    "Employee Name":=hremps."First Name"+' '+hremps."Middle Name"+' '+hremps."Last Name";
                end;
            end;
        }
        field(6; UserPassword; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(7; Designation; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Member,Chairperson,Vice-Chairperson,Secretary, Co-opted Member';
            OptionMembers = Member,Chairperson,"Vice-Chairperson",Secretary,"Co-opted Member";
        }
        field(8; "Tender Type"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Date Created"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Created By"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(11; Category; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(12; Authenticated; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Committee Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "None","Tender Opening Committee","Tender Evaluation Committee","RFQ Opening Committee","RFQ Evaluation Committee","Contract Implementation Team";

        }
        field(14; Closed; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Authenticated Count"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Tender Committee" WHERE("Tendor No" = FIELD("Tendor No"), "Tender Type" = FIELD("Tender Type"), "Committee Type" = FIELD("Committee Type"), Authenticated = FILTER(true)));
        }
        field(16; "Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Open,"Pending Approval",Approved,Cancelled;
        }
        field(17;"Employee Name";Text[100]){
            Editable=false;
        }

    }


    keys
    {
        key(Key1; "Tendor No", User)
        {
            Clustered = true;
        }
    }

    fieldgroups { }
    //var{}
    //TPH: "Tender Plan Header";

    var

    hremps: Record "HR-Employee";      


}

